import 'package:flutter/material.dart';
import 'package:ekayzone/modules/home/component/price_card_widget.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/favorite_button.dart';
import '../../home/model/product_model.dart';

class ProductCard extends StatefulWidget {
  final AdModel? adModel;
  final double? width;
  final String? from;
  final int? index;

  const ProductCard({
    Key? key,
    this.adModel,
    this.width,
    this.from,
    this.index
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  Box<AdModel>? compareBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compareBox = Hive.box<AdModel>('compareList');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteNames.adDetails,
              arguments: widget.adModel!.slug);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage()),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          // PriceCardWidget(
          //   price: double.parse("${adModel!.price}"),
          //   offerPrice: -1,
          // ),
          Text("R${widget.adModel!.price}.00"),
          const SizedBox(height: 2),
          SizedBox(
            child: Text(
              widget.adModel!.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: blackColor, fontWeight: FontWeight.w500, height: 1),
            ),
          ),
          const SizedBox(height: 5),
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
                        "${widget.adModel!.city}",
                        maxLines: 1,
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
                      onTap: () async{
                        if (compareBox!.containsKey(widget.index)) {
                          compareBox!.delete(widget.index);
                          return;
                        }
                        // Map<String, dynamic> compareData = {
                        //   'id': adModel!.id,
                        //   'title': adModel!.title,
                        //   'thumbnail': adModel!.thumbnail,
                        //   'category': adModel!.country,
                        //   'price': adModel!.price,
                        //   'customer': adModel!.customer!.id,
                        // };
                        // await Hive.box('compareList').put(index, compareData);
                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item added to compare list")));
                        compareBox?.put(widget.index, widget.adModel!);
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
                        productId: widget.adModel!.id,
                        isFav: widget.adModel!.isWished,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ashColor)),
      ),
      // height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: CustomImage(
                // path: RemoteUrls.imageUrl(productModel.image),
                path: widget.adModel!.thumbnail != ''
                    ? '${RemoteUrls.rootUrl2}${widget.adModel!.thumbnail}'
                    : null,
                // path: adModel.imageUrl != '' ? adModel.imageUrl : null,
                fit: BoxFit.cover),
          ),
          // _buildOfferInPercentage(),
          widget.from=='home'||widget.from=='public_shop' ? Container() : Positioned(
            top: 8,
            left: 8,
            child:
            FavoriteButton(productId: widget.adModel!.id, isFav: false),
          ),
        ],
      ),
    );
  }
}
