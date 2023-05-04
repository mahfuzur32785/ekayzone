import 'package:flutter/material.dart';
import 'package:ekayzone/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/remote_urls.dart';
import '../../model/directory_model.dart';

class DirectoryDetailsShare extends StatelessWidget {
  const DirectoryDetailsShare({Key? key, required this.directoryModel}) : super(key: key);
  final DirectoryModel directoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Share the directory",style: TextStyle(fontSize: 16,),),
              IconButton(
                onPressed: (){
                  Share.share(
                      '${RemoteUrls.rootUrl}business/details/${directoryModel.id}/${directoryModel.slug}',
                      // 'https://everisamting.com/business/details/10758/83-islands-distillery',
                      subject: 'Click bellow the link to share the directory');
                },
                icon: const Icon(Icons.share,color: Colors.blue,),
              )
            ],
          ),
        ],
      ),
    );
  }
}
