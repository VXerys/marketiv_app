import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/campaign_model.dart';
import '../../domain/usecases/create_campaign_usecase.dart';

abstract class CampaignRemoteDataSource {
  Future<List<CampaignModel>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  });
  Future<List<CampaignModel>> getMyCampaigns(String umkmId, {int limit = 20, int offset = 0});
  Future<CampaignModel> getCampaignById(String id);
  Future<CampaignModel> createCampaign(CreateCampaignParams params, String umkmId);
  Future<String> generateBrief({required String namaProduk, required String niche, String? deskripsi});
}

class CampaignRemoteDataSourceImpl implements CampaignRemoteDataSource {
  final Databases _databases;
  final Functions _functions;

  CampaignRemoteDataSourceImpl({
    required Databases databases,
    required Functions functions,
  })  : _databases = databases,
        _functions = functions;

  @override
  Future<List<CampaignModel>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final queries = [
        Query.equal('status', 'Aktif'),
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
        Query.offset(offset),
      ];

      if (niche != null) {
        queries.add(Query.equal('niche', niche));
      }
      if (minHarga != null) {
        queries.add(Query.greaterThanEqual('harga_per_1000_views', minHarga));
      }
      if (maxHarga != null) {
        queries.add(Query.lessThanEqual('harga_per_1000_views', maxHarga));
      }

      final response = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colCampaigns,
        queries: queries,
      );

      return response.documents
          .map((doc) => CampaignModel.fromDocument(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CampaignModel>> getMyCampaigns(String umkmId, {int limit = 20, int offset = 0}) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colCampaigns,
        queries: [
          Query.equal('umkm_id', umkmId),
          Query.orderDesc('\$createdAt'),
          Query.limit(limit),
          Query.offset(offset),
        ],
      );

      return response.documents
          .map((doc) => CampaignModel.fromDocument(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CampaignModel> getCampaignById(String id) async {
    try {
      final response = await _databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colCampaigns,
        documentId: id,
      );

      return CampaignModel.fromDocument(response.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) throw NotFoundException('Kampanye tidak ditemukan');
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CampaignModel> createCampaign(CreateCampaignParams params, String umkmId) async {
    try {
      final data = params.toJson();
      data.addAll({
        'umkm_id': umkmId,
        'status': 'Draft',
        'kuota_terpakai': 0,
      });

      final response = await _databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colCampaigns,
        documentId: ID.unique(),
        data: data,
        permissions: [
          Permission.read(Role.user(umkmId)),
          Permission.update(Role.user(umkmId)),
          Permission.read(Role.users()), // Kreator bisa baca untuk Job Pool
        ],
      );

      return CampaignModel.fromDocument(response.data);
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> generateBrief({
    required String namaProduk,
    required String niche,
    String? deskripsi,
  }) async {
    try {
      final response = await _functions.createExecution(
        functionId: 'generate-brief-fn',
        body: jsonEncode({
          'nama_produk': namaProduk,
          'niche': niche,
          'deskripsi': deskripsi,
        }),
        method: enums.ExecutionMethod.pOST,
      );

      if (response.status == 'completed') {
        final data = jsonDecode(response.responseBody);
        return data['brief'] as String;
      } else {
        throw ServerException('Gagal generate brief: ${response.status}');
      }
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Exception _handleException(AppwriteException e) {
    if (e.code == 401) return UnauthorizedException('Sesi berakhir, silakan login kembali');
    if (e.code == 404) return NotFoundException('Data tidak ditemukan');
    if (e.code == 409) return ConflictException('Data sudah ada');
    return ServerException('Terjadi kesalahan server: ${e.message}');
  }
}
