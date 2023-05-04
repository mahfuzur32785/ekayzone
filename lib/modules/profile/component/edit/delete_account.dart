import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:ekayzone/utils/utils.dart';

import '../../../../Localization/app_localizations.dart';
import '../../controller/edit_profile/ads_edit_profile_cubit.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdEditProfileCubit>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 5))
            ]),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Text(
                    "${AppLocalizations.of(context).translate('delete_account')}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )),
        Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${AppLocalizations.of(context).translate('delete_account_alert')}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black45),
                  ),
                )),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 48,
              child: BlocBuilder<AdEditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileStateDeleteLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  return OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        shadowColor: ashColor,
                        side: const BorderSide(
                            color: Colors.red, strokeAlign: BorderSide.strokeAlignInside),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    onPressed: () {
                      Utils.showCustomDialog(
                          context,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                            height: 230,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("${AppLocalizations.of(context).translate('warning')}!",style: const TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.w500),),
                                ),
                                const Spacer(),
                                const Center(
                                  child: Text("Are you want to delete your account permanently?",style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.w400),),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(foregroundColor: redColor),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text("${AppLocalizations.of(context).translate('cancel')}"),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(foregroundColor: redColor),
                                      onPressed: (){
                                        Navigator.pop(context);
                                        bloc.deleteAccount();
                                      },
                                      child: Text("${AppLocalizations.of(context).translate('ok')}"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          barrierDismissible: true
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: Text(
                      "${AppLocalizations.of(context).translate('delete_account')}",
                      style:
                          const TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
                    ),
                  );
                }
              ),
            )
          ],
        ));
  }
}
