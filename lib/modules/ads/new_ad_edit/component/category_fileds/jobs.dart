import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../Localization/app_localizations.dart';
import '../../../../../core/remote_urls.dart';
import '../../../../../utils/constants.dart';
import '../../../../ad_details/model/ad_details_model.dart';
import '../../../../home/model/model_model.dart';
import '../../../../new_post_ad/controller/new_posted_bloc.dart';
import '../../controller/new_ad_edit_bloc.dart';

class EditJobsField extends StatefulWidget {
  const EditJobsField({Key? key, required this.adModel}) : super(key: key);
  final AdDetails adModel;

  @override
  State<EditJobsField> createState() => _EditJobsFieldState();
}

class _EditJobsFieldState extends State<EditJobsField> {
  String jobType = jobTypeList[0];
  String education = educationList[0];
  bool applicationAlertEmail = true;
  bool applicationAlertPhone = true;

  Model? designationModel;

  String? employerLogoUrl;

  @override
  void initState() {
    employerLogoUrl = widget.adModel.employerLogo == null ? null : widget.adModel.employerLogo.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postAdBloc = context.read<NewEditAdBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "${AppLocalizations.of(context).translate('Designation')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.designation != current.designation,
          builder: (context, state) {
            designationModel = state.designation == ""
                ? null
                : postAdBloc.designationList.singleWhere((element) =>
                    state.designation == element.title.toString());
            return DropdownButtonFormField(
              value: designationModel,
              // validator: (value) {
              //   if (value == null) {
              //     return null;
              //   }
              //   return null;
              // },
              isExpanded: true,
              decoration: const InputDecoration(
                hintText: "Select Designation",
              ),
              items:
                  postAdBloc.designationList.map<DropdownMenuItem<Model>>((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.title),
                );
              }).toList(),
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 300))
                    .then((value2) {
                  postAdBloc
                      .add(NewEditAdEventDesignation(value!.title.toString()));
                });
              },
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('job_type')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.job_type != current.job_type,
          builder: (context, state) {
            jobType = state.job_type == ""
                ? jobTypeList[0]
                : jobTypeList.singleWhere(
                    (element) => state.job_type.contains(element),
                orElse: () => jobTypeList[0]);
            return DropdownButtonFormField(
              value: jobType,
              // validator: (value) {
              //   if (value == null) {
              //     return null;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('select_job_type')}",
              ),
              items: jobTypeList.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                jobType = value!;
                postAdBloc.add(NewEditAdEventEmploymentType(value));
              },
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "How do you want to receive applications?",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
                buildWhen: (previous, current) =>
                    previous.isShowEmail != current.isShowEmail,
                builder: (context, state) {
                  return SizedBox(
                    width: 30,
                    height: 24,
                    child: Checkbox(
                        value: state.isShowEmail,
                        onChanged: (value) {
                          postAdBloc.add(NewEditAdEventShowEmail(value!));
                        }),
                  );
                }),
            const SizedBox(
              width: 0,
            ),
            Text(
              "${AppLocalizations.of(context).translate('email_and_employer_dashboard')}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
                buildWhen: (previous, current) =>
                    previous.isShowPhone != current.isShowPhone,
                builder: (context, state) {
                  return SizedBox(
                    width: 30,
                    height: 24,
                    child: Checkbox(
                        value: state.isShowPhone,
                        onChanged: (value) {
                          postAdBloc.add(NewEditAdEventShowPhone(value!));
                        }),
                  );
                }),
            const SizedBox(
              width: 0,
            ),
            Text(
              "${AppLocalizations.of(context).translate('phone')}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.isShowEmail != current.isShowEmail,
          builder: (context, state) {
            return Visibility(
              visible: state.isShowEmail,
              maintainAnimation: true,
              maintainState: true,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                opacity: state.isShowEmail ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).translate('email')}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
                      buildWhen: (previous, current) =>
                          previous.phone != current.phone,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          // initialValue: state.phone,
                          controller: postAdBloc.emailController,
                          textInputAction: TextInputAction.next,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return null;
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) =>
                              postAdBloc.add(NewEditAdEventEmail(value)),
                          decoration: InputDecoration(
                              hintText:
                                  "${AppLocalizations.of(context).translate('email')}"),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) =>
              previous.isShowPhone != current.isShowPhone,
          builder: (context, state) {
            return Visibility(
              visible: state.isShowPhone,
              maintainAnimation: true,
              maintainState: true,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                opacity: state.isShowPhone ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).translate('phone')}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
                      buildWhen: (previous, current) =>
                          previous.phone != current.phone,
                      builder: (context, state) {
                        return TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          // initialValue: state.phone,
                          controller: postAdBloc.phoneController,
                          textInputAction: TextInputAction.next,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Enter Phone Number';
                          //   }
                          //   return null;
                          // },
                          onChanged: (value) =>
                              postAdBloc.add(NewEditAdEventPhone(value)),
                          decoration: InputDecoration(
                              hintText:
                                  "${AppLocalizations.of(context).translate('phone')}"),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Text(
          "${AppLocalizations.of(context).translate('required_work_experience_(years)')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          controller: postAdBloc.experienceController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == "") {
              return null;
            }
            return null;
          },
          onChanged: (value) {
            postAdBloc.add(NewEditAdEventExperience(value));
          },
          decoration: InputDecoration(
            hintText: "${AppLocalizations.of(context).translate('years')}",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('required_education')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        BlocBuilder<NewEditAdBloc, NewEditAdModalState>(
          buildWhen: (previous, current) => previous.edition != current.edition,
          builder: (context, state) {
            education = state.educations == ""
                ? educationList[0]
                : educationList.singleWhere(
                    (element) => state.educations.contains(element),
                    orElse: () => educationList[0]);
            return DropdownButtonFormField(
              value: education,
              // validator: (value) {
              //   if (value == null) {
              //     return null;
              //   }
              //   return null;
              // },
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context).translate('select_education')}",
              ),
              items: educationList.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                education = value!;
                postAdBloc.add(NewEditAdEventEducations(education));
              },
            );
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('salary_per_month')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "${AppLocalizations.of(context).translate('from')}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Text(
                "${AppLocalizations.of(context).translate('to')}",
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: postAdBloc.salaryFromController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // validator: (value) {
                //   if (value == "") {
                //     return null;
                //   }
                //   return null;
                // },
                onChanged: (value) {
                  postAdBloc.add(NewEditAdEventSalaryFrom(value));
                },
                decoration: InputDecoration(
                  hintText: "${AppLocalizations.of(context).translate('from')}",
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: postAdBloc.salaryToController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // validator: (value) {
                //   if (value == "") {
                //     return null;
                //   }
                //   return null;
                // },
                onChanged: (value) {
                  postAdBloc.add(NewEditAdEventSalaryTo(value));
                },
                decoration: InputDecoration(
                  hintText: "${AppLocalizations.of(context).translate('to')}",
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('Application Deadline')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.datetime,
          controller: postAdBloc.deadlineController,
          // validator: (value) {
          //   if (value == "") {
          //     return null;
          //   }
          //   return null;
          // },
          onChanged: (value) {
            postAdBloc.add(NewEditAdEventDeadline(value));
          },
          readOnly: true,
          onTap: () {
            chooseDate(context);
          },
          decoration: InputDecoration(
            hintText: "${AppLocalizations.of(context).translate('MM/DD/YYYY')}",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('Employer Name')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          controller: postAdBloc.employerNameController,
          // validator: (value) {
          //   if (value == "") {
          //     return null;
          //   }
          //   return null;
          // },
          onChanged: (value) {
            postAdBloc.add(NewEditAdEventEmployerName(value));
          },
          decoration: InputDecoration(
            hintText:
                "${AppLocalizations.of(context).translate('Employer Name')}",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "${AppLocalizations.of(context).translate('Employer Website')}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 7,
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.url,
          controller: postAdBloc.webSiteController,
          // validator: (value) {
          //   if (value == "") {
          //     return null;
          //   }
          //   return null;
          // },
          onChanged: (value) {
            postAdBloc.add(NewEditAdEventEmployerWebsite(value));
          },
          decoration: InputDecoration(
            hintText:
                "${AppLocalizations.of(context).translate('Employer Website')}",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    pickImage().then((value) {
                      if (value != null) {
                        setState(() {
                          postAdBloc
                              .add(NewEditAdEventEmployeeLogo(base64Image!));
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Attach Logo"),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (image == null) {
                    if (employerLogoUrl != null) {
                      return Center(
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: Image(
                            image: NetworkImage(
                                "${RemoteUrls.rootUrl2}$employerLogoUrl"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Image(
                          // image: FileImage(File(controller.images2![index].path))
                          image: FileImage(File(image!.path)),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            // Expanded(
            //   child: image == null
            //       ? const SizedBox()
            //       : Center(
            //           child: SizedBox(
            //             height: 70,
            //             width: 70,
            //             child: Image(
            //               // image: FileImage(File(controller.images2![index].path))
            //               image: FileImage(File(image!.path)),
            //               fit: BoxFit.contain,
            //             ),
            //           ),
            //         ),
            // )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  //............. Date Choose ...............
  final formatter = DateFormat('yyyy-MM-dd');
  var expiryDate;
  var expiryDateController = TextEditingController();
  DateTime expirySelectedDate = DateTime.now();
  chooseDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: expirySelectedDate,
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
      expirySelectedDate = newSelectedDate;
      expiryDateController
        ..text = formatter.format(expirySelectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: expiryDateController.text.length,
            affinity: TextAffinity.upstream));
      expiryDate = expiryDateController.text;
      context
          .read<NewPostAdBloc>()
          .add(NewPostAdEventDeadline(expiryDateController.text));
    }
  }

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
      // setState(() {});

      // return imagePaths;
      return base64Image;
    }
  }
}
