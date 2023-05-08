import 'package:ekayzone/modules/ads/controller/adlist_bloc.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:ekayzone/widgets/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:ekayzone/modules/home/component/product_card.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../../Localization/app_localizations.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/custom_image.dart';
import '../model/product_model.dart';

class GridProductContainer2 extends StatefulWidget {
  const GridProductContainer2({
    Key? key,
    required this.adModelList, required this.onPressed,
  }) : super(key: key);
  final List<AdModel> adModelList;
  final Function onPressed;

  @override
  State<GridProductContainer2> createState() => GridProductContainer2State();
}

class GridProductContainer2State extends State<GridProductContainer2> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context,constraints){
              if (widget.adModelList.isNotEmpty) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 300,
                  ),
                  itemBuilder: (context,index){
                    return ProductCard(adModel: widget.adModelList[index],from: 'ads_screen',);
                  },
                  itemCount: widget.adModelList.length,
                );
              } else {
                return SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black54)
                        ),
                        child: Text("${AppLocalizations.of(context).translate('ads')} ${AppLocalizations.of(context).translate('not_found_title')}",style: const TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w500),)),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}