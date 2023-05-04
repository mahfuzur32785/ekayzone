part of 'acc_deletion_bloc.dart';
abstract class AccDeletionState extends Equatable {
  const AccDeletionState();

  @override
  List<Object> get props => [];


}

class AccDeletionStateInitial extends AccDeletionState {
  const AccDeletionStateInitial();
}

class AccDeletionStateLoading extends AccDeletionState {
  const AccDeletionStateLoading();
}

class AccDeletionStateError extends AccDeletionState {
  final String errorMsg;
  final int statusCode;

  const AccDeletionStateError(this.errorMsg, this.statusCode);

  @override
  List<Object> get props => [errorMsg, statusCode];
}

class AccDeletionStateLoaded extends AccDeletionState {
  final String message;

  const AccDeletionStateLoaded(this.message);

  @override
  List<Object> get props => [message];
}