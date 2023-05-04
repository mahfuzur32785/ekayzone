import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/ad_details/controller/ad_details_state.dart';
import 'package:ekayzone/modules/ad_details/repository/ad_details_repository.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';

class AdDetailsCubit extends Cubit<AdDetailsState>{
  AdDetailsCubit(this.adDetailsRepository, this.loginBloc) : super(const AdDetailsStateLoading());
  final AdDetailsRepository adDetailsRepository;
  final LoginBloc loginBloc;

  Future<void> getAdDetails(String slug, bool isLoading) async {
    if (isLoading) {
      emit(const AdDetailsStateLoading());
    }

    String token = '';
    if (loginBloc.userInfo != null) {
      token = '${loginBloc.userInfo?.accessToken}';
    }

    final result = await adDetailsRepository.getAdDetails(slug,token);
    result.fold((error) => emit(AdDetailsStateError(error.message)), (data) => emit(AdDetailsStateLoaded(data)));
  }
}