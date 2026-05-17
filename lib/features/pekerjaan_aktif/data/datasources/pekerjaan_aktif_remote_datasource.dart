import 'package:appwrite/appwrite.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/pekerjaan_model.dart';

abstract class PekerjaanAktifRemoteDataSource {
  Future<List<PekerjaanModel>> getMyPekerjaan(String kreatorId);
  Future<PekerjaanModel> submitBuktiTayang(
    String submissionId,
    String urlBukti,
  );
  Future<PekerjaanModel> getPekerjaanById(String submissionId);
}

class PekerjaanAktifRemoteDataSourceImpl
    implements PekerjaanAktifRemoteDataSource {
  final Databases _databases;

  PekerjaanAktifRemoteDataSourceImpl({required Databases databases})
    : _databases = databases;

  @override
  Future<List<PekerjaanModel>> getMyPekerjaan(String kreatorId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colSubmissions,
        queries: [
          Query.equal('kreator_id', kreatorId),
          Query.orderDesc('\$createdAt'),
          Query.limit(50),
        ],
      );

      final submissions = response.documents;
      final campaigns = await Future.wait(
        submissions.map(
          (submission) => _databases.getDocument(
            databaseId: AppConstants.databaseId,
            collectionId: AppConstants.colCampaigns,
            documentId: submission.data['campaign_id'],
          ),
        ),
      );

      return List<PekerjaanModel>.generate(
        submissions.length,
        (index) => PekerjaanModel.fromDocuments(
          submissions[index].data,
          campaigns[index].data,
        ),
      );
    } on AppwriteException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<PekerjaanModel> getPekerjaanById(String submissionId) async {
    try {
      final submission = await _databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colSubmissions,
        documentId: submissionId,
      );

      final campaign = await _databases.getDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colCampaigns,
        documentId: submission.data['campaign_id'],
      );

      return PekerjaanModel.fromDocuments(submission.data, campaign.data);
    } on AppwriteException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<PekerjaanModel> submitBuktiTayang(
    String submissionId,
    String urlBukti,
  ) async {
    if (!_isValidBuktiUrl(urlBukti)) {
      throw ValidationException(
        'Link harus berupa URL TikTok atau Instagram yang valid',
      );
    }

    try {
      await _databases.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.colSubmissions,
        documentId: submissionId,
        data: {'url_bukti_tayang': urlBukti},
      );

      return await getPekerjaanById(submissionId);
    } on AppwriteException catch (e) {
      throw _handleException(e);
    }
  }

  bool _isValidBuktiUrl(String url) {
    return url.startsWith('https://www.tiktok.com/') ||
        url.startsWith('https://www.instagram.com/');
  }

  Exception _handleException(AppwriteException e) {
    if (e.code == 401) {
      return UnauthorizedException('Sesi berakhir, silakan login kembali');
    }
    if (e.code == 404) {
      return NotFoundException('Data tidak ditemukan');
    }
    return ServerException('Terjadi kesalahan server: ${e.message}');
  }
}
