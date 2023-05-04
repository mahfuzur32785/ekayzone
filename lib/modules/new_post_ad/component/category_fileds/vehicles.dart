import 'package:ekayzone/modules/new_post_ad/component/category_fileds/common_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Localization/app_localizations.dart';
import '../../../../utils/constants.dart';
import '../../controller/new_posted_bloc.dart';
import 'brand_field.dart';
import 'model_field.dart';

class AutoMobileField extends StatefulWidget {
  const AutoMobileField({Key? key, this.categoryId}) : super(key: key);
  final String? categoryId;

  @override
  State<AutoMobileField> createState() => _AutoMobileFieldState();
}

class _AutoMobileFieldState extends State<AutoMobileField> {
  String groupTransmission = '';
  List<String> fuelTypes = [];

  @override
  Widget build(BuildContext context) {
    final postAdBloc = context.read<NewPostAdBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const BrandField(),
        const ModelField(),
        const SizedBox(
          height: 16,
        ),
        CommonField(categoryId: widget.categoryId),
        Text(
          "${AppLocalizations.of(context).translate('trim_edition')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) =>
              previous.edition != current.edition,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewPostAdEventEdition(value));
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
        Text(
          "${AppLocalizations.of(context).translate('year_of_manufacture')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) =>
              previous.vehicle_manufacture != current.vehicle_manufacture,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewPostAdEventYearOfManufacture(value));
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
        Text(
          "${AppLocalizations.of(context).translate('Engine Capacity (cc)')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) =>
              previous.vehicle_engine_capacity != current.vehicle_engine_capacity,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewPostAdEventEngineCapacity(value));
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
                  print(fuelTypes);
                  setState(() {});
                  postAdBloc.add(NewPostAdEventFuelType(fuelTypes));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                        activeColor: redColor,
                        side: const BorderSide(color: redColor, width: 2),
                        value: fuelTypes
                            .any((element) => element == fuelTypeList[index]),
                        onChanged: (value) {
                          if (value!) {
                            fuelTypes.add(fuelTypeList[index]);
                          } else {
                            fuelTypes.remove(fuelTypeList[index]);
                          }
                          print(fuelTypes);
                          setState(() {});
                          postAdBloc.add(NewPostAdEventFuelType(fuelTypes));
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
                  postAdBloc.add(NewPostAdEventTransmission(groupTransmission));
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
                          postAdBloc.add(NewPostAdEventTransmission(groupTransmission));
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
                  postAdBloc.add(NewPostAdEventTransmission(groupTransmission));
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
                  postAdBloc.add(NewPostAdEventTransmission(groupTransmission));
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
                          postAdBloc.add(NewPostAdEventTransmission(groupTransmission));
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
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) =>
              previous.vehicle_body_type != current.vehicle_body_type,
          builder: (context, state) {
            return DropdownButtonFormField(
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
                postAdBloc.add(NewPostAdEventBodyType(value!));
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
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) =>
              previous.registration_year != current.registration_year,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   if (value == "") {
              //     return null;
              //   }
              //   return null;
              // },
              onChanged: (value) {
                postAdBloc.add(NewPostAdEventRegistrationYear(value));
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
