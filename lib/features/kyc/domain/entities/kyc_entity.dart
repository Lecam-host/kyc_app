import 'package:equatable/equatable.dart';

class KycEntity extends Equatable {
  final String id;
  final String fullName;
  final String documentId;
  final String? photoPath;
  final bool synced;

  const KycEntity({
    required this.id,
    required this.fullName,
    required this.documentId,
    this.photoPath,
    this.synced = false,
  });

  @override
  List<Object?> get props => [id, fullName, documentId, photoPath, synced];
}
