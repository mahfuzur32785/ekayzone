part of 'directory_details_bloc.dart';

class DirectoryDetailsState extends Equatable{
  const DirectoryDetailsState();
  @override
  List<Object> get props => [];
}

class DirectoryDetailsStateInitial extends DirectoryDetailsState {
  const DirectoryDetailsStateInitial();
}

class DirectoryDetailsStateLoading extends DirectoryDetailsState {
  const DirectoryDetailsStateLoading();
}

class DirectoryDetailsStateError extends DirectoryDetailsState {
  final String message;
  final int code;
  const DirectoryDetailsStateError(this.message,this.code);
  @override
  List<Object> get props => [message];
}

class DirectoryDetailsStateLoaded extends DirectoryDetailsState {
  final DirectoryModel directoryModel;
  const DirectoryDetailsStateLoaded(this.directoryModel);
  @override
  List<Object> get props => [directoryModel];
}

// ......... Claim
class DirectoryDetailsStateClaimLoading extends DirectoryDetailsState {
  const DirectoryDetailsStateClaimLoading();
}

class DirectoryDetailsStateClaimError extends DirectoryDetailsState {
  final String message;
  final int code;
  const DirectoryDetailsStateClaimError(this.message,this.code);
  @override
  List<Object> get props => [message];
}
class DirectoryDetailsStateClaimLoaded extends DirectoryDetailsState {
  final String message;
  const DirectoryDetailsStateClaimLoaded(this.message);
  @override
  List<Object> get props => [message];
}