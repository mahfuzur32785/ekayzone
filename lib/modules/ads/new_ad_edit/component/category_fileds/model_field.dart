import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Localization/app_localizations.dart';
import '../../../../home/model/model_model.dart';
import '../../controller/new_ad_edit_bloc.dart';

class EditModelField extends StatefulWidget {
  const EditModelField({Key? key}) : super(key: key);

  @override
  State<EditModelField> createState() => _EditModelFieldState();
}

class _EditModelFieldState extends State<EditModelField> {

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
          "${AppLocalizations.of(context).translate('model')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.model != current.model,
          builder: (context, state) {
            return TextFormField(
              keyboardType: TextInputType.text,
              // inputFormatters: [
              //   FilteringTextInputFormatter.digitsOnly
              // ],
              // initialValue: state.weChat,
              controller: postAdBloc.modelController,
              textInputAction: TextInputAction.next,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return null;
              //     // return 'Enter Your WeChat Number';
              //   }
              //   return null;
              // },
              onChanged: (value) => postAdBloc.add(NewEditAdEventProductModel(value)),
              decoration: const InputDecoration(hintText: "Model"),
            );
          },
        ),
      ],
    );
  }
}
