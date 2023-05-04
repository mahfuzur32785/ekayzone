part of 'my_directory_bloc.dart';

abstract class MyDirectoryState extends Equatable {
  const MyDirectoryState();

  @override
  List<Object> get props => [];
}

class MyDirectoryStateInitial extends MyDirectoryState {
  const MyDirectoryStateInitial();
}

class MyDirectoryStateLoading extends MyDirectoryState {
  const MyDirectoryStateLoading();
}

class MyDirectoryStateLoadMore extends MyDirectoryState {
  const MyDirectoryStateLoadMore();
}

class MyDirectoryStateError extends MyDirectoryState {
  final String message;
  final int statusCode;

  const MyDirectoryStateError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class MyDirectoryStateMoreError extends MyDirectoryState {
  final String message;
  final int statusCode;

  const MyDirectoryStateMoreError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class MyDirectoryStateLoaded extends MyDirectoryState {
  final List<DirectoryModel> adList;
  const MyDirectoryStateLoaded(this.adList);

  @override
  List<Object> get props => [adList];
}

class MyDirectoryStateMoreLoaded extends MyDirectoryState {
  final List<DirectoryModel> adList;
  const MyDirectoryStateMoreLoaded(this.adList);

  @override
  List<Object> get props => [adList];
}
