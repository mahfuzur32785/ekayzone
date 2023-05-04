import 'package:flutter/material.dart';
import 'package:ekayzone/utils/k_images.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/custom_image.dart';
import '../../../ad_details/component/show_single_image.dart';

class DirectoryDetailsImage extends StatelessWidget {
  const DirectoryDetailsImage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (image == '') {
          Utils.showSnackBar(context, "Image Not Found");
          return;
        }
        Navigator.push(
            context,
            Utils.createPageRouteTop(context,ShowSingleImage(
                imageUrl: image
            )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          // image: DecorationImage(
          //   image: NetworkImage(i.imageUrl),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: CustomImage(path: image,fit: BoxFit.contain,),
      ),
    );
  }
}
