import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/contact_us_form_bloc/contact_us_form_bloc.dart';

class ContactUsFormWidget extends StatelessWidget {
  const ContactUsFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsFormBloc, ContactUsFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status is ContactUsFormStatusError) {
          final status = state.status as ContactUsFormStatusError;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(status.errorMessage,
                      style: const TextStyle(color: Colors.red))),
            );
        } else if (state.status is ContactUsFormStatusLoaded) {
          final status = state.status as ContactUsFormStatusLoaded;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(status.message)));
        }
      },
      child: const _FormWidget(),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactUsFormBloc = context.read<ContactUsFormBloc>();
    return Form(
      key: contactUsFormBloc.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Us A Message',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, height: 1.5),
          ),
          const SizedBox(height: 8),
          BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
              buildWhen: (previous, current) => previous.name != current.name,
              builder: (context, state) {
                return TextFormField(
                  keyboardType: TextInputType.name,
                  // initialValue: state.name,
                  controller: contactUsFormBloc.nameCtr,
                  validator: (s) => state.isNameValide ? null : "Name required",
                  onChanged: (value) =>
                      contactUsFormBloc.add(ContactUsFormNameChange(value)),
                  decoration: InputDecoration(
                    hintText: 'Full name',
                    fillColor: borderColor.withOpacity(.10),
                  ),
                );
              }),
          const SizedBox(height: 16),
          BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
              buildWhen: (previous, current) => previous.email != current.email,
              builder: (context, state) {
                return TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  // initialValue: state.email,
                  controller: contactUsFormBloc.emailCtr,
                  validator: (s) =>
                      state.isEmailValide ? null : "Email required",
                  onChanged: (value) =>
                      contactUsFormBloc.add(ContactUsFormEmailChange(value)),
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    fillColor: borderColor.withOpacity(.10),
                  ),
                );
              }),
          // const SizedBox(height: 16),
          // BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
          //     buildWhen: (previous, current) => previous.phone != current.phone,
          //     builder: (context, state) {
          //       return TextFormField(
          //         keyboardType: TextInputType.phone,
          //         initialValue: state.phone,
          //         onChanged: (value) =>
          //             contactUsFormBloc.add(ContactUsFormPhoneChange(value)),
          //         decoration: InputDecoration(
          //           hintText: 'Phone',
          //           fillColor: borderColor.withOpacity(.10),
          //         ),
          //       );
          //     }),
          const SizedBox(height: 16),
          BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
              buildWhen: (previous, current) =>
                  previous.subject != current.subject,
              builder: (context, state) {
                return TextFormField(
                  keyboardType: TextInputType.text,
                  // initialValue: state.subject,
                  controller: contactUsFormBloc.subjectCtr,
                  validator: (s) =>
                      state.isSubjectValide ? null : "Subject required",
                  onChanged: (value) =>
                      contactUsFormBloc.add(ContactUsFormSubjectChange(value)),
                  decoration: InputDecoration(
                    hintText: 'Subject',
                    fillColor: borderColor.withOpacity(.10),
                  ),
                );
              }),
          const SizedBox(height: 16),
          BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
              buildWhen: (previous, current) =>
                  previous.message != current.message,
              builder: (context, state) {
                return TextFormField(
                  keyboardType: TextInputType.multiline,
                  // initialValue: state.message,
                  controller: contactUsFormBloc.messageCtr,
                  validator: (s) =>
                      state.isMessageValide ? null : "Message required",
                  onChanged: (value) =>
                      contactUsFormBloc.add(ContactUsFormMessageChange(value)),
                  decoration: InputDecoration(
                    hintText: 'Message',
                    fillColor: borderColor.withOpacity(.10),
                  ),
                  minLines: 5,
                  maxLines: null,
                );
              }),
          const SizedBox(height: 20),
          BlocBuilder<ContactUsFormBloc, ContactUsFormState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return state.status is ContactUsFormStatusLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: 'Send Now',
                      onPressed: () {
                        Utils.closeKeyBoard(context);
                        contactUsFormBloc.add(const ContactUsFormSubmit());
                      },
                    );
            },
          )
        ],
      ),
    );
  }
}
