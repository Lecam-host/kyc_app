import 'package:equatable/equatable.dart';
import '../../domain/entities/kyc_entity.dart';

abstract class KycState extends Equatable {
  const KycState();

  @override
  List<Object?> get props => [];
}

class KycInitial extends KycState {}

class KycLoading extends KycState {}

class KycLoaded extends KycState {
  final List<KycEntity> kycs;

  const KycLoaded(this.kycs);

  @override
  List<Object?> get props => [kycs];
}

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
