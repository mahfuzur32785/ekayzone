import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/contact_us_mode.dart';
import '../repository/setting_repository.dart';
part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this.settingRepository) : super(ContactUsStateLoading());

  final SettingRepository settingRepository;

  Future<void> getContactUsContent(bool isLoading) async {
    if (isLoading) emit(ContactUsStateLoading());

    final result = await settingRepository.getContactUsContent();
    result.fold(
      (failuer) {
        emit(ContactUsStateError(errorMessage: failuer.message));
      },
      (data) {
        emit(ContactUsStateLoaded(data));
      },
    );
  }
}
