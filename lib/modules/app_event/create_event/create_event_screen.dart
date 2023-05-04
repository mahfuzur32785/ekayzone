import 'dart:convert';
import 'dart:io';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ekayzone/dummy_data/countries.dart';
import 'package:ekayzone/modules/app_event/model/event_params_model.dart';
import 'package:ekayzone/modules/home/model/category_model.dart';
import 'package:ekayzone/utils/utils.dart';

import '../../../utils/constants.dart';
import 'controller/create_event_bloc.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  List<String> statusList = ["Scheduled", "Canceled", "Postponed"];

  Venue? venue;
  String status = 'Scheduled';

  List<Country> countryList = countries;
  var countryController = TextEditingController();
  String flagCode = '';

  List<OrganiserStructure> organiserStructureList = [];

  late CreateEventBloc pageBloc;

  List<String> tempCategoryIdList = [];
  List<String> tempTagIdList = [];

  // ..............
  List<Organiser> insList = [];

  @override
  void initState() {
    // TODO: implement initState
    pageBloc = context.read<CreateEventBloc>();
    super.initState();
    Future.microtask(() {
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      context.read<CreateEventBloc>().add(const CreateEventLoadParams());
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventBloc = context.read<CreateEventBloc>();
    return Scaffold(
      backgroundColor: ashColor,
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: BlocListener<CreateEventBloc, CreateEventModalState>(
        listenWhen: (previous, current) => previous.state != current.state,
        listener: (context, state) {
          if (state.state is CreateEventStateLoading) {
            Utils.loadingDialog(context);
          }
          if (state.state is CreateEventStateError) {
            final status = state.state as CreateEventStateError;
            Utils.closeDialog(context);
            Utils.showSnackBar(context, status.errorMsg);
          }
          if (state.state is CreateEventStateLoaded) {
            final status = state.state as CreateEventStateLoaded;
            Utils.closeDialog(context);
            Utils.showSnackBar(context, status.message);
          }
        },
        child: BlocBuilder<CreateEventBloc, CreateEventModalState>(
          buildWhen: (previous, current) => previous.state != current.state,
          builder: (context, state) {
            if (state.state is CreateEventStateCategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.state is CreateEventStateCategoryError) {
              final status = state.state as CreateEventStateCategoryError;
              return Center(
                child: Text(status.errorMsg),
              );
            }
            if (state.state is CreateEventStateInitial) {
              return const SizedBox();
            }
            // if (state.state is CreateEventStateCategoryLoaded) {
            //   print("............................................ ${eventBloc.venueList.length} ......................................");
            //
            // }
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverToBoxAdapter(
                  child: Form(
                    key: eventBloc.formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        //........... B A S I C  I N F O ...........
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 3,
                                  color: ashColor.withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-5, -5),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Title*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.title != current.title,
                                builder: (context, state) {
                                  return TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: eventBloc.titleController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Event Title';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => eventBloc
                                        .add(CreateEventEvenTitle(value)),
                                    decoration: const InputDecoration(
                                        hintText: "Title"),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Short Description*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.shortDescription !=
                                    current.shortDescription,
                                builder: (context, state) {
                                  return TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller:
                                    eventBloc.shortDescriptionController,
                                    maxLines: 3,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Event Short Description';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => eventBloc.add(
                                        CreateEventEvenShortDescription(
                                            value)),
                                    decoration: const InputDecoration(
                                        hintText: "Short Description"),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Description*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.details != current.details,
                                builder: (context, state) {
                                  return TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: eventBloc.detailsController,
                                    maxLines: 3,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Event Full Description';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => eventBloc
                                        .add(CreateEventEventDetails(value)),
                                    decoration: const InputDecoration(
                                        hintText: "Short Description"),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        //........... T I M E / D A T E ...........
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 3,
                                  color: ashColor.withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-5, -5),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Event Time & Date",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text("Start"),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: BlocBuilder<CreateEventBloc,
                                        CreateEventModalState>(
                                      buildWhen: (previous, current) =>
                                      previous.startDate !=
                                          current.startDate,
                                      builder: (context, state) {
                                        return TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller:
                                          eventBloc.startDateController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Choose Start Date';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            fromSelectDate(context);
                                          },
                                          onChanged: (value) => eventBloc.add(
                                              CreateEventEventStartDate(
                                                  value)),
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black45,
                                              ),
                                              hintText: "Start Date"),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: BlocBuilder<CreateEventBloc,
                                        CreateEventModalState>(
                                      buildWhen: (previous, current) =>
                                      previous.startTime !=
                                          current.startTime,
                                      builder: (context, state) {
                                        return TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller:
                                          eventBloc.startTimeController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              // return 'Choose Start Time';
                                              return null;
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            fromSelectTime(context);
                                          },
                                          onChanged: (value) => eventBloc.add(
                                              CreateEventEventStartTime(
                                                  value)),
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.watch_later_outlined,
                                                color: Colors.black45,
                                              ),
                                              hintText: "Time"),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("End"),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: BlocBuilder<CreateEventBloc,
                                        CreateEventModalState>(
                                      buildWhen: (previous, current) =>
                                      previous.endDate != current.endDate,
                                      builder: (context, state) {
                                        return TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller:
                                          eventBloc.endDateController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Choose End Date';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            toSelectDate(context);
                                          },
                                          onChanged: (value) => eventBloc.add(
                                              CreateEventEventEndDate(value)),
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black45,
                                              ),
                                              hintText: "End Date"),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: BlocBuilder<CreateEventBloc,
                                        CreateEventModalState>(
                                      buildWhen: (previous, current) =>
                                      previous.endTime != current.endTime,
                                      builder: (context, state) {
                                        return TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller:
                                          eventBloc.endTimeController,
                                          textInputAction:
                                          TextInputAction.next,
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              // return 'Choose End Time';
                                              return null;
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            toSelectTime(context);
                                          },
                                          onChanged: (value) => eventBloc.add(
                                              CreateEventEventEndTime(value)),
                                          decoration: const InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.watch_later_outlined,
                                                color: Colors.black45,
                                              ),
                                              hintText: "Time"),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        //........... C A T E G O R Y  T A G  V E N U E ...........
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 3,
                                  color: ashColor.withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-5, -5),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Category*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BsSelectBox(
                                hintText: 'Select Category',
                                validators: [
                                  BsSelectValidator(
                                    validator: (value) {
                                      if (value == null) {
                                        return "Select category";
                                      }
                                      return null;
                                    },
                                  )
                                ],
                                controller: BsSelectBoxController(
                                    multiple: true,
                                    options: eventBloc
                                        .eventParamsModel!.data.categories
                                        .map<BsSelectBoxOption>((e) =>
                                        BsSelectBoxOption(
                                            value: e.id,
                                            text: Text(e.name)))
                                        .toList()),
                                size: boxSize,
                                style: boxStyle,
                                onChange: (item) {
                                  tempCategoryIdList.add(item.getValueAsString());
                                  // tempStringList.clear();
                                  // tempStringList = eventBloc.state.categoryId;
                                  // tempStringList.add(item.getValueAsString());
                                  // print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
                                  eventBloc.add(
                                      CreateEventEventCategoryId(tempCategoryIdList));
                                },
                                onRemoveSelectedItem: (item) {
                                  tempCategoryIdList.remove(item.getValueAsString());
                                  // tempStringList.clear();
                                  // tempStringList = eventBloc.state.categoryId;
                                  // tempStringList.remove(item.getValueAsString());
                                  eventBloc.add(
                                      CreateEventEventCategoryId(tempCategoryIdList));
                                },
                                onClear: () {
                                  tempCategoryIdList = [];
                                  eventBloc.add(
                                      const CreateEventEventCategoryId([]));
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Tag*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BsSelectBox(
                                size: boxSize,
                                style: boxStyle,
                                hintText: 'Select Tag',
                                controller: BsSelectBoxController(
                                    multiple: true,
                                    options: eventBloc
                                        .eventParamsModel!.data.tags
                                        .map<BsSelectBoxOption>((e) =>
                                        BsSelectBoxOption(
                                            value: e.id,
                                            text: Text(e.name)))
                                        .toList()),
                                validators: [
                                  BsSelectValidator(
                                    validator: (value) {
                                      if (value == null) {
                                        return "Select Tags";
                                      }
                                      return null;
                                    },
                                  )
                                ],
                                onChange: (item) {
                                  tempTagIdList.add(item.getValueAsString());
                                  eventBloc.add(CreateEventEventTagId(tempTagIdList));
                                },
                                onRemoveSelectedItem: (item) {
                                  tempTagIdList.remove(item.getValueAsString());
                                  eventBloc.add(CreateEventEventTagId(tempTagIdList));
                                },
                                onClear: () {
                                  tempTagIdList = [];
                                  eventBloc
                                      .add(const CreateEventEventTagId([]));
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Status*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.eventStatus !=
                                    current.eventStatus,
                                builder: (context, state) {
                                  return DropdownButtonFormField(
                                    value: status,
                                    onChanged: (value) {
                                      eventBloc.add(CreateEventEvenStatus(
                                          "${(statusList.indexOf(value!) + 1)}"));
                                      setState(() {
                                        status = value;
                                      });
                                    },
                                    isExpanded: true,
                                    items: statusList
                                        .map<DropdownMenuItem<String>>((e) =>
                                        DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              LayoutBuilder(
                                builder: (p0, p1) {
                                  if (status != statusList[0]) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text("Reason (Optional)"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.eventStatusReason !=
                                              current.eventStatusReason,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .statusReasonController,
                                              textInputAction:
                                              TextInputAction.next,
                                              maxLines: 4,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return null;
                                                }
                                                return null;
                                              },
                                              onChanged: (value) => eventBloc
                                                  .add(CreateEventEventReason(
                                                  value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText:
                                                  "Write something"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              const Text("Venue*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.venueId != current.venueId,
                                builder: (context, state) {
                                  return DropdownButtonFormField<Venue>(
                                    value: venue,
                                    onChanged: (Venue? value) {
                                      if (value?.id == 0) {
                                        eventBloc.add(CreateEventEventVenueId(
                                            "${value?.country}"));
                                      } else {
                                        eventBloc.add(CreateEventEventVenueId(
                                            "${value?.id}"));
                                      }
                                      venue = value!;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please Select Or Create Venue";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Select Venue"),
                                    isExpanded: true,
                                    items: eventBloc.venueList
                                        .map<DropdownMenuItem<Venue>>((e) =>
                                        DropdownMenuItem(
                                            value: e,
                                            child: Text(e.name)))
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.venueId != current.venueId,
                                builder: (context, state) {
                                  if (state.venueId == 'create_new_venue') {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text("Create New Venue"),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Name*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueName !=
                                              current.venueName,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venueNameController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter Venue Name';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  eventBloc.add(
                                                      CreateEventEventVenueName(
                                                          value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText: "Name"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Address*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueAddress !=
                                              current.venueAddress,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venueAddressController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter Address';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) => eventBloc.add(
                                                  CreateEventEventVenueAddress(
                                                      value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText: "Address"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("City*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueCity !=
                                              current.venueCity,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venueCityController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter City';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  eventBloc.add(
                                                      CreateEventEventVenueCity(
                                                          value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText: "City"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Country*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueCountry !=
                                              previous.venueCountry,
                                          builder: (context, state) {
                                            return TypeAheadFormField(
                                              textFieldConfiguration:
                                              TextFieldConfiguration(
                                                controller: eventBloc
                                                    .venueCountryController,
                                                onTap: () {
                                                  setState(() {
                                                    eventBloc
                                                        .venueCountryController
                                                        .text = '';
                                                    flagCode = '';
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Country',
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45),
                                                  // filled: true,
                                                  prefixIcon: flagCode == ''
                                                      ? const SizedBox()
                                                      : Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                        8.0),
                                                    child: Image.asset(
                                                      "assets/flags/${flagCode.toLowerCase()}.png",
                                                      height: 24,
                                                      width: 35,
                                                    ),
                                                  ),
                                                  // fillColor: ashColor,
                                                  suffixIcon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  contentPadding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 14),
                                                ),
                                              ),
                                              suggestionsCallback: (pattern) {
                                                return countryList
                                                    .where((element) => element
                                                    .name
                                                    .toLowerCase()
                                                    .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                                    .take(10)
                                                    .toList();
                                                // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                  title:
                                                  Text(suggestion.name),
                                                  leading: Image.asset(
                                                    'assets/flags/${suggestion.code.toLowerCase()}.png',
                                                    height: 30,
                                                    width: 40,
                                                  ),
                                                );
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox,
                                                  controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (Country suggestion) {
                                                setState(() {
                                                  eventBloc
                                                      .venueCountryController
                                                      .text = suggestion.name;
                                                  flagCode = suggestion.code;
                                                });
                                                eventBloc.add(CreateEventEventVenueCountry(suggestion.name));
                                              },
                                              validator: (value) {
                                                if (value == '') {
                                                  return 'Select Country';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              onSaved: (value) {},
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("State or province*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueState !=
                                              current.venueState,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venueStateController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter State or province';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  eventBloc.add(
                                                      CreateEventEventVenueState(
                                                          value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText:
                                                  "State or province"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Postal Code*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venuePostalCode !=
                                              current.venuePostalCode,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venuePostalCodeController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter Postal Code';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) => eventBloc.add(
                                                  CreateEventEventVenuePostalCode(
                                                      value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText:
                                                  "Postal Code"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Phone Number*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venuePhone !=
                                              current.venuePhone,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venuePhoneController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter Phone Number';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) =>
                                                  eventBloc.add(
                                                      CreateEventEventVenuePhone(
                                                          value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText:
                                                  "Phone Number"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        const Text("Web Site*"),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        BlocBuilder<CreateEventBloc,
                                            CreateEventModalState>(
                                          buildWhen: (previous, current) =>
                                          previous.venueWebsite !=
                                              current.venueWebsite,
                                          builder: (context, state) {
                                            return TextFormField(
                                              keyboardType:
                                              TextInputType.name,
                                              controller: eventBloc
                                                  .venueWebLinkController,
                                              textInputAction:
                                              TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter a web site link';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) => eventBloc.add(
                                                  CreateEventEventVenueWebLink(
                                                      value)),
                                              decoration:
                                              const InputDecoration(
                                                  hintText:
                                                  "Web site url"),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        // ........... O R G A N I S E R ...........
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 3,
                                  color: ashColor.withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-5, -5),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Organiser"),
                              const Divider(
                                height: 32,
                              ),
                              ...List.generate(organiserStructureList.length,
                                      (index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ashColor,
                                          ),
                                          borderRadius: BorderRadius.circular(6)),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text("${index + 1}"),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      organiserStructureList
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                  )),
                                            ],
                                          ),
                                          DropdownButtonFormField(
                                            // value: organiserList[index].organiser,
                                            onChanged: (value) {
                                              setState(() {
                                                organiserStructureList[index] =
                                                    OrganiserStructure(
                                                        organiserStructureList[
                                                        index]
                                                            .organisers,
                                                        organiserStructureList[
                                                        index]
                                                            .nameController,
                                                        organiserStructureList[
                                                        index]
                                                            .phoneController,
                                                        organiserStructureList[
                                                        index]
                                                            .webSiteController,
                                                        organiserStructureList[
                                                        index]
                                                            .emailController,
                                                        value);
                                              });
                                            },
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                                hintText: "Select Organiser"),
                                            items: organiserStructureList[index]
                                                .organisers
                                                .map<DropdownMenuItem<Organiser>>(
                                                    (e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e.name)))
                                                .toList(),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          LayoutBuilder(
                                            builder: (p0, p1) {
                                              if (organiserStructureList[index]
                                                  .organiser
                                                  ?.id ==
                                                  0) {
                                                return Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                      TextInputType.name,
                                                      controller:
                                                      organiserStructureList[
                                                      index]
                                                          .nameController,
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Full Name';
                                                        }
                                                        return null;
                                                      },
                                                      // onChanged: (value) => eventBloc.add(
                                                      //     CreateDirectoryEventTitle(
                                                      //         value)),
                                                      decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                          "Full Name"),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                      TextInputType.name,
                                                      controller:
                                                      organiserStructureList[
                                                      index]
                                                          .phoneController,
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Phone Number';
                                                        }
                                                        return null;
                                                      },
                                                      // onChanged: (value) => eventBloc.add(
                                                      //     CreateDirectoryEventTitle(
                                                      //         value)),
                                                      decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                          "Phone Number"),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                      TextInputType.name,
                                                      controller:
                                                      organiserStructureList[
                                                      index]
                                                          .webSiteController,
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Website Url';
                                                        }
                                                        return null;
                                                      },
                                                      // onChanged: (value) => eventBloc.add(
                                                      //     CreateDirectoryEventTitle(
                                                      //         value)),
                                                      decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                          "Website Url"),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                    TextFormField(
                                                      keyboardType: TextInputType
                                                          .emailAddress,
                                                      controller:
                                                      organiserStructureList[
                                                      index]
                                                          .emailController,
                                                      textInputAction:
                                                      TextInputAction.next,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Enter Email';
                                                        }
                                                        return null;
                                                      },
                                                      // onChanged: (value) => eventBloc.add(
                                                      //     CreateDirectoryEventTitle(
                                                      //         value)),
                                                      decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                          "Email Address"),
                                                    ),
                                                    const SizedBox(
                                                      height: 16,
                                                    ),
                                                  ],
                                                );
                                              }
                                              return const SizedBox();
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      insList.clear();
                                      insList = eventBloc
                                          .eventParamsModel!.data.organiser;
                                      print(
                                          "bbbbbbb ${insList.length} bbbbbbbb");
                                      insList.add(demoOrganiser);
                                      print(
                                          "cccccc ${insList.length} ..........");
                                      organiserStructureList.add(
                                          demoOrganiserStructure(insList));
                                    });
                                  },
                                  child: const Text("Add Organiser"),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        // ........... A D D I T I O N A L  F I E L D S  ...........
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(5, 5),
                                  blurRadius: 3,
                                  color: ashColor.withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-5, -5),
                                  blurRadius: 6,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Additional Fields",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  const Text("Is the event wheelchair?"),
                                  const Spacer(),
                                  BlocBuilder<CreateEventBloc,
                                      CreateEventModalState>(
                                    buildWhen: (previous, current) =>
                                    previous.wheelChair !=
                                        current.wheelChair,
                                    builder: (context, state) {
                                      return Checkbox(
                                          value: state.wheelChair,
                                          activeColor: redColor,
                                          onChanged: (value) {
                                            eventBloc.add(
                                                CreateEventEventWheelChair(
                                                    value!));
                                          });
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  const Text("Accessible"),
                                  const Spacer(),
                                  BlocBuilder<CreateEventBloc,
                                      CreateEventModalState>(
                                    buildWhen: (previous, current) =>
                                    previous.accessible !=
                                        current.accessible,
                                    builder: (context, state) {
                                      return Checkbox(
                                          value: state.accessible,
                                          activeColor: redColor,
                                          onChanged: (value) {
                                            eventBloc.add(
                                                CreateEventEventAccessible(
                                                    value!));
                                          });
                                    },
                                  )
                                ],
                              ),
                              const Text("Even Cost*"),
                              const SizedBox(
                                height: 6,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.cost != current.cost,
                                builder: (context, state) {
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: eventBloc.costController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Event cost';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => eventBloc
                                        .add(CreateEventEventCost(value)),
                                    decoration: const InputDecoration(
                                        hintText: "Cost",
                                        helperText:
                                        "Leave blank to hide the field. Enter a \n0 for events that are free."),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Event Link*"),
                              const SizedBox(
                                height: 16,
                              ),
                              BlocBuilder<CreateEventBloc,
                                  CreateEventModalState>(
                                buildWhen: (previous, current) =>
                                previous.eventInfoLink !=
                                    current.eventInfoLink,
                                builder: (context, state) {
                                  return TextFormField(
                                    keyboardType: TextInputType.url,
                                    controller: eventBloc.eventLinkController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        // return 'Enter Event Link';
                                        return null;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => eventBloc
                                        .add(CreateEventEventLink(value)),
                                    decoration: const InputDecoration(
                                        hintText:
                                        "Enter Url for event information"),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                "Choose Image*",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (_, index) {
                                  if (index == 0) {
                                    return Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(3),
                                        onTap: () {
                                          pickImage().then((value) {
                                            if (value != null) {
                                              eventBloc.add(
                                                  CreateEventEventImage(
                                                      value));
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(3),
                                            border:
                                            Border.all(color: ashColor),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add_circle_outlined,
                                              color: redColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return LayoutBuilder(
                                      builder: (context, constraints) {
                                        if (image == null) {
                                          return const SizedBox();
                                        }
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: Container(
                                            padding: const EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                                color:
                                                ashTextColor.withOpacity(0.4),
                                                borderRadius:
                                                BorderRadius.circular(3)),
                                            child: Image(
                                              // image: FileImage(File(controller.images2![index].path))
                                              image: FileImage(File(image!.path)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      });
                                },
                                itemCount: 2,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0,-10),
                blurRadius: 10,
                color: ashColor.withOpacity(0.1),
            ),
          ]
        ),
        child: ElevatedButton(
          onPressed: (){
            if (!eventBloc.formKey.currentState!.validate()) {
              return;
            }
            getOrganisers();
            print(eventBloc.state.toMap().toString());
            eventBloc.add(const CreateEventEventSubmit());
          },
          style: ElevatedButton.styleFrom(backgroundColor: redColor),
          child: const Text("Create Event"),
        ),
      ),
    );
  }

  List<Organiser> getOrganisers() {
    List<Organiser> finalOrganiser = [];
    for(OrganiserStructure organiserStructure in organiserStructureList){
      finalOrganiser.add(Organiser(id: organiserStructure.organiser!.id, name: organiserStructure.nameController.text, email: organiserStructure.emailController.text, phone: organiserStructure.phoneController.text, website: organiserStructure.webSiteController.text, status: 0));
    }
    pageBloc.add(CreateEventEventOrganiser(finalOrganiser));
    return finalOrganiser;
  }

  final BsSelectBoxController _select1 =
      BsSelectBoxController(multiple: true, options: [
    BsSelectBoxOption(value: 1, text: Text('1fsdf ds')),
    BsSelectBoxOption(value: 2, text: Text('2fdsf ds')),
    BsSelectBoxOption(value: 3, text: Text('3fsdf sd f')),
    BsSelectBoxOption(value: 4, text: Text('1fsd fdf')),
    BsSelectBoxOption(value: 5, text: Text('2 sdf ')),
    BsSelectBoxOption(value: 6, text: Text('3fsdfs')),
    BsSelectBoxOption(value: 7, text: Text('1dfsdf')),
    BsSelectBoxOption(value: 8, text: Text('sfsdf2')),
    BsSelectBoxOption(value: 9, text: Text('3fsdfsfd')),
  ]);

  final BsSelectBoxController _select2 =
      BsSelectBoxController(multiple: true, options: [
    BsSelectBoxOption(value: 1, text: Text('1fsdf ds')),
    BsSelectBoxOption(value: 2, text: Text('2fdsf ds')),
    BsSelectBoxOption(value: 3, text: Text('3fsdf sd f')),
    BsSelectBoxOption(value: 4, text: Text('1fsd fdf')),
    BsSelectBoxOption(value: 5, text: Text('2 sdf ')),
    BsSelectBoxOption(value: 6, text: Text('3fsdfs')),
    BsSelectBoxOption(value: 7, text: Text('1dfsdf')),
    BsSelectBoxOption(value: 8, text: Text('sfsdf2')),
    BsSelectBoxOption(value: 9, text: Text('3fsdfsfd')),
  ]);

  final BsSelectBoxSize boxSize = const BsSelectBoxSize(
    fontSize: 14,
    optionFontSize: 14,
    searchInputFontSize: 14,
  );

  final BsSelectBoxStyle boxStyle = BsSelectBoxStyle(
    fontSize: 15,
    border: Border.all(color: ashColor),
  );

  // .................... Photo Picker ...................
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? base64Image;

  Future<String?> pickImage() async {
    String? imagePath;
    XFile? tempImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (tempImage == null) {
      print("Image doesn't choose!");
      return imagePath;
    } else {
      image = tempImage;
      List<int> imageBytes = await image!.readAsBytes();
      base64Image =
          'data:image/${image!.path.split('.').last};base64,${base64Encode(imageBytes)}';
      setState(() {});

      // return imagePaths;
      return base64Image;
    }
  }

  //.................. Date ...........
  final formatter = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('hh:mm');
  var date;
  var fromDate;
  var toDate;
  var fromTime;
  var toTime;

  /// .......... filter by date .....................
  DateTime fromSelectedDate = DateTime.now();
  DateTime toSelectedDate = DateTime.now();
  // final fromDateController = TextEditingController();
  // final toDateController = TextEditingController();
  fromSelectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: fromSelectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2050),
        initialDatePickerMode: DatePickerMode.year,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Color(0xFF31A3DD),
                surface: Colors.white,
                onSurface: Color(0xFF000000),
              ),
              dialogBackgroundColor: const Color(0xFF31A3DD),
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      fromSelectedDate = newSelectedDate;
      pageBloc.startDateController
        ..text = formatter.format(fromSelectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: pageBloc.startDateController.text.length,
            affinity: TextAffinity.upstream));
      fromDate = pageBloc.startDateController.text;
      pageBloc.add(CreateEventEventStartDate("$fromDate"));
      setState(() {});
    }
  }

  toSelectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: toSelectedDate,
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(2020),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Color(0xFF31A3DD),
                surface: Colors.white,
                onSurface: Color(0xFF000000),
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      toSelectedDate = newSelectedDate;
      pageBloc.endDateController
        ..text = formatter.format(toSelectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: pageBloc.endDateController.text.length,
            affinity: TextAffinity.upstream));
      toDate = pageBloc.endDateController.text;
      pageBloc.add(CreateEventEventEndDate("$toDate"));
      setState(() {});
    }
  }

  /// .......... time choose .....................
  TimeOfDay fromSelectedTime = TimeOfDay.now();
  TimeOfDay toSelectedTime = TimeOfDay.now();
  // final fromTimeController = TextEditingController();
  // final toTimeController = TextEditingController();
  fromSelectTime(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: toSelectedTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: redColor,
              onPrimary: Color(0xFF31A3DD),
              surface: Colors.white,
              onSurface: Color(0xFF000000),
            ),
            dialogBackgroundColor: Colors.blue[500],
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      fromSelectedTime = newTime;
      pageBloc.startTimeController
        ..text = newTime.format(context)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: pageBloc.startTimeController.text.length,
            affinity: TextAffinity.upstream));
      fromTime = pageBloc.startTimeController.text;
      pageBloc.add(CreateEventEventStartTime("$fromTime"));
      setState(() {});
    }
  }

  toSelectTime(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: toSelectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: redColor,
              onPrimary: Color(0xFF31A3DD),
              surface: Colors.white,
              onSurface: Color(0xFF000000),
            ),
            dialogBackgroundColor: Colors.blue[500],
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      toSelectedTime = newTime;
      pageBloc.endTimeController
        ..text = newTime.format(context)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: pageBloc.endTimeController.text.length,
            affinity: TextAffinity.upstream));
      toTime = pageBloc.endTimeController.text;
      pageBloc.add(CreateEventEventEndTime("$toTime"));
      setState(() {});
    }
  }
}

class OrganiserStructure {
  final List<Organiser> organisers;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController webSiteController;
  final TextEditingController emailController;
  Organiser? organiser;

  OrganiserStructure(this.organisers, this.nameController, this.phoneController,
      this.webSiteController, this.emailController, this.organiser);
}

OrganiserStructure demoOrganiserStructure(List<Organiser> organisers) =>
    OrganiserStructure(
        organisers,
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
        null);

Organiser demoOrganiser = Organiser(
    id: 0,
    name: 'Create New Organiser',
    email: '',
    phone: '',
    website: '',
    status: 1);

List<String> organizerNames = ["BASIS", "BEXIMCO", "Create New Organiser"];
