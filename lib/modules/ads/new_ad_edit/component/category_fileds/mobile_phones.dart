import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Localization/app_localizations.dart';
import '../../../../../utils/constants.dart';
import '../../../../ad_details/model/ad_details_model.dart';
import '../../controller/new_ad_edit_bloc.dart';
import 'brand_field.dart';
import 'model_field.dart';

class EditMobilePhonesField extends StatefulWidget {
  const EditMobilePhonesField({Key? key, required this.adModel}) : super(key: key);
  final AdDetails adModel;

  @override
  State<EditMobilePhonesField> createState() => _EditMobilePhonesFieldState();
}

class _EditMobilePhonesFieldState extends State<EditMobilePhonesField> {
  String groupAuthenticity = '';
  String? ram;

  @override
  void initState() {
    groupAuthenticity = widget.adModel.authenticity == null ? '' : widget.adModel.authenticity.toString().toLowerCase().toString();
    // ram = widget.adModel.ram == null ? null : ramList.singleWhere((element) => widget.adModel.ram.toString().contains(element));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postAdBloc = context.read<NewEditAdBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('authenticity')}",
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
                  groupAuthenticity = "original";
                  postAdBloc.add(NewEditAdEventAuthenticity(groupAuthenticity));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      activeColor: redColor,
                      value: "original",
                      groupValue: groupAuthenticity,
                      onChanged: (value) {
                        setState(() {
                          groupAuthenticity = value.toString();
                          postAdBloc.add(NewEditAdEventAuthenticity(groupAuthenticity));
                        });
                      }),
                  const SizedBox(
                    width: 0,
                  ),
                  Text("${AppLocalizations.of(context).translate('original')}"),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupAuthenticity = "refurbished";
                  postAdBloc.add(NewEditAdEventAuthenticity(groupAuthenticity));
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      activeColor: redColor,
                      value: "refurbished",
                      groupValue: groupAuthenticity,
                      onChanged: (value) {
                        setState(() {
                          groupAuthenticity = value.toString();
                          postAdBloc.add(NewEditAdEventAuthenticity(groupAuthenticity));
                        });
                      }),
                  const SizedBox(
                    width: 0,
                  ),
                  Text(
                      "${AppLocalizations.of(context).translate('refurbished')}"),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        const EditBrandField(),
        const EditModelField(),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('ram')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        DropdownButtonFormField(
          value: ram,
          validator: (value) {
            if (value == null) {
              return null;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "${AppLocalizations.of(context).translate('select_ram')}",
          ),
          items: ramList.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (value) {
            ram = value;
            postAdBloc.add(NewEditAdEventRam(value!));
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('edition')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) => previous.edition != current.edition,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              initialValue: state.edition,
              validator: (value) {
                if (value == "") {
                  return null;
                }
                return null;
              },
              onChanged: (value) {
                postAdBloc.add(NewEditAdEventEdition(value));
              },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('Enter the edition of your phone')}",
              ),
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
