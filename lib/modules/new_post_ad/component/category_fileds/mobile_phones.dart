import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Localization/app_localizations.dart';
import '../../../../utils/constants.dart';
import '../../controller/new_posted_bloc.dart';
import 'brand_field.dart';
import 'model_field.dart';

class MobilePhonesField extends StatefulWidget {
  const MobilePhonesField({Key? key}) : super(key: key);

  @override
  State<MobilePhonesField> createState() => _MobilePhonesFieldState();
}

class _MobilePhonesFieldState extends State<MobilePhonesField> {
  String groupAuthenticity = '';
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
                  postAdBloc.add(NewPostAdEventAuthenticity(groupAuthenticity));
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
                          postAdBloc.add(NewPostAdEventAuthenticity(groupAuthenticity));
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
                  postAdBloc.add(NewPostAdEventAuthenticity(groupAuthenticity));
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
                          postAdBloc.add(NewPostAdEventAuthenticity(groupAuthenticity));
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
        const BrandField(),
        const ModelField(),
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
          validator: (value) {
            if (value == null) {
              return null;
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: "Select RAM",
          ),
          items: ramList.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (value) {
            postAdBloc.add(NewPostAdEventRam(value!));
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
        BlocBuilder<NewPostAdBloc, NewPostAdModalState>(
          buildWhen: (previous, current) => previous.edition != current.edition,
          builder: (context, state) {
            return TextFormField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == "") {
                  return null;
                }
                return null;
              },
              onChanged: (value) {
                postAdBloc.add(NewPostAdEventEdition(value));
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
