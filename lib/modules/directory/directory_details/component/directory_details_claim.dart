import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/utils/utils.dart';

import '../controller/directory_details_bloc.dart';

class DirectoryDetailsClaim extends StatelessWidget {
  const DirectoryDetailsClaim({Key? key, required this.postId})
      : super(key: key);
  final int postId;
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DirectoryDetailsBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 50,
        child: BlocListener<DirectoryDetailsBloc, DirectoryDetailsState>(
          listener: (context, state) {
            if (state is DirectoryDetailsStateClaimLoaded) {
              Utils.showSnackBar(context, state.message);
            }
            if (state is DirectoryDetailsStateClaimError) {
              Utils.showSnackBar(context, state.message);
            }
          },
          child: BlocBuilder<DirectoryDetailsBloc, DirectoryDetailsState>(
            builder: (context, state) {
              if (state is DirectoryDetailsStateClaimLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  // bloc.add(DirectoryDetailsEventClaim('aaa@gmail.com', 'nameController.text.trim()', context, '$postId'));

                  final key = GlobalKey<FormState>();
                  var emailController = TextEditingController();
                  var nameController = TextEditingController();
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFFF4F4F4),
                      elevation: 3,
                      // isDismissible: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))),
                      builder: (context) {
                        return DraggableScrollableSheet(
                            initialChildSize: 0.8,
                            maxChildSize: 0.8,
                            minChildSize: 0.8,
                            expand: false,
                            builder: (context, scrollController) {
                              return CustomScrollView(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                slivers: [
                                  const SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 16,
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    sliver: SliverToBoxAdapter(
                                      child: Form(
                                        key: key,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Claim Your Business",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const Divider(
                                              height: 30,
                                            ),
                                            const Text("Name"),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            TextFormField(
                                              controller: nameController,
                                              keyboardType: TextInputType.name,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                  hintText: "Name"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter name';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            const Text("Email"),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            TextFormField(
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: const InputDecoration(
                                                  hintText: "Email"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter email';
                                                } else if (!Utils.isEmail(
                                                    value.trim())) {
                                                  return "Enter valid email";
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            SizedBox(
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                        height: 48,
                                                        child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancel"))),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                        height: 48,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              if (!key
                                                                  .currentState!
                                                                  .validate()) {
                                                                return;
                                                              }
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              bloc.add(DirectoryDetailsEventClaim(
                                                                  emailController
                                                                      .text
                                                                      .trim(),
                                                                  nameController
                                                                      .text
                                                                      .trim(),
                                                                  context,
                                                                  '$postId'));
                                                            },
                                                            child: const Text(
                                                                "Submit"))),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      });
                },
                child: const Text("Claim Your Business"),
              );
            },
          ),
        ),
      ),
    );
  }
}
