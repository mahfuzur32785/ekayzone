part of 'directory_details_bloc.dart';

abstract class DirectoryDetailsEvent extends Equatable {
  const DirectoryDetailsEvent();

  @override
  List<Object> get props => [];
}

class DirectoryDetailsEventGetData extends DirectoryDetailsEvent {
  final int id;
  final String slug;
  const DirectoryDetailsEventGetData(this.id, this.slug, );

  @override
  List<Object> get props => [id,slug];
}

class DirectoryDetailsEventContactAuthor extends DirectoryDetailsEvent {
  final String email;
  final String message;
  final String postId;
  const DirectoryDetailsEventContactAuthor(this.email, this.message,this.postId );

  @override
  List<Object> get props => [email,message,postId];
}

class DirectoryDetailsEventClaim extends DirectoryDetailsEvent {
  final String email;
  final String name;
  final String postId;
  final BuildContext context;
  const DirectoryDetailsEventClaim(this.email, this.name, this.context,this.postId );

  @override
  List<Object> get props => [email,name,context,postId];
}
