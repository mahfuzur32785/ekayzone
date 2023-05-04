part of 'faq_cubit.dart';

abstract class FaqCubitState extends Equatable {
  const FaqCubitState();

  @override
  List<Object> get props => [];
}

class FaqCubitStateLoading extends FaqCubitState {
  const FaqCubitStateLoading();
}

class FaqCubitStateError extends FaqCubitState {
  final String errorMessage;
  const FaqCubitStateError({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class FaqCubitStateLoaded extends FaqCubitState {
  final List<FaqCategoryModel> faqCategoryList;
  const FaqCubitStateLoaded({required this.faqCategoryList});

  FaqCubitStateLoaded copyWith({List<FaqCategoryModel>? faqCategoryList}) {
    return FaqCubitStateLoaded(faqCategoryList: faqCategoryList ?? this.faqCategoryList);
  }

  @override
  List<Object> get props => [faqCategoryList];
}
