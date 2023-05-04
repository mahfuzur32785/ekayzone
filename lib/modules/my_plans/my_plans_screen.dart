import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/my_plans/controller/plan_billing_cubit.dart';
import 'package:ekayzone/utils/utils.dart';
import 'package:ekayzone/widgets/custom_image.dart';

import '../../utils/constants.dart';

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({Key? key}) : super(key: key);

  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PlanBillingCubit>().getPlanBillingList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_sharp,color: iconThemeColor,),
        ),
      ),
      body: BlocBuilder<PlanBillingCubit,PlanBillingState>(
          builder: (context,state) {
            if (state is PlanBillingStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PlanBillingStateError) {
              return Center(
                child: Text(state.message),
              );
            }
            if (state is PlanBillingStateLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Column(
                          children: [
                            Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Package"),
                                          Text("1 week for R 7.00"),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text( "paid",
                                          style: TextStyle(color: Colors.white, fontSize: 10),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green),
                                          // borderRadius: const BorderRadius.all(Radius.elliptical(100, 30)),
                                          borderRadius: const BorderRadius.all(Radius.circular(3)),
                                          // gradient: LinearGradient(
                                          //   begin: Alignment.topCenter,
                                          //   end: Alignment.bottomCenter,
                                          //   colors: <Color>[
                                          //     AppColors.mainColor.withOpacity(0.9),
                                          //     AppColors.mainColor.withOpacity(0.6),
                                          //   ]
                                          // )
                                        ),
                                        child: Text(
                                          Utils.orderStatus('paid'),
                                          style: const TextStyle(
                                              color:  Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Amount : R0.39",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                  ),
                                  const Text("Date : 25 Mar 2023"),

                                  GestureDetector(
                                    onTap: () {
                                      // Helper.toastMsg("Coming soon...");
                                      // return;
                                      // _createPDF(filename: widget.myOrderModel.orderNumber, context: context, index: widget.index);
                                    },
                                    // onTapDown: _onTapDown,
                                    // onTapUp: _onTapUp,
                                    child: Row(
                                      children: const [
                                        Icon(Icons.download,
                                            size: 24, color: Colors.blue),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "Invoice",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(color: Colors.black12,),
                          ],
                        );
                      },childCount: 2),
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          }
      ),
    );
  }
}
