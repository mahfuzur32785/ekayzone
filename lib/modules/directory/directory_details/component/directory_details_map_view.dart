import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/directory_model.dart';

class DirectoryDetailsMapView extends StatelessWidget {
  DirectoryDetailsMapView({Key? key, required this.directoryModel}) : super(key: key);
  final DirectoryModel directoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.width * 1.6,
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
      child: WebView(
        initialUrl: directoryModel.map,
        javascriptMode: JavascriptMode.unrestricted,
        // gestureNavigationEnabled: true,
        gestureRecognizers: gestureRecognizers,
      )
    );
  }

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
}
