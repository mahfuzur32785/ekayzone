import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ekayzone/modules/setting/model/faq_category_model.dart';

import '../../model/faq_model.dart';
import '../repository/setting_repository.dart';

part 'faq_cubit_state.dart';

class FaqCubit extends Cubit<FaqCubitState> {
  FaqCubit(this.settingRepository) : super(const FaqCubitStateLoading());

  final SettingRepository settingRepository;
  late List<FaqCategoryModel> faqCategoryList;

  Future<void> getFaqList(bool isLoading) async {
    if (isLoading) {
      emit(const FaqCubitStateLoading());
    }

    final result = await settingRepository.getFaqList();
    result.fold(
      (failuer) {
        emit(FaqCubitStateError(errorMessage: failuer.message));
      },
      (data) {
        faqCategoryList = data;
        emit(FaqCubitStateLoaded(faqCategoryList: data));
      },
    );
  }
}
