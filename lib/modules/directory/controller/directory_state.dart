part of 'directory_bloc.dart';
abstract class DirectoryState extends Equatable {
  const DirectoryState();

  @override
  List<Object> get props => [];
}

class DirectoryStateInitial extends DirectoryState {
  const DirectoryStateInitial();
}

class DirectoryStateLoading extends DirectoryState {
  const DirectoryStateLoading();
}

class DirectoryStateLoadMore extends DirectoryState {
  const DirectoryStateLoadMore();
}

class DirectoryStateError extends DirectoryState {
  final String message;
  final int statusCode;

  const DirectoryStateError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class DirectoryStateMoreError extends DirectoryState {
  final String message;
  final int statusCode;

  const DirectoryStateMoreError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class DirectoryStateLoaded extends DirectoryState {
  final List<DirectoryModel> adList;
  const DirectoryStateLoaded(this.adList);

  @override
  List<Object> get props => [adList];
}

class DirectoryStateMoreLoaded extends DirectoryState {
  final List<DirectoryModel> adList;
  const DirectoryStateMoreLoaded(this.adList);

  @override
  List<Object> get props => [adList];
}
