import 'package:flutter/material.dart';
import 'package:ekayzone/modules/directory/model/directory_model.dart';
import 'package:ekayzone/utils/constants.dart';

import '../../../../utils/utils.dart';

class DirectoryDetailsInfo extends StatelessWidget {
  const DirectoryDetailsInfo({Key? key, required this.directoryModel}) : super(key: key);
  final DirectoryModel directoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(5, 5),
            color: Colors.grey.withOpacity(0.1)
          ),
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(-5, -5),
            color: Colors.grey.withOpacity(0.1)
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.watch_later_outlined,size: 16,color: Colors.black54,),
              const SizedBox(
                width: 8,
              ),
              SizedBox(child: Text(Utils.formatDateByMoth(directoryModel.createdAt),style: const TextStyle(color: Colors.black54),),),

              const SizedBox(
                width: 30,
              ),

              const Icon(Icons.remove_red_eye,size: 16,color: Colors.black54,),
              const SizedBox(
                width: 8,
              ),
              SizedBox(child: Text("${directoryModel.totalViews}",style: const TextStyle(color: Colors.black54),),),

            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
              child: Text(directoryModel.title,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),overflow: TextOverflow.ellipsis,)),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ashColor,)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Additional Info",style: TextStyle(fontSize: 16,),),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ashColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ashColor,)
                  ),
                  child: Text("Address : ${directoryModel.address}",style: const TextStyle(fontSize: 14,),),
                ),
                Row(
                  children: [
                    const Text("Head Office : ",style: TextStyle(fontSize: 16,),),
                    GestureDetector(
                      onTap: (){
                        Utils.appLaunchUrl('tel:${directoryModel.phone}');
                      },
                        child: Text(directoryModel.phone,style: const TextStyle(color: Colors.blue,fontSize: 16,),)),
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
