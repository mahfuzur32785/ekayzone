import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/remote_urls.dart';
import 'package:ekayzone/modules/app_event/event_details/component/add_calendar_event.dart';
import 'package:ekayzone/modules/app_event/event_details/component/related_event_container.dart';
import 'package:ekayzone/modules/app_event/event_details/controller/event_details_cubit.dart';
import 'package:ekayzone/modules/app_event/model/event_model.dart';
import 'package:ekayzone/modules/directory/directory_details/controller/directory_details_bloc.dart';

import '../../directory/directory_details/component/directory_details_claim.dart';
import '../../directory/directory_details/component/directory_details_image.dart';
import '../../directory/directory_details/component/directory_details_share.dart';
import 'component/event_details_info.dart';
import 'component/event_share_container.dart';

class EventDetailsArguments{
  final EventModel eventModel;
  final List<EventModel> eventList;

  EventDetailsArguments(this.eventModel, this.eventList);
}

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({Key? key, required this.eventModel, required this.eventList})
      : super(key: key);
  final EventModel eventModel;
  final List<EventModel> eventList;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getRelatedEvents();
      // context.read<EventDetailsCubit>().getEventDetails('', true);
    });
  }

  List<EventModel> relatedEventList = [];

  void getRelatedEvents(){
    if (widget.eventModel.categoryId == "" || widget.eventModel.categoryId ==  null) {
      return;
    }
    var jsonData = jsonDecode(widget.eventModel.categoryId) ?? [];
    List<String> categories = List<String>.from(jsonData).map((e) => e).toList();
    print("categories : $categories");
    bool value = false;
    for(EventModel eventModel in widget.eventList){
      value = false;
      if (eventModel.categoryId != '' || eventModel.categoryId != null) {
        var xx = jsonDecode(eventModel.categoryId) ?? [];
        List<String> cats = List<String>.from(xx).map((e) => e).toList();
        print("sub categories : $cats");
        for(String data in cats){
          value = categories.any((element) => element == data);
        }
      }
      if (value) {
        relatedEventList.add(eventModel);
      }
    }
    setState(() {
      print("ccccccccccccccccccccccc ${relatedEventList.length} cccccccccccccccccccc");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
      ),
      body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
        builder: (context, state) {
          // if (state is EventDetailsStateLoading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // if (state is EventDetailsStateError) {
          //   return Center(
          //     child: Text(state.message),
          //   );
          // }
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 8,
                ),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsImage(
                  image: "${RemoteUrls.rootUrl}${widget.eventModel.image}",
                ),
              ),
              SliverToBoxAdapter(
                child: EventDetailsInfo(eventModel: widget.eventModel),
              ),
              SliverToBoxAdapter(
                child: AddCalendarEvent(eventModel: widget.eventModel),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverToBoxAdapter(
                child: EventDetailsShare(
                    eventModel: widget.eventModel),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverToBoxAdapter(
                child: HorizontalRelatedEventContainer(eventList: widget.eventList, title: "Related Events", onPressed: (){}),
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
