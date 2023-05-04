part of 'my_directory_bloc.dart';

abstract class MyDirectoryEvent extends Equatable {
  const MyDirectoryEvent();

  @override
  List<Object> get props => [];
}

class MyDirectoryEventSearch extends MyDirectoryEvent {
  const MyDirectoryEventSearch();

  @override
  List<Object> get props => [];
}

class MyDirectoryEventLoadMore extends MyDirectoryEvent {
  const MyDirectoryEventLoadMore();
}
