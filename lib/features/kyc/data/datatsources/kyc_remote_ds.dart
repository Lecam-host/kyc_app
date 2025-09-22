import 'package:dio/dio.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';

abstract class KycRemoteDataSource {
  Future<void> sendKyc(KycModel kyc);
}

class KycRemoteDataSourceImpl implements KycRemoteDataSource {
  final HttpHelper dio;

  KycRemoteDataSourceImpl(this.dio);

  /// 1) Crée l'application KYC, puis 2) uploade chaque document séparément.
  @override
  Future<void> sendKyc(KycModel kyc) async {
    final appResp = await dio.post("/kyc-applications", data: kyc.toJson());

    if (appResp.statusCode != 201) {
      throw Exception(
        "Erreur API (création): ${appResp.statusCode} ${appResp.statusMessage}",
      );
    }

    final appId = appResp.data["kyc_application_id"] ?? appResp.data["id"];
    if (appId == null) {
      throw Exception("Réponse invalide: kyc_application_id manquant.");
    }

    // 2) Upload des documents un par un
    await _uploadDocument(appId, "selfie", kyc.photoPath);
    await _uploadDocument(appId, "recto", kyc.rectoPath);
    if ((kyc.versoPath ?? "").isNotEmpty) {
      await _uploadDocument(appId, "verso", kyc.versoPath!);
    }
  }

  /// Helper: upload 1 document
  Future<void> _uploadDocument(
    String appId,
    String docType,
    String filePath,
  ) async {
    if (filePath.isEmpty) throw Exception("Chemin du fichier '$docType' vide.");

    final form = FormData.fromMap({
      "document_type": docType,
      "file": await MultipartFile.fromFile(
        filePath,
        filename: _fileNameFromPath(filePath),
      ),
    });

    final resp = await dio.post(
      "/kyc-applications/$appId/documents",
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw Exception(
        "Erreur upload $docType: ${resp.statusCode} ${resp.statusMessage}",
      );
    }
  }

  String _fileNameFromPath(String path) {
    return path.split('/').last;
  }
}
