import 'package:hive/hive.dart';
import '../../domain/entities/kyc_entity.dart';

//part 'kyc_model.g.dart';

@HiveType(typeId: 1)
class KycModel extends KycEntity {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  final String fullName;

  @override
  @HiveField(2)
  final String documentId;

  @override
  @HiveField(3)
  final String? photoPath;

  @override
  @HiveField(4)
  final bool synced;

  const KycModel({
    required this.id,
    required this.fullName,
    required this.documentId,
    this.photoPath,
    this.synced = false,
  }) : super(
         id: id,
         fullName: fullName,
         documentId: documentId,
         photoPath: photoPath,
         synced: synced,
       );

  factory KycModel.fromJson(Map<String, dynamic> json) {
    return KycModel(
      id: json['id'],
      fullName: json['fullName'],
      documentId: json['documentId'],
      photoPath: json['photoPath'],
      synced: json['synced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "documentId": documentId,
    "photoPath": photoPath,
    "synced": synced,
  };
}
