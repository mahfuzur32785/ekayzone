import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/router_name.dart';
import 'package:ekayzone/modules/app_event/event_details/event_details_screen.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:ekayzone/utils/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../Localization/app_localizations.dart';
import '../../main/main_controller.dart';
import '../model/event_model.dart';
import 'controller/my_events_bloc.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final MainController mainController = MainController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
            () => context.read<MyEventsBloc>().add(const MyEventsLoadEvent('', '')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Events"),
      ),
      body: BlocBuilder<MyEventsBloc, MyEventState>(
        builder: (context, state) {
          if (state is MyEventStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyEventStateError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is MyEventStateLoaded) {
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                // SliverToBoxAdapter(
                //   child: Container(
                //       height: MediaQuery.of(context).size.height * 0.9,
                //       padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                //       child: const Center(
                //         child: Text("Coming..."),
                //       )
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: SfCalendar(
                      view: CalendarView.month,
                      showDatePickerButton: false,
                      todayTextStyle: const TextStyle(color: Colors.white),
                      todayHighlightColor: redColor,
                      appointmentTextStyle: const TextStyle(fontSize: 15),
                      appointmentBuilder: (context, calendarAppointmentDetails) {
                        Meeting meeting = calendarAppointmentDetails.appointments.first;
                        return Material(
                          borderRadius: BorderRadius.circular(3),
                          color: redColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(3),
                            onTap: (){
                              EventModel eventModel = state.eventList.singleWhere((element) => element.title == meeting.eventName);
                              Navigator.pushNamed(context, RouteNames.eventDetailsScreen,arguments: EventDetailsArguments(eventModel, state.eventList));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(meeting.eventName,style: const TextStyle(color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                        showAgenda: true,
                        agendaViewHeight: MediaQuery.of(context).size.height * 0.2,
                        agendaItemHeight: 50,
                        agendaStyle: const AgendaStyle(),
                        appointmentDisplayCount: 1,
                      ),
                      onTap: (details){

                      },
                      dataSource: MeetingDataSource(_getDataSource(state.eventList)),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  List<Meeting> _getDataSource(List<EventModel> eventList) {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(days: 2));
    for (EventModel eventModel in eventList) {
      meetings.add(Meeting(eventModel.title, eventModel.startDate,
          eventModel.endDate, const Color(0xFF0F8644), false));
    }
    return meetings;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
