import 'package:equatable/equatable.dart';
import '../../domain/entities/kyc_entity.dart';

abstract class KycState extends Equatable {
  const KycState();

  @override
  List<Object?> get props => [];
}

class KycInitial extends KycState {}

class KycLoading extends KycState {}

class KycSuccess extends KycState {
  final String message;

  const KycSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class KycError extends KycState {
  final String message;

  const KycError(this.message);

  @override
  List<Object?> get props => [message];
}

class KycSavedLocal extends KycState {
  final KycEntity kyc;

  const KycSavedLocal({required this.kyc});
}
