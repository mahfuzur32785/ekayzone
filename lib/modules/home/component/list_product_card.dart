import 'package:flutter/material.dart';
import 'package:ekayzone/modules/home/component/price_card_widget.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/favorite_button.dart';
import '../../ads/controller/customer_ads/customer_ads_bloc.dart';
import '../../home/model/product_model.dart';
import 'dart:math' as math;

class ListProductCard extends StatelessWidget {
  final AdModel adModel;
  const ListProductCard({
    Key? key,
    required this.adModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userAdBloc = context.read<CustomerAdsBloc>();
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 220,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: const Offset(0, 0),
                blurRadius: 3),
          ],
          color: Colors.white),
      child: InkWell(
        onTap: () {
          if (ModalRoute.of(context)!.settings.name!.contains("adDetails")) {
            Navigator.pushReplacementNamed(context, RouteNames.adDetails,
                arguments: adModel.slug);
          } else {
            Navigator.pushNamed(context, RouteNames.adDetails,
                arguments: adModel.slug);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // border: Border(bottom: BorderSide(color: borderColor)),
      ),
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: CustomImage(
                // path: RemoteUrls.imageUrl(productModel.image),
                //   path: adModel.galleries.isNotEmpty ? adModel.galleries[0].imageUrl : null,
                path: adModel.thumbnail != ''
                    ? '${RemoteUrls.rootUrl2}${adModel.thumbnail}'
                    : null,
                fit: BoxFit.cover),
          ),
          Visibility(
            visible: adModel.featured == "1",
            child: Positioned(
              top: 17,
              left: -10,
              child: Transform.rotate(
                angle: -math.pi / 4.1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF2DBE6C),
                    borderRadius: BorderRadius.circular(10)
                    // borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                  ),
                  child: Text('Featured',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          )

          /*_buildOfferInPercentage(),
          Positioned(
            top: 8,
            left: 8,
            child: FavoriteButton(productId: productModel.id),
          ),*/
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "R${adModel.price.toString()}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                height: 1.5, color: blackColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          SizedBox(
            child: Text(
              adModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey.shade500,
                      size: 16,
                    ),
                    // Icon(Icons.location_on,color: Colors.grey.shade500,size: 16,),
                    Expanded(
                      child: Text(
                        "${adModel.city}",
                        // maxLines: 1,
                        style: TextStyle(color: Colors.grey.shade500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        print("Compare");
                      },
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(
                          Icons.change_circle_outlined,
                          color: Colors.grey.shade500,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey.shade200,
                      child: FavoriteButton(
                        productId: adModel.id,
                        isFav: adModel.isWished,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Icon(Icons.location_on_outlined,color: redColor,size: 16,),
          //     const SizedBox(
          //       width: 8,
          //     ),
          //     Expanded(
          //       child: SizedBox(
          //         child: Text(adModel.address,maxLines: 1,
          //           // overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //     ),
          //     // const Spacer(),
          //     PriceCardWidget(
          //       price: double.parse(adModel.price.toString()),
          //       offerPrice: -1,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }


}
