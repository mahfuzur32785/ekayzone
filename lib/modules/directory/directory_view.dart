import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:ekayzone/core/remote_urls.dart';
import 'package:ekayzone/modules/home/model/category_model.dart';
import 'package:ekayzone/utils/extensions.dart';
import 'package:ekayzone/utils/k_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Localization/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../main/main_controller.dart';
import 'component/directory_card.dart';
import 'controller/directory_bloc.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final MainController mainController = MainController();

  final _scrollController = ScrollController();

  var searchController = TextEditingController();
  var locationController = TextEditingController();
  var categoryController = TextEditingController();
  var category = '';
  late DirectoryBloc directoryBloc;

  @override
  void initState() {
    super.initState();
    directoryBloc = context.read<DirectoryBloc>();
    if (directoryBloc.directoryList.isEmpty) {
      directoryBloc.add(
          DirectoryEventSearch(searchController.text.trim(), '10', "az", ''));
    }
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    directoryBloc.directoryList.clear();
  }

  void _init() {
    _scrollController.addListener(() {
      final maxExtent = _scrollController.position.maxScrollExtent - 100;
      if (maxExtent < _scrollController.position.pixels) {
        directoryBloc.add(const DirectoryEventLoadMore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: Text(
              "${AppLocalizations.of(context).translate('business_directory')}",
              style: const TextStyle(color: Colors.white),
            ),
            pinned: true,
            leading: IconButton(
              onPressed: () {
                mainController.naveListener.add(0);
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: BlocConsumer<DirectoryBloc, DirectoryState>(
            listener: (context, state) {
              if (state is DirectoryStateMoreError) {
                Utils.errorSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              final directoryList = directoryBloc.directoryList;
              if (directoryBloc.directoryList.isEmpty &&
                  state is DirectoryStateLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.width * 1.2,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is DirectoryStateError) {
                return SizedBox(
                  height: MediaQuery.of(context).size.width * 1.2,
                  child: Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: redColor),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ExpandablePanel(
                        header: TextFormField(
                          controller: searchController,
                          decoration: const InputDecoration(hintText: "Search"),
                        ),
                        collapsed: const SizedBox(),
                        expanded: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: locationController,
                              decoration:
                                  const InputDecoration(hintText: "Location"),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FutureBuilder(
                              future: getBusinessCategory(),
                              builder: (context,
                                  AsyncSnapshot<List<Category>> snapshot) {
                                if (snapshot.hasData) {
                                  return TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                            controller: categoryController,
                                            decoration: const InputDecoration(
                                                labelText: 'Your Location')),
                                    suggestionsCallback: (pattern) {
                                      return snapshot.data!
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
                                        (Category suggestion) {
                                      categoryController.text = suggestion.name;
                                      category = '${suggestion.id}';
                                    },
                                    onSaved: (value) {},
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 45,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            if (searchController.text == '' &&
                                                category == '') {
                                              return;
                                            }
                                            searchController.text = '';
                                            locationController.text = '';
                                            category = '';
                                            directoryBloc.add(
                                                const DirectoryEventSearch(
                                                    '', '10', "az", ''));
                                          },
                                          child: const Text("Clear"))),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: 45,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            if (searchController.text == '' &&
                                                category == '') {
                                              print("cccccccccccccccccc");
                                              return;
                                            }
                                            directoryBloc.add(
                                                DirectoryEventSearch(
                                                    searchController.text
                                                        .trim(),
                                                    '10',
                                                    "az",
                                                    category));
                                          },
                                          child: const Text("Search"))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  ...List.generate(
                      directoryList.length,
                      (index) => DirectoryCard(
                            deleteAd: () {},
                            directoryModel: directoryList[index],
                          )),
                  Visibility(
                    visible: state is DirectoryStateLoadMore,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Center(
                          child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator()),
                        )),
                  ),
                ],
              );
            },
          )),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          )
        ],
      ),
    );
  }

  Future<List<Category>> getBusinessCategory() async {
    Client client = Client();

    var url = Uri.parse(RemoteUrls.getDirectoryCategory);
    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = await json.decode(response.body);
        return List.from(body["data"]).map((e) => Category.fromMap(e)).toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    // try {
    //   SharedPreferences ls = await SharedPreferences.getInstance();
    //   var jsonData = ls.getString(KStrings.businessCategory);
    //   if (jsonData != null) {
    //     print("xxxxxxxxxxxxxxxxxxxx");
    //     final Map<String, dynamic> body = await json.decode(jsonData);
    //     return List.from(body["data"]).map((e) => Category.fromMap(e)).toList();
    //   } else {
    //     var url = Uri.parse(RemoteUrls.getDirectoryCategory);
    //     var response = await client.get(url);
    //     if (response.statusCode == 200) {
    //       final Map<String, dynamic> body = await json.decode(response.body);
    //       ls.setString(KStrings.businessCategory, json.encode(response.body));
    //       return List.from(body["data"]).map((e) => Category.fromMap(e)).toList();
    //     } else {
    //       throw Exception('Failed to load post');
    //     }
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   throw Exception(e.toString());
    // }
  }

}
