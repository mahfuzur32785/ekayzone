import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/router_name.dart';
import '../modules/profile/controller/wish_list/wish_list_cubit.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class FavoriteButton extends StatefulWidget {
  FavoriteButton({Key? key, required this.productId, required this.isFav})
      : super(key: key);
  final int productId;
  bool isFav;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final double height = 28;

  @override
  Widget build(BuildContext context) {
    // print("id : ${widget.productId} & value : ${widget.isFav}");
    return Visibility(
      visible: true,
      child: InkWell(
        onTap: () async {
          final result =
              await context.read<WishListCubit>().addWishList(widget.productId);

          result.fold(
            (failure) {
              // if (failure.statusCode == 1000) {
              //   Utils.showSnackBarWithAction(context, failure.message,(){
              //     Navigator.pushNamed(context, RouteNames.authenticationScreen);
              //   },actionText: "Login",textColor: primaryColor);
              // }else {
              //   Utils.errorSnackBar(context, failure.message);
              // }
              Utils.showSnackBarWithAction(context, failure.message,(){
                Navigator.pushNamed(context, RouteNames.authenticationScreen);
              },actionText: "Login",textColor: primaryColor);
              // Navigator.pushNamed(context, RouteNames.authenticationScreen);
              Utils.errorSnackBar(context, failure.message);
            },
            (success) {
              setState(() {
                widget.isFav = !widget.isFav;
              });
              Utils.showSnackBarWithAction(context, success, () {
                Navigator.pushNamed(context, RouteNames.wishListScreen);
              }, actionText: "show ads", textColor: Colors.white);
            },
          );
        },
        child: widget.isFav
            ? Icon(
                Icons.favorite,
                color: Colors.grey.shade800,
                size: 16,
              )
            : Icon(
                Icons.favorite_outline,
                color: Colors.grey.shade500,
                size: 16,
              ),
      ),
    );
  }
}
