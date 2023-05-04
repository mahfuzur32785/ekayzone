import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/Localization/app_localizations.dart';
import 'package:ekayzone/core/router_name.dart';
import 'package:ekayzone/modules/ads/controller/customer_ads/customer_ads_bloc.dart';
import 'package:ekayzone/modules/directory/model/directory_model.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:ekayzone/utils/k_images.dart';
import 'package:ekayzone/utils/utils.dart';
import 'package:ekayzone/widgets/custom_image.dart';

class DirectoryCard extends StatelessWidget {
  final Function deleteAd;
  final DirectoryModel directoryModel;
  const DirectoryCard({
    Key? key,required this.deleteAd, required this.directoryModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, RouteNames.directoryDetails,arguments: directoryModel);
        // Navigator.pushNamed(context, RouteNames.adDetails,arguments: adModel.slug).then((value) {
        //
        // });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        padding: const EdgeInsets.only(right: 10,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: ashColor)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: CustomImage(
                        width: 120,
                        fit: BoxFit.cover,
                        path: directoryModel.thumbnail,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            child: Text('${directoryModel.title}',
                              maxLines: 2,
                              style: const TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis,)),
                        Row(
                          children: [
                            Icon(Icons.local_offer,size: 16,color: Colors.black54,),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(child: SizedBox(child: Text("${directoryModel.municipality}",style: TextStyle(color: Colors.black54),),)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.watch_later_outlined,size: 16,color: Colors.black54,),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(child: Text("${Utils.formatDateByMoth(directoryModel.createdAt)}",style: TextStyle(color: Colors.black54),),),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.person,size: 16,color: Colors.black54,),
                            SizedBox(
                              width: 8,
                            ),
                            SizedBox(child: Text("admin",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black54),),),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
