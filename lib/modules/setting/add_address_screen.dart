import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';
import 'package:ekayzone/utils/extensions.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import 'address/controllers/address/address_cubit.dart';
import 'address/controllers/country_state_by_id/country_state_by_id_cubit.dart';
import 'model/address_model.dart';
import 'model/billing_shipping_model.dart';
import 'model/city_model.dart';
import 'model/country_model.dart';
import 'model/country_state_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  CountryModel? _countryModel;
  CountryStateModel? _countryStateModel;
  CityModel? _cityModel;
  AddressModel? addressModel;
  BillingShippingModel? address;

  @override
  void initState() {
    super.initState();
    countries = context.read<LoginBloc>().countries.toSet().toList();
    address = context.read<AddressCubit>().address;

    if (widget.type == 'billing') {
      addressModel = address?.billing;
      if (addressModel != null) {
        _countryModel = context.read<CountryStateByIdCubit>().filterCountryWithCountries(countries, addressModel!.countryId);

        // context.read<CountryStateByIdCubit>().stateList = widget.checkoutResponseModel.states;
        // context.read<CountryStateByIdCubit>().cities = widget.checkoutResponseModel.cities;

        _countryStateModel = context.read<CountryStateByIdCubit>().filterStateWithStates(address!.billingStates!, addressModel!.stateId);
        _cityModel = context.read<CountryStateByIdCubit>().filterCityWithCities(address!.billingCities!, addressModel!.cityId);
      } else {
        _countryModel = null;
        _countryStateModel = null;
        _cityModel = null;
      }
    } else {
      addressModel = address?.shipping;
      if (addressModel != null) {
        _countryModel = context.read<CountryStateByIdCubit>().filterCountryWithCountries(countries, addressModel!.countryId);

        // context.read<CountryStateByIdCubit>().stateList = widget.checkoutResponseModel.states;
        // context.read<CountryStateByIdCubit>().cities = widget.checkoutResponseModel.cities;

        _countryStateModel = context.read<CountryStateByIdCubit>().filterStateWithStates(address!.shippingStates!, addressModel!.stateId);
        _cityModel = context.read<CountryStateByIdCubit>().filterCityWithCities(address!.shippingCities!, addressModel!.cityId);
      } else {
        _countryModel = null;
        _countryStateModel = null;
        _cityModel = null;
      }
    }

    log("$_countryModel , ${addressModel?.country}", name: 'add address');

    // if (_countryModel != null) {
    //   final stateLoadIdCountryId = context.read<CountryStateByIdCubit>().stateLoadIdCountryId;
    //   stateLoadIdCountryId(_countryModel!.id.toString());
    // }
    // if (_countryStateModel != null) {
    //   print("aaaaaaaaaaaaaaaaaaa");
    //   context.read<CountryStateByIdCubit>().cityStateChangeCityFilter(_countryStateModel!);
    // }
    _setValueIntoController();
  }

  void _loadState(CountryModel countryModel) {
    _countryModel = countryModel;
    _countryStateModel = null;
    _cityModel = null;
    // cities = [];
    // stateList = [];

    // setState(() {
    //
    // });

    final stateLoadIdCountryId =
        context.read<CountryStateByIdCubit>().stateLoadIdCountryId;

    stateLoadIdCountryId(countryModel.id.toString());
  }

  void _setValueIntoController() {
    nameCtr.text = addressModel?.name ?? "${context.read<LoginBloc>().userInfo?.user.name}";
    emailCtr.text = addressModel?.email ?? "${context.read<LoginBloc>().userInfo?.user.email}";
    phoneCtr.text = addressModel?.phone ?? "${context.read<LoginBloc>().userInfo?.user.phone}";
    zipCtr.text = addressModel?.zipCode ?? '';
    addressCtr.text = addressModel?.address ?? "${context.read<LoginBloc>().userInfo?.user.address}";
  }

  final nameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final zipCtr = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  List<CountryModel> countries = [];
  // List<CityModel> cities = [];
  // List<CountryStateModel> stateList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: '${widget.type.capitalize()} Address'),
      body: BlocListener<AddressCubit, AddressState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AddressStateUpdating) {
            Utils.loadingDialog(context);
          } else if (state is AddressStateUpdateError) {
            Utils.closeDialog(context);
            Utils.errorSnackBar(context, state.message);
          } else if (state is AddressStateUpdated) {
            Utils.closeDialog(context);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CountryStateByIdCubit, CountryStateByIdState>(
          builder: (context, state) {
            if (state is CountryStateByIdStateLoadied) {
              // stateList = state.stateList;
              // _countryStateModel = context
              //     .read<CountryStateByIdCubit>()
              //     .filterState(addressModel?.stateId ?? 0);
              // if (_countryStateModel != null) {
              //   context
              //       .read<CountryStateByIdCubit>()
              //       .cityStateChangeCityFilter(_countryStateModel!);
              //
              //   _cityModel = context
              //       .read<CountryStateByIdCubit>()
              //       .filterCity(addressModel?.cityId ?? 0);
              // }
            } else if (state is CountryStateByIdCityLoaded) {
              // cities = state.cities;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Address',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5),
                    ),
                    const SizedBox(height: 9),
                    TextFormField(
                      controller: nameCtr,
                      validator: (s) {
                        if (s == null || s.isEmpty) return 'Enter name';
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'full name',
                        fillColor: borderColor.withOpacity(.10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailCtr,
                      validator: (s) {
                        if (s == null || s.isEmpty) return 'Enter email';
                        if (!Utils.isEmail(s)) return "Enter valid email";
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'email address',
                        fillColor: borderColor.withOpacity(.10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneCtr,
                      validator: (s) {
                        if (s == null || s.isEmpty) return 'Enter phone';
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'phone number',
                        fillColor: borderColor.withOpacity(.10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _countryField(countries),
                    const SizedBox(height: 16),
                    stateField(),
                    const SizedBox(height: 16),
                    cityField(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressCtr,
                      validator: (s) {
                        if (s == null || s.isEmpty) return 'Enter address';
                        return null;
                      },
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        fillColor: borderColor.withOpacity(.10),
                        hintText: 'Address',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: zipCtr,
                      validator: (s) {
                        if (s == null || s.isEmpty) return 'Enter zip-code';
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: borderColor.withOpacity(.10),
                        hintText: 'ZipCode',
                      ),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      text: 'Set Address',
                      onPressed: () {
                        if (!_formkey.currentState!.validate()) return;

                        final dataMap = {
                          'name': nameCtr.text.trim(),
                          'email': emailCtr.text.trim(),
                          'phone': phoneCtr.text.trim(),
                          'country': _countryModel!.id.toString(),
                          'state': _countryStateModel!.id.toString(),
                          'city': _cityModel!.id.toString(),
                          'zip_code': zipCtr.text.trim(),
                          'address': addressCtr.text.trim(),
                        };
                        if (widget.type == 'billing') {
                          context.read<AddressCubit>().billingUpdate(dataMap);
                        } else {
                          context.read<AddressCubit>().shippingUpdate(dataMap);
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget cityField() {
    final addressBl = context.read<CountryStateByIdCubit>();
    return DropdownButtonFormField<CityModel>(
      value: _cityModel,
      hint: const Text('City'),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        _cityModel = value;
        if (value == null) return;
      },
      validator: (value) => value == null ? 'field required' : null,
      isDense: true,
      isExpanded: true,
      items: addressBl.cities.map<DropdownMenuItem<CityModel>>((CityModel value) {
        return DropdownMenuItem<CityModel>(
            value: value, child: Text(value.name));
      }).toList(),
    );
  }

  Widget stateField() {
    final addressBl = context.read<CountryStateByIdCubit>();
    return DropdownButtonFormField<CountryStateModel>(
      value: _countryStateModel,
      hint: const Text('State'),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          // borderSide: BorderSide(width: 1, color: CustomColors.lineColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () async {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        if (value == null) return;
        _cityModel = null;
        _countryStateModel = value;
        // cities = [];
        // setState(() {
        //
        // });
        context.read<CountryStateByIdCubit>().cityStateChangeCityFilter(value);
      },
      validator: (value) => value == null ? 'field required' : null,
      isDense: true,
      isExpanded: true,
      items: context.read<CountryStateByIdCubit>().stateList
          .map<DropdownMenuItem<CountryStateModel>>((CountryStateModel value) {
        return DropdownMenuItem<CountryStateModel>(
            value: value, child: Text(value.name));
      }).toList(),
    );
  }

  Widget _countryField(List<CountryModel> countries) {
    return DropdownButtonFormField<CountryModel>(
      value: _countryModel,
      hint: const Text('Country'),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          // borderSide: BorderSide(width: 1, color: CustomColors.lineColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () async {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        if (value == null) return;
        _loadState(value);
      },
      validator: (value) => value == null ? 'field required' : null,
      isDense: true,
      isExpanded: true,
      items:
          countries.map<DropdownMenuItem<CountryModel>>((CountryModel value) {
        return DropdownMenuItem<CountryModel>(
            value: value, child: Text(value.name));
      }).toList(),
    );
  }
}
