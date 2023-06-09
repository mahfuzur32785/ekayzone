import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/dashboard/model/overview_model.dart';
import 'package:ekayzone/modules/price_planing/controller/pricing_repository.dart';

import '../../authentication/controllers/login/login_bloc.dart';
import '../../profile/repository/profile_repository.dart';
import '../../home/model/pricing_model.dart';

part 'pricing_state.dart';

class PricingCubit extends Cubit<PricingState> {
  PricingCubit({
    required PricingRepository pricingRepository,
    required LoginBloc loginBloc,
  })  : _pricingRepository = pricingRepository,
        _loginBloc = loginBloc,
        super(const PricingStateInitial());

  final PricingRepository _pricingRepository;
  final LoginBloc _loginBloc;

  Future<void> getPricingList() async {
    if (_loginBloc.userInfo == null) {
      emit(const PricingStateError('Please sign in',401));
      return;
    }

    emit(const PricingStateLoading());

    final token = _loginBloc.userInfo!.accessToken;

    final result = await _pricingRepository.getPricingList();

    result.fold(
          (failure) {
        emit(PricingStateError(failure.message, failure.statusCode));
      },
          (success) {
        final currentState = PricingStateLoaded(success);
        emit(currentState);
      },
    );
  }
}
