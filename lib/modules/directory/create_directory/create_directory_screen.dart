import 'dart:convert';
import 'dart:io';

import 'package:ekayzone/modules/home/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ekayzone/modules/directory/create_directory/controller/create_directory_bloc.dart';
import 'package:ekayzone/utils/extensions.dart';

import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../map/map_cubit.dart';
import '../../map/map_view.dart';

class CreateDirectoryScreen extends StatefulWidget {
  const CreateDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateDirectoryScreen> createState() => _CreateDirectoryScreenState();
}

class _CreateDirectoryScreenState extends State<CreateDirectoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<CreateDirectoryBloc>()
          .add(const CreateDirectoryEventGetBCategory());
      context.read<MapCubit>().getCurrentLocation();
    });
  }

  Brand? subCategory;

  @override
  Widget build(BuildContext context) {
    final createDirectoryBloc = context.read<CreateDirectoryBloc>();
    return BlocListener<CreateDirectoryBloc, CreateDirectoryModalState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (context, state) {
        if (state.state is CreateDirectoryStateFormSubmitLoading) {
          Utils.loadingDialog(context);
        }
        if (state.state is CreateDirectoryStateFormSubmitError) {
          final status = state.state as CreateDirectoryStateFormSubmitError;
          Utils.closeDialog(context);
          Utils.showSnackBar(context, status.errorMsg);
        }
        if (state.state is CreateDirectoryStateLoaded) {
          final status = state.state as CreateDirectoryStateLoaded;
          image = null;
          Utils.showSnackBar(context, status.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add My Business"),
        ),
        body: BlocBuilder<CreateDirectoryBloc, CreateDirectoryModalState>(
          builder: (context, state) {
            if (state.state is CreateDirectoryStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.state is CreateDirectoryStateError) {
              final status = state.state as CreateDirectoryStateError;
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(status.errorMsg),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          createDirectoryBloc
                              .add(const CreateDirectoryEventGetBCategory());
                        },
                        child: const Text("Retry"))
                  ],
                ),
              );
            }
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Form(
                      key: createDirectoryBloc.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Title*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.title != current.title,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.name,
                                // initialValue: state.name,
                                controller: createDirectoryBloc.titleController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Business Title';
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc
                                    .add(CreateDirectoryEventTitle(value)),
                                decoration:
                                    const InputDecoration(hintText: "Title"),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          const Text("Email*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.email != current.email,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                // initialValue: state.name,
                                controller: createDirectoryBloc.emailController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter email';
                                  } else if (!Utils.isEmail(value.trim())) {
                                    return "Enter valid email";
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc
                                    .add(CreateDirectoryEventEmail(value)),
                                decoration:
                                    const InputDecoration(hintText: "Email"),
                              );
                            },
                          ),

                          //............. Category and subcategory ...........
                          const SizedBox(
                            height: 16,
                          ),
                          const Text("Category*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                                  CreateDirectoryModalState>(
                              buildWhen: (previous, current) =>
                                  previous.category != current.category,
                              builder: (context, state) {
                                return DropdownButtonFormField<Category>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    hintText: "Category",
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return createDirectoryBloc.categoryList
                                        .map<Widget>((Category item) {
                                      // This is the widget that will be shown when you select an item.
                                      // Here custom text style, alignment and layout size can be applied
                                      // to selected item string.
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        constraints:
                                            const BoxConstraints(minWidth: 100),
                                        child: Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items: createDirectoryBloc.categoryList
                                      .map<DropdownMenuItem<Category>>((e) {
                                    return DropdownMenuItem<Category>(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Select Category";
                                    }
                                  },
                                  onChanged: (Category? value) {
                                    // setState(() {
                                    //   subCategory = null;
                                    //   postAdBloc.subCategoryList = [];
                                    // });
                                    Future.delayed(
                                            const Duration(milliseconds: 300))
                                        .then((value2) {
                                      createDirectoryBloc.add(
                                          CreateDirectoryEventCategory(
                                              value!.id.toString()));
                                    });
                                  },
                                );
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text("Sub Category*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                                  CreateDirectoryModalState>(
                              buildWhen: (previous, current) =>
                                  previous.subCategory != current.subCategory,
                              builder: (context, state) {
                                return DropdownButtonFormField<Brand>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    hintText: "Sub Category",
                                  ),
                                  value: createDirectoryBloc.subCategory,
                                  items: createDirectoryBloc.subCategoryList
                                      .map<DropdownMenuItem<Brand>>((e) {
                                    return DropdownMenuItem<Brand>(
                                      value: e,
                                      child: Text(e.name),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (createDirectoryBloc
                                            .subCategoryList.isNotEmpty &&
                                        value == null) {
                                      return "Select Sub Category";
                                    }
                                    return null;
                                  },
                                  onChanged: (Brand? value) {
                                    setState(() {
                                      subCategory = null;
                                    });
                                    createDirectoryBloc.add(
                                        CreateDirectoryEventSubCategory(
                                            value!.id.toString(), value));
                                  },
                                );
                              }),

                          const SizedBox(
                            height: 16,
                          ),

                          SizedBox(
                            child: RichText(
                              text: const TextSpan(
                                  text: "Phone Number*  ",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text: "Head Office",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ))
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.phone != current.phone,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.phone,
                                // initialValue: state.name,
                                controller: createDirectoryBloc.phoneController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Phone Number';
                                  } else if (value.length < 10) {
                                    return "Enter valid Phone Number";
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc
                                    .add(CreateDirectoryEventPhone(value)),
                                decoration: const InputDecoration(
                                    hintText: "Phone Number"),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          SizedBox(
                            child: RichText(
                              text: const TextSpan(
                                  text: "Phone Number Two*  ",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                  children: [
                                    TextSpan(
                                        text: "Corporate Office",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ))
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.backupPhone != current.backupPhone,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.phone,
                                // initialValue: state.name,
                                controller:
                                    createDirectoryBloc.backupPhoneController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Phone Number';
                                  } else if (value.length < 10) {
                                    return "Enter valid Phone Number";
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc.add(
                                    CreateDirectoryEventBackupPhone(value)),
                                decoration: const InputDecoration(
                                    hintText: "Phone Number Two"),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          const Text("Business Profile*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.businessProfile !=
                                current.businessProfile,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.name,
                                // initialValue: state.name,
                                controller: createDirectoryBloc
                                    .businessProfileController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Business Profile';
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc.add(
                                    CreateDirectoryEventBusinessProfile(value)),
                                decoration: const InputDecoration(
                                    hintText: "Business Profile"),
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
                          BlocBuilder<CreateDirectoryBloc,
                              CreateDirectoryModalState>(
                            buildWhen: (previous, current) =>
                                previous.description != current.description,
                            builder: (context, state) {
                              return TextFormField(
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                                controller:
                                    createDirectoryBloc.descriptionController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Description';
                                  }
                                  return null;
                                },
                                onChanged: (value) => createDirectoryBloc.add(
                                    CreateDirectoryEventDescription(value)),
                                decoration: const InputDecoration(
                                    hintText: "Description"),
                              );
                            },
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          const Text("Choose Location*"),
                          const SizedBox(
                            height: 6,
                          ),
                          BlocBuilder<CreateDirectoryBloc,
                                  CreateDirectoryModalState>(
                              buildWhen: (previous, current) =>
                                  previous.location != current.location,
                              builder: (context, state) {
                                return TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          // onChanged: (value){
                                          //   createDirectoryBloc.add(CreateDirectoryEventLocation(value.trim()));
                                          // },
                                          controller: createDirectoryBloc
                                              .locationController,
                                          decoration: const InputDecoration(
                                              labelText: 'Your Location')),
                                  suggestionsCallback: (pattern) {
                                    getPlaces(pattern).then((value) {
                                      placesSearchResult = value;
                                    });
                                    return placesSearchResult
                                        .where((element) => element.name
                                            .toLowerCase()
                                            .contains(pattern
                                                .toString()
                                                .toLowerCase()))
                                        .take(10)
                                        .toList();
                                    // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion.name),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (PlacesSearchResult suggestion) {
                                    createDirectoryBloc.add(
                                        CreateDirectoryEventLocation(
                                            suggestion.name));
                                    createDirectoryBloc.add(CreateDirectoryEventLatLng('${suggestion.geometry?.location.lat}', '${suggestion.geometry?.location.lng}'));
                                  },
                                  validator: (value) {
                                    if (createDirectoryBloc.state.location ==
                                        '') {
                                      return 'Enter Your Location';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {},
                                );
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                getCurrentLocation();
                              },
                              icon: const Icon(Icons.location_on_outlined),
                              label: const Text("Use My Current Location"),
                            ),
                          ),

                          // Container(
                          //   padding: const EdgeInsets.all(6),
                          //   margin: const EdgeInsets.all(8),
                          //   width: MediaQuery.of(context).size.width,
                          //   height: MediaQuery.of(context).size.width,
                          //   decoration: BoxDecoration(
                          //       color: whiteColor,
                          //       borderRadius: BorderRadius.circular(6),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           blurRadius: 70,
                          //           color: Colors.grey.withOpacity(0.2),
                          //           offset: const Offset(1,1),
                          //         )
                          //       ]
                          //   ),
                          //   child: const AppMapView(),
                          // ),
                          //........... Image .............
                          const SizedBox(
                            height: 16,
                          ),
                          Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(3),
                              onTap: () {
                                pickImage().then((value) {
                                  if (value != null) {
                                    createDirectoryBloc.add(
                                        CreateDirectoryEventImage(value ?? ''));
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: ashColor),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.add_circle_outlined,
                                      color: redColor,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text("Choose Your Business Image")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          LayoutBuilder(builder: (context, constraints) {
                            if (image != null) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        color: ashTextColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Image(
                                      // image: FileImage(File(controller.images2![index].path))
                                      image: FileImage(File(image!.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
        bottomNavigationBar: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, -10),
                spreadRadius: 0)
          ]),
          child: ElevatedButton(
            onPressed: () {
              if (createDirectoryBloc.categoryList.isEmpty) {
                return;
              }
              if (createDirectoryBloc.formKey.currentState!.validate()) {
                createDirectoryBloc.add(CreateDirectoryEventSubmit("fsdjflsd"));
              }
            },
            child: const Text("Create Directory"),
          ),
        ),
      ),
    );
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? base64Image;

  Future<String?> pickImage() async {
    String? imagePaths;
    XFile? tempImage = await picker.pickImage(source: ImageSource.gallery);
    if (tempImage == null) {
      print("Image doesn't choose!");
      return imagePaths;
    } else {
      image = tempImage;
      base64Image = null;
      if (image != null) {
        List<int> imageBytes = await image!.readAsBytes();
        base64Image =
            'data:image/${image!.path.split('.').last};base64,${base64Encode(imageBytes)}';
        imagePaths = image!.path;
      }
      setState(() {});

      // return imagePaths;
      return base64Image;
    }
  }

  //......... Location search ................
  List<PlacesSearchResult> placesSearchResult = [];
  static const kGoogleApiKey = "AIzaSyATgI95Rp6YpYchbA6c8rD-3tC9xRIc96c";
  // static const kGoogleApiKey = "AIzaSyA72zy8Wy4kFpom_brg28OqBOa8S0eXXGY";
  final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  late PlacesSearchResponse response;
  Future<List<PlacesSearchResult>> getPlaces(text) async {
    await places.searchByText(text).then((value) {
      print(value.status);
      print("${value.results.length}");
      if (value.results.isNotEmpty) {
        print(value.results.map((e) => e.name.log()));
        placesSearchResult = value.results;
      }
    });

    return placesSearchResult;
  }

  //........... Use Current Location ............
  late Position currentPosition;
  String? currentAddress;
  String? fullAddress;
  void getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              forceAndroidLocationManager: false)
          .then((Position position) {
        currentPosition = position;
        getAddressFromLatLng();
        print('${currentPosition.latitude} ${currentPosition.longitude}');
      }).catchError((e) {
        print(e);
        Utils.showSnackBar(context, 'Please Turn On Your Mobile Location');
      });
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      getCurrentLocation();
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      Future.delayed(const Duration(seconds: 1))
          .then((value) => getCurrentLocation());
    }
  }

  void getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];

      /// postal code, locality, country
      Placemark place1 = placemarks[1];

      /// street name block - D
      Placemark place2 = placemarks[2];

      /// name holding no 21,
      Placemark place4 = placemarks[4];

      /// name banani model town
      ///
      /// 358/A, Ahmed Nagar, Mirpur-1, Dhaka 1216-984378349,789392454 next target
      currentAddress = place1.toString();
      fullAddress =
          '${place1.street}, ${place4.name} - ${place.postalCode}. ${place.locality}, ${place.country}';
      final bloc = context.read<CreateDirectoryBloc>();
      bloc.locationController.text = '$fullAddress';
      bloc.add(CreateDirectoryEventLocation(bloc.locationController.text));
      bloc.add(CreateDirectoryEventLatLng('${currentPosition.latitude}','${currentPosition.longitude}'));
      print('$fullAddress');
    } on PermissionDeniedException catch (e) {
      print(e);
      Utils.showSnackBar(context, '$e');
    } on LocationServiceDisabledException catch (e) {
      print(e);
      Utils.showSnackBar(context, '$e');
    } catch (e) {
      print(e);
      Utils.showSnackBar(context, '$e');
    }
  }
}
