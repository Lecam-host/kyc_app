import 'package:equatable/equatable.dart';

class KycEntity extends Equatable {
  final String id; // identifiant local
  final String fullName;
  final String documentId;
  final String? photoPath; // chemin local photo
  final bool synced; // indique si c’est synchronisé avec le serveur

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
