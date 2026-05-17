import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../campaign/data/models/campaign_model.dart';
import '../models/submission_model.dart';

abstract class JobPoolRemoteDataSource {
  Future<List<CampaignModel>> getActiveCampaigns({
    String? niche,
    double? minHarga,
    double? maxHarga,
    int limit = 20,
    int offset = 0,
  });
  Future<CampaignModel> getCampaignById(String id);
  Future<SubmissionModel> claimCampaign(String campaignId, String kreatorId);
  Future<bool> checkAlreadyClaimed(String campaignId, String kreatorId);
}

class JobPoolRemoteDataSourceImpl implements JobPoolRemoteDataSource {
  final Databases _databases;
  final Functions _functions;

  JobPoolRemoteDataSourceImpl({
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
  Future<bool> checkAlreadyClaimed(String campaignId, String kreatorId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colSubmissions,
        queries: [
          Query.equal('campaign_id', campaignId),
          Query.equal('kreator_id', kreatorId),
        ],
      );

      return response.total > 0;
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SubmissionModel> claimCampaign(
    String campaignId,
    String kreatorId,
  ) async {
    try {
      final alreadyClaimed = await checkAlreadyClaimed(campaignId, kreatorId);
      if (alreadyClaimed) {
        throw ConflictException('Kamu sudah mengklaim kampanye ini');
      }

      final response = await _functions.createExecution(
        functionId: 'claim-campaign-fn',
        body: jsonEncode({
          'campaign_id': campaignId,
          'kreator_id': kreatorId,
        }),
        method: enums.ExecutionMethod.pOST,
      );

      if (response.status != enums.ExecutionStatus.completed) {
        throw ServerException('Gagal mengklaim kampanye');
      }

      final data = jsonDecode(response.responseBody) as Map<String, dynamic>;
      return SubmissionModel.fromDocument(
        data['submission'] as Map<String, dynamic>,
      );
    } on AppwriteException catch (e) {
      throw _handleException(e);
    } on ConflictException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Exception _handleException(AppwriteException e) {
    if (e.code == 401) {
      return UnauthorizedException('Sesi berakhir, silakan login kembali');
    }
    if (e.code == 404) {
      return NotFoundException('Data tidak ditemukan');
    }
    if (e.code == 409) {
      return ConflictException('Konflik data terjadi');
    }
    return ServerException('Terjadi kesalahan server: ${e.message}');
  }
}
