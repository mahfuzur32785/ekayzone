import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/directory/directory_details/controller/directory_details_bloc.dart';
import 'package:ekayzone/utils/utils.dart';

class DirectoryDetailsContact extends StatelessWidget {
  DirectoryDetailsContact({Key? key, required this.postId}) : super(key: key);
  final int postId;

  final formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DirectoryDetailsBloc>();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                offset: const Offset(5, 5),
                color: Colors.grey.withOpacity(0.1)
            ),
            BoxShadow(
                blurRadius: 6,
                offset: const Offset(-5, -5),
                color: Colors.grey.withOpacity(0.1)
            ),
          ]
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contact With Author",style: TextStyle(fontSize: 16,),),
            const Text("Email*"),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter an email';
                } else if (!Utils.isEmail(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              onChanged: (value){},
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 16,),
            const Text("Leave a message*"),
            const SizedBox(height: 6,),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: messageController,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter message';
                }
                return null;
              },
              onChanged: (value){},
              decoration: const InputDecoration(hintText: "Leave a message"),
            ),
            const SizedBox(height: 16,),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  Utils.loadingDialog(context);

                  final result = await bloc.contactWithAuthor(emailController.text.trim(), messageController.text.trim(), postId);

                  result.fold((error) {
                    Utils.closeDialog(context);
                    Utils.showSnackBar(context, error.message);
                  }, (message) {
                    Utils.closeDialog(context);
                    Utils.showSnackBar(context, message);
                    emailController.text = '';
                    messageController.text = '';
                  });

                  // bloc.add(DirectoryDetailsEventContactAuthor(emailController.text.trim(), messageController.text.trim(), '$postId'));
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

