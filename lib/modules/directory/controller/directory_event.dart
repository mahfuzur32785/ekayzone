part of 'directory_bloc.dart';

abstract class DirectoryEvent extends Equatable {
  const DirectoryEvent();

  @override
  List<Object> get props => [];
}

class DirectoryEventSearch extends DirectoryEvent {
  final String search;
  final String paginate;
  final String shortBy;
  final String category;
  const DirectoryEventSearch(this.search, this.paginate, this.shortBy, this.category,);

  @override
  List<Object> get props => [search,paginate,shortBy,category];
}

class DirectoryEventLoadMore extends DirectoryEvent {
  const DirectoryEventLoadMore();
}
