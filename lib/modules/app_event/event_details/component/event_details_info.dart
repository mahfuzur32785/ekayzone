import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ekayzone/modules/app_event/model/event_model.dart';
import 'package:ekayzone/modules/directory/model/directory_model.dart';
import 'package:ekayzone/utils/constants.dart';

import '../../../../utils/utils.dart';

class EventDetailsInfo extends StatelessWidget {
  const EventDetailsInfo({Key? key, required this.eventModel})
      : super(key: key);
  final EventModel eventModel;

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
                color: Colors.grey.withOpacity(0.1)),
            BoxShadow(
                blurRadius: 6,
                offset: const Offset(-5, -5),
                color: Colors.grey.withOpacity(0.1)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                child: Text(
                  "Posted : ",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(
                child: Text(
                  Utils.formatDateByMoth(eventModel.createdAt),
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                child: Text(
                  Utils.formatDateByMoth(eventModel.startDate),
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(
                child: Text(
                  '   -   ',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              SizedBox(
                child: Text(
                  Utils.formatDateByMoth(eventModel.endDate),
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
              child: Text(
            eventModel.title,
            maxLines: 2,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          )),
          const SizedBox(height: 8),
          SizedBox(
              child: Text(
            eventModel.shortDescription,
            maxLines: 4,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          )),
          const SizedBox(height: 8),
          SizedBox(
              child: Html(
                  data: eventModel.details,
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, element) {
                    Utils.appLaunchUrl(url);
                  }
                  )
          ),
        ],
      ),
    );
  }
}
