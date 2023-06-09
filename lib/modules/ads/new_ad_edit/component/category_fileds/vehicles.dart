import 'package:ekayzone/modules/ads/new_ad_edit/component/category_fileds/common_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Localization/app_localizations.dart';
import '../../../../../utils/constants.dart';
import '../../../../ad_details/model/ad_details_model.dart';
import '../../controller/new_ad_edit_bloc.dart';
import 'brand_field.dart';
import 'model_field.dart';

class EditAutomobileField extends StatefulWidget {
  const EditAutomobileField({Key? key, required this.adModel, this.categoryId }) : super(key: key);
  final AdDetails adModel;
  final String? categoryId;


  @override
  State<EditAutomobileField> createState() => _EditAutomobileFieldState();
}

class _EditAutomobileFieldState extends State<EditAutomobileField> {
  String groupTransmission = '';
  List<String> fuelTypes = [];
  String? bodyType;

  @override
  void initState() {
    fuelTypes = widget.adModel.vehicleFuleType;
    groupTransmission = widget.adModel.vehicleTransmission ?? '';
    bodyType = widget.adModel.vehicleBodyType == null ? null : vehicleBodyTypeList.singleWhere((element) => element.toLowerCase().contains(widget.adModel.vehicleBodyType.toString().toLowerCase()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postAdBloc = context.read<NewEditAdBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditBrandField(),
        const EditModelField(),
        const SizedBox(
          height: 16,
        ),

        ///CONDITION
        EditCommonField(adModel: widget.adModel, categoryId: '22'),
        const SizedBox(
          height: 16,
        ),

        ///EDITION
        Text(
          "${AppLocalizations.of(context).translate('trim_edition')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.trim_edition != current.trim_edition,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              controller: postAdBloc.trimEditionController,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewEditAdEventTrimEdition(value));
              },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('What is them trim/edition of your Vehicle?')}",
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),

        ///MANUFACTURE
        Text(
          "${AppLocalizations.of(context).translate('year_of_manufacture')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.year_of_manufacture != current.year_of_manufacture,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: postAdBloc.yearOfManuController,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewEditAdEventYearOfManufacture(value));
              },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('When was your Vehicle manufactured?')}",
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ///ENGINE CAPACITY
        Text(
          "${AppLocalizations.of(context).translate('Engine Capacity (cc)')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.engine_capacity != current.engine_capacity,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: postAdBloc.enginCapacityController,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewEditAdEventEngineCapacity(value));
              },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('What is the engine capacity of your Vehicle?')}",
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ///FUEL TYPE
        Text(
          "${AppLocalizations.of(context).translate('fuel_type')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          children: [
            ...List.generate(fuelTypeList.length, (index) {
              return GestureDetector(
                onTap: () {
                  if (fuelTypes
                      .any((element) => element == fuelTypeList[index])) {
                    fuelTypes.remove(fuelTypeList[index]);
                  } else {
                    fuelTypes.add(fuelTypeList[index]);
                  }
                  setState(() {});
                  postAdBloc.add(NewEditAdEventFuelType(fuelTypes));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                        activeColor: redColor,
                        side: const BorderSide(color: redColor, width: 2),
                        value: fuelTypes
                            .any((element) => element.toLowerCase().contains(fuelTypeList[index].toLowerCase().toString())),
                        onChanged: (value) {
                          if (value!) {
                            fuelTypes.add(fuelTypeList[index]);
                          } else {
                            fuelTypes.remove(fuelTypeList[index]);
                          }
                          setState(() {});
                          postAdBloc.add(NewEditAdEventFuelType(fuelTypes));
                        }),
                    const SizedBox(
                      width: 0,
                    ),
                    Text(fuelTypeList[index])
                  ],
                ),
              );
            })
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ///TRANSMISSION
        Text(
          "${AppLocalizations.of(context).translate('transmission')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          // runSpacing: 12,
          // spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  groupTransmission = "manual";
                  postAdBloc.add(NewEditAdEventTransmission(groupTransmission));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      activeColor: redColor,
                      value: "manual",
                      groupValue: groupTransmission,
                      onChanged: (value) {
                        setState(() {
                          groupTransmission = value.toString();
                          postAdBloc.add(NewEditAdEventTransmission(groupTransmission));
                        });
                      }),
                  const SizedBox(
                    width: 0,
                  ),
                  Text("${AppLocalizations.of(context).translate('manual')}"),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupTransmission = "automatic";
                  postAdBloc.add(NewEditAdEventTransmission(groupTransmission));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      activeColor: redColor,
                      value: "automatic",
                      groupValue: groupTransmission,
                      onChanged: (value) {
                        setState(() {
                          groupTransmission = value.toString();
                          // widget.onValueChanged(value.toString());
                        });
                      }),
                  const SizedBox(
                    width: 0,
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('automatic')}"),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupTransmission = "other_transmission";
                  postAdBloc.add(NewEditAdEventTransmission(groupTransmission));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      activeColor: redColor,
                      value: "other_transmission",
                      groupValue: groupTransmission,
                      onChanged: (value) {
                        setState(() {
                          groupTransmission = value.toString();
                          postAdBloc.add(NewEditAdEventTransmission(groupTransmission));
                        });
                      }),
                  const SizedBox(
                    width: 0,
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('other_transmission')}"),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('body_type')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.body_type != current.body_type,
          builder: (context, state) {
            return DropdownButtonFormField(
              value: bodyType,
              // validator: (value) {
              //   if (value == null) {
              //     return null;
              //   }
              //   return null;
              // },
              decoration: const InputDecoration(
                hintText: "Select Body Type",
              ),
              items: vehicleBodyTypeList.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                bodyType = value;
                postAdBloc.add(NewEditAdEventBodyType(value!.toLowerCase().toString()));
              },
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('registration_year')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.registration_year != current.registration_year,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: postAdBloc.registrationYearController,
              validator: (value) {
                if (value == "") {
                  return null;
                }
                return null;
              },
              onChanged: (value) {
                postAdBloc.add(NewEditAdEventRegistrationYear(value));
              },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('When was your Vehicle registered?')}",
              ),
            );
          },
        ),
      ],
    );
  }
}
