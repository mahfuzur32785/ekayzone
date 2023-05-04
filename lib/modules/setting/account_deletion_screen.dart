import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/setting/controllers/acc_deletion/acc_deletion_bloc.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/rounded_app_bar.dart';

class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({Key? key}) : super(key: key);

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {

  int value = -1;
  var rtc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accDeletionBloc = context.read<AccDeletionBloc>();
    return Scaffold(
      // backgroundColor: Colors.pink,
      appBar: RoundedAppBar(
        titleText: 'Account Deletion Request',
      ),
      body: BlocListener<AccDeletionBloc, AccDeletionState>(
        listener: (context, state) {
          if (state is AccDeletionStateError) {
            Utils.errorSnackBar(context, state.errorMsg);
          } else if (state is AccDeletionStateLoaded) {
            Utils.showSnackBar(context, state.message);
            value = -1;
            rtc.text = '';
          }
        },
        child: BlocBuilder<AccDeletionBloc, AccDeletionState>(
          builder: (context, state) {
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey.withOpacity(0.1),
                                offset: const Offset(1,1)
                              )
                            ]
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Why are you deleting your account?",
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              ...List.generate(
                                  accDeletionBloc.reasonList.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      value = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                            value: index,
                                            groupValue: value,
                                            activeColor: redColor,

                                            onChanged: (val){
                                              setState(() {
                                                value = val!;
                                              });
                                            }),
                                        const SizedBox(
                                          width: 0,
                                        ),
                                        Expanded(
                                          child: Text(accDeletionBloc.reasonList[index]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(1,1)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Describe reason why you want to delete this account?",
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600),),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                                child: TextFormField(
                                  maxLines: 3,
                                  controller: rtc,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    hintText: "Write something"
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(1,1)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Deleting account will do the following",
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.w600),),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.cancel_outlined,color: Colors.red,size: 16,),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text("Log you out on all device",style: TextStyle(fontSize: 13),),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.cancel_outlined,color: Colors.red,size: 16,),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text("Delete all of your account information",style: TextStyle(fontSize: 13),),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 50,
                                child: LayoutBuilder(
                                  builder: (context,constraints) {
                                    if (state is AccDeletionStateLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: redColor,
                                        ),
                                      );
                                    }
                                    return ElevatedButton(
                                      onPressed: (){
                                        if (value < 0) {
                                          Utils.showSnackBar(context, "Please Select Reason");
                                          return;
                                        }
                                        accDeletionBloc.add(AccDeletionEventSubmit(accDeletionBloc.reasonList[value],rtc.text));
                                      },
                                      child: const Text("Submit Delete Request",style: TextStyle(color: whiteColor),),
                                    );
                                  }
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
