import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../authentication/controllers/login/login_bloc.dart';
import '../../../../authentication/models/user_login_response_model.dart';
import '../../../../authentication/models/user_prfile_model.dart';
import '../../../../profile/repository/profile_repository.dart';

part 'profile_edit_state.dart';

class ProfileEditCubit extends Cubit<ProfileEditStateModel> {
  final LoginBloc _loginBloc;
  final ProfileRepository _profileRepository;
  final formKey = GlobalKey<FormState>();

  ProfileEditCubit({
    required LoginBloc loginBloc,
    required ProfileRepository profileRepository,
  })  : _loginBloc = loginBloc,
        _profileRepository = profileRepository,
        super(ProfileEditStateModel.init(loginBloc.userInfo!.user));

  void changeName(String value) {
    emit(
      state.copyWith(
        name: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changePhoneCode(String value, iso) {
    emit(
      state.copyWith(
        phoneCode: value,
        iso: iso,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changePhone(String value) {
    emit(
      state.copyWith(
        phone: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeCountry(int value) {
    emit(
      state.copyWith(
        country: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeState(int value) {
    emit(
      state.copyWith(
        state: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeCity(int value) {
    emit(
      state.copyWith(
        city: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeZipCode(String value) {
    emit(
      state.copyWith(
        zipCode: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeAddress(String value) {
    emit(
      state.copyWith(
        address: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  void changeImage(String? value) {
    emit(
      state.copyWith(
        image: value,
        stateStatus: const ProfileEditStateInitial(),
      ),
    );
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(stateStatus: const ProfileEditStateLoading()));

    final result = await _profileRepository.profileUpdate(
        state, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(state.copyWith(
            stateStatus:
                ProfileEditStateError(failure.message, failure.statusCode)));
      },
      (successData) {
        _loginBloc.userInfo?.user.copyWith(
          name: state.name,
          phone: state.phone,
          phoneCode: state.phoneCode,
          iso: state.iso,
          zipCode: state.zipCode,
          address: state.address,
          cityId: state.city,
          countryId: state.country,
          stateId: state.state,
          // image: state.image
        );
        // _loginBloc.userInfo?.copyWith(user: _loginBloc.userInfo?.user);

        _loginBloc.add(UpdateProfileEvent(getUser()));
        // _loginBloc.state.copyWith(state: LoginStateUpdatedProfile(_loginBloc.userInfo!));
        emit(state.copyWith(stateStatus: ProfileEditStateLoaded(successData)));
      },
    );
  }

  UserLoginResponseModel getUser() {
    return UserLoginResponseModel(
      user: getUserData(),
      accessToken: _loginBloc.userInfo!.accessToken,
      expiresIn: _loginBloc.userInfo!.expiresIn,
      tokenType: _loginBloc.userInfo!.tokenType,
    );
  }

  UserProfileModel getUserData() {
    return UserProfileModel(
      id: _loginBloc.userInfo!.user.id,
      image: _loginBloc.userInfo!.user.image,
      imageUrl: _loginBloc.userInfo!.user.imageUrl,
      email: _loginBloc.userInfo!.user.email,
      location: _loginBloc.userInfo!.user.location,
      status: _loginBloc.userInfo!.user.status,
      isVendor: _loginBloc.userInfo!.user.isVendor,
      emailVerified: _loginBloc.userInfo!.user.emailVerified,
      createdAt: _loginBloc.userInfo!.user.createdAt,
      updatedAt: _loginBloc.userInfo!.user.updatedAt,
      name: state.name,
      phone: state.phone,
      phoneCode: state.phoneCode,
      iso: state.iso,
      zipCode: state.zipCode,
      address: state.address,
      cityId: state.city,
      countryId: state.country,
      stateId: state.state,
      emailVerifiedAt: _loginBloc.userInfo!.user.emailVerifiedAt,
      verifyToken: _loginBloc.userInfo!.user.verifyToken,
      username: _loginBloc.userInfo!.user.username,
      showEmail: _loginBloc.userInfo!.user.showEmail,
      receiveEmail: _loginBloc.userInfo!.user.receiveEmail,
    );
  }
}
