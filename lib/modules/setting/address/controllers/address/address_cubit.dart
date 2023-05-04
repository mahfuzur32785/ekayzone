import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../authentication/controllers/login/login_bloc.dart';
import '../../../../profile/repository/profile_repository.dart';
import '../../../model/billing_shipping_model.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final ProfileRepository _profileRepository;
  final LoginBloc _loginBloc;
  AddressCubit({
    required ProfileRepository profileRepository,
    required LoginBloc loginBloc,
  })  : _profileRepository = profileRepository,
        _loginBloc = loginBloc,
        super(const AddressStateInitial());

  BillingShippingModel? address;

  Future<void> getAddress() async {
    emit(const AddressStateLoading());

    final result =
        await _profileRepository.getAddress(_loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateError(failure.message, failure.statusCode));
      },
      (successData) {
        address = successData;
        emit(AddressStateLoaded(successData));
      },
    );
  }

  Future<void> billingUpdate(Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result = await _profileRepository.billingUpdate(
        dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateUpdateError(failure.message, failure.statusCode));
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }

  Future<void> shippingUpdate(Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result = await _profileRepository.shippingUpdate(
        dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateUpdateError(failure.message, failure.statusCode));
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }
}
