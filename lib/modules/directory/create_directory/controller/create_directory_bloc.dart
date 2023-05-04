import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';
import 'package:ekayzone/modules/directory/controller/directory_repository.dart';
import 'package:ekayzone/modules/home/controller/cubit/home_controller_cubit.dart';
import 'package:ekayzone/modules/home/model/category_model.dart';
import 'package:ekayzone/modules/post_ad/controller/postad_repository.dart';
import 'package:ekayzone/utils/utils.dart';

import '../../../../core/error/failure.dart';

part 'create_directory_event.dart';
part 'create_directory_state.dart';

class CreateDirectoryBloc extends Bloc<CreateDirectoryEvent, CreateDirectoryModalState> {
  final DirectoryRepository _directoryRepository;
  final LoginBloc _loginBloc;
  final formKey = GlobalKey<FormState>();

  // List<Category> get categoryList => _homeControllerCubit.homeModel.categories;
  List<Category> categoryList = [];

  List<Brand> subCategoryList = [];
  Brand? subCategory;

  var titleController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  var phoneController = TextEditingController(text: "");
  var backupPhoneController = TextEditingController(text: "");
  var businessProfileController = TextEditingController(text: "");
  var descriptionController = TextEditingController(text: "");
  var locationController = TextEditingController(text: "");

  CreateDirectoryBloc({
    required DirectoryRepository directoryRepository,
    required LoginBloc loginBloc,
  })  : _directoryRepository = directoryRepository,
        _loginBloc = loginBloc,
        super(const CreateDirectoryModalState()) {
    on<CreateDirectoryEventTitle>((event, emit) {
      emit(state.copyWith(title: event.title));
    });
    on<CreateDirectoryEventEmail>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<CreateDirectoryEventCategory>((event, emit) {
      Category category = categoryList.singleWhere((element) => element.id == int.parse(event.category));
      subCategoryList = category.subCategoryList.toSet().toList();
      if (subCategoryList.isNotEmpty) {
        subCategory = subCategoryList[0];
        emit(state.copyWith(subCategory: '${subCategory?.id.toString()}'));
      } else {
        emit(state.copyWith(subCategory: ''));
      }
      emit(state.copyWith(category: event.category));
    });
    on<CreateDirectoryEventSubCategory>((event, emit) {
      subCategory = event.subCategoryData;
      emit(state.copyWith(subCategory: event.subCategory));
    });
    on<CreateDirectoryEventPhone>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });
    on<CreateDirectoryEventBackupPhone>((event, emit) {
      emit(state.copyWith(backupPhone: event.backupPhone));
    });
    on<CreateDirectoryEventBusinessProfile>((event, emit) {
      emit(state.copyWith(businessProfile: event.businessProfile));
    });
    on<CreateDirectoryEventDescription>((event, emit) {
      emit(state.copyWith(description: event.description));
    });
    on<CreateDirectoryEventLocation>((event, emit) {
      locationController.text = event.location;
      emit(state.copyWith(location: event.location));
    });
    on<CreateDirectoryEventImage>((event, emit) {
      emit(state.copyWith(image: event.image));
    });
    on<CreateDirectoryEventLatLng>((event, emit) {
      emit(state.copyWith(lat: event.lat,lng: event.lng));
    });
    on<CreateDirectoryEventSubmit>(_submitDirectory);
    on<CreateDirectoryEventGetBCategory>(_getBusinessCategory);

  }


  Future<void> _submitDirectory(
      CreateDirectoryEventSubmit event,
      Emitter<CreateDirectoryModalState> emit,
      ) async {
    if (!formKey.currentState!.validate()) return;

    if (_loginBloc.userInfo == null) {
      const error = CreateDirectoryStateFormSubmitError("Please Sign in", 401);
      emit(state.copyWith(state: error));
      return;
    }

    final token = _loginBloc.userInfo!.accessToken;

    emit(state.copyWith(state: const CreateDirectoryStateFormSubmitLoading()));
    final bodyData = state.toMap();
    print(event.token);
    print(bodyData.toString());

    final result = await _directoryRepository.createDirectory(state,token);

    result.fold(
          (Failure failure) {
        final error = CreateDirectoryStateFormSubmitError(failure.message, failure.statusCode);
        emit(state.copyWith(state: error));
      },
          (message) async {
        final loadedData = CreateDirectoryStateLoaded(message);
        titleController.text = '';
        emailController.text = '';
        phoneController.text = '';
        backupPhoneController.text = '';
        businessProfileController.text = '';
        descriptionController.text = '';
        locationController.text = '';

        emit(state.copyWith(state: loadedData));

        // emit(state.copyWith(
        //     name: "",
        //     price: "",
        //     category: "",
        //     subCategory: "",
        //     phone: "",
        //     isShowPhone: false,
        //     backupPhone: "",
        //     weChat: "",
        //     description: "",
        //     features: [],
        //     location: "",
        //     images: [],
        //     brand: "",
        //     state: loadedData));
        // await Future.delayed(const Duration(seconds: 1)).then((value) {
        //   emit(state.copyWith(
        //       name: "",
        //       price: "",
        //       category: "",
        //       subCategory: "",
        //       phone: "",
        //       isShowPhone: false,
        //       backupPhone: "",
        //       weChat: "",
        //       description: "",
        //       features: [],
        //       location: "",
        //       images: [],
        //       brand: "",
        //       state: const PostAdStateInitial()
        //   ));
        // });
      },
    );
  }

  Future<void> _getBusinessCategory(
      CreateDirectoryEventGetBCategory event,
      Emitter<CreateDirectoryModalState> emit,
      ) async {
    emit(state.copyWith(state: const CreateDirectoryStateLoading()));
    final result = await _directoryRepository.getDirectoryCategories();
    result.fold((error) {
      print(error.message);
    }, (data) {
      final loaded = CreateDirectoryCategoryStateLoaded(data);
      categoryList = data;
      emit(state.copyWith(state: loaded));
    });
  }



}
