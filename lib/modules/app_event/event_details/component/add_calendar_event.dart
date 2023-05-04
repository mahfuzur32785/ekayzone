import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/app_event/model/event_model.dart';
import 'package:ekayzone/utils/utils.dart';

class AddCalendarEvent extends StatelessWidget {
  const AddCalendarEvent({Key? key, required this.eventModel})
      : super(key: key);
  final EventModel eventModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            String gCalenderUrl = "https://calendar.google.com/calendar/u/0/r/eventedit?dates=${eventModel.startDate}|${eventModel.endDate}&text=${eventModel.title}&details=${eventModel.shortDescription}&location=Vanuatu&trp=false&ctz=${eventModel.timezone}&sprop=${eventModel.eventInfoLink}";
            Utils.appLaunchUrl(gCalenderUrl);
          },
          child: const Text("Add To Google Calender"),
        ),
      ),
    );
  }
}
