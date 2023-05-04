import 'package:flutter/material.dart';
import 'package:ekayzone/core/router_name.dart';
import 'package:ekayzone/modules/app_event/event_details/component/related_event_card.dart';
import 'package:ekayzone/modules/app_event/event_details/event_details_screen.dart';
import 'package:ekayzone/modules/app_event/model/event_model.dart';

import '../../../../utils/constants.dart';
import '../../../home/component/list_product_card.dart';

class HorizontalRelatedEventContainer extends StatefulWidget {
  const HorizontalRelatedEventContainer({Key? key, required this.eventList, required this.title, required this.onPressed}) : super(key: key);
  final List<EventModel> eventList;
  final String title;
  final Function onPressed;

  @override
  State<HorizontalRelatedEventContainer> createState() => _HorizontalRelatedEventContainerState();
}

class _HorizontalRelatedEventContainerState extends State<HorizontalRelatedEventContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16,),
      margin: const EdgeInsets.symmetric(vertical: 0,),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0,5),
                blurRadius: 3,
                color: ashColor.withOpacity(0.1),
                blurStyle: BlurStyle.inner
            ),
            BoxShadow(
                offset: const Offset(0,-5),
                blurRadius: 3,
                color: ashColor.withOpacity(0.1),
                blurStyle: BlurStyle.inner
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(widget.title,style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    // maxHeight: MediaQuery.of(context).size.width * 1.2,
                    maxHeight: 480,
                    minHeight: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return RelatedEventCard(eventModel: widget.eventList[index],width: MediaQuery.of(context).size.width * 0.9,onPressed: (){
                        Navigator.pushReplacementNamed(context, RouteNames.eventDetailsScreen,arguments: EventDetailsArguments(widget.eventList[index], widget.eventList));
                      },);
                    },
                    itemCount: widget.eventList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 16,
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
