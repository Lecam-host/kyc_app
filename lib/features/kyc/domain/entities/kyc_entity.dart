import 'package:equatable/equatable.dart';

class KycEntity extends Equatable {
  final String fullName;
  final String photoPath;
  final String rectoPath;
  final String? versoPath;
  final String nationality;
  final String birthDate;

  const KycEntity({
    required this.fullName,
    required this.photoPath,
    required this.rectoPath,
    this.versoPath,
    required this.nationality,
    required this.birthDate,
  });

  @override
  List<Object?> get props => [fullName, photoPath];
}
