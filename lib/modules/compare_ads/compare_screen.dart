import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constants.dart';
import '../profile/controller/wish_list/wish_list_cubit.dart';
import 'components/compare_list_container.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {

  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<WishListCubit>().getWishList(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FE),
      appBar: AppBar(
        title: const Text("Compare Ads"),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_sharp,color: iconThemeColor,),
        ),
      ),
      body: BlocBuilder<WishListCubit,WishListState>(
        builder: (context, state) {
          if (state is WishListStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WishListStateError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: redColor),
              ),
            );
          }
          if(state is WishListStateLoaded){
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                CompareListContainer(
                  adModelList: state.adList,
                  title: "",
                  onPressed: (){},
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
