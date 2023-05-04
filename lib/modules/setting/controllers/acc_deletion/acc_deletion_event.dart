part of 'acc_deletion_bloc.dart';

abstract class AccDeletionEvent extends Equatable {
  const AccDeletionEvent();

  @override
  List<Object> get props => [];
}

class AccDeletionEventSubmit extends AccDeletionEvent {
  final String inputReason;
  final String reason;
  const AccDeletionEventSubmit(this.reason,this.inputReason);

  @override
  List<Object> get props => [reason,inputReason];
}
