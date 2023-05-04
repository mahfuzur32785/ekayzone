import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:ekayzone/modules/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/ads/controller/adlist_bloc.dart';
import 'package:ekayzone/modules/category/controller/category_bloc.dart';
import 'package:ekayzone/modules/home/component/grid_product_container2.dart';
import 'package:ekayzone/modules/main/main_controller.dart';

import '../../Localization/app_localizations.dart';
import '../../core/router_name.dart';
import '../../dummy_data/all_dudmmy_data.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_textfeild.dart';
import '../home/component/grid_product_container.dart';
import '../home/component/product_card.dart';
import '../home/controller/cubit/home_controller_cubit.dart';
import 'component/ads_appbar.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key, this.categoryValue, this.searchValue, this.locationValue, this.distanceValue}) : super(key: key);

  final String? categoryValue;
  final String? searchValue;
  final String? locationValue;
  final String? distanceValue;

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var selectedCategory;
  String? selectedCity;

  final _scrollController = ScrollController();

  late SearchAdsBloc searchAdsBloc;
  late CategoryBloc categoryBloc;
  // late HomeModel homeModel;
  late HomeControllerCubit homeControllerCubit;

  final MainController mainController = MainController();

  @override
  void initState() {
    super.initState();
    searchAdsBloc = context.read<SearchAdsBloc>();
    homeControllerCubit = context.read<HomeControllerCubit>();
    categoryBloc = context.read<CategoryBloc>();
    print("category : ${categoryBloc.categorySlug},sub-category : ${categoryBloc.subCategorySlug}");
    if (searchAdsBloc.adList.isEmpty) {
      Future.microtask(() => context.read<SearchAdsBloc>().add(SearchAdsEventSearch("",'','','','','',"${widget.categoryValue}",'','','')));
    }
    _init();

    // selectedCategory = widget.categoryValue ?? '';
    // selectedCity = widget.distanceValue ?? '';
    searchController.text = widget.searchValue?? '';
    locationController.text = widget.locationValue ?? '';
  }

  void _init() {
    _scrollController.addListener(() {
      final maxExtent = _scrollController.position.maxScrollExtent - 100;
      if (maxExtent < _scrollController.position.pixels) {
        searchAdsBloc.add(const SearchAdsEventLoadMore());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchAdsBloc.adList.clear();
  }

  @override
  Widget build(BuildContext context) {
    // print("category : ${context.read<CategoryBloc>().getCategorySlug()},sub-category : ${context.read<CategoryBloc>().getSubCategorySlug()}");
    // if(searchAdsBloc.adList.isEmpty) context.read<SearchAdsBloc>().add(SearchAdsEventSearch("",'','','','','',"${widget.categoryValue}",'',"", "${widget.distanceValue}"));
    // return MultiBlocListener(
      // listeners: [
      //   BlocListener<CategoryBloc, CategoryState>(
      //     listenWhen: (previous, current) => previous != current,
      //     listener: (context, state) {
      //       if (state is CategoryStateShowAll) {
      //         searchAdsBloc.add(SearchAdsEventSearch("${widget.searchValue}",'','','','','','',''));
      //       }
      //       if (state is CategoryStateSelectCategory) {
      //         if (state.isRequiredLoading) {
      //           searchAdsBloc.add(SearchAdsEventSearch("${widget.searchValue}",'','','','','',state.category.name,''));
      //         }
      //       }
      //       if (state is CategoryStateSelectSubCategory) {
      //         searchAdsBloc.add(SearchAdsEventSearch(searchCtr.text,'','','','','',categoryBloc.categorySlug,state.subCategory.slug));
      //       }
      //     },
      //   ),
      // ],
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FE),
        body: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            slivers: [
              AdsAppBar.appBar(context),

              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 14, bottom: 14),
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: const BoxDecoration(
                    color: Color(0XFFF7E7F3),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.black12, width: 8),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18),
                          height: 48,
                          child: BlocBuilder<CategoryBloc,CategoryState>(
                            builder: (context,state){
                              return Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteNames.categorySelection);
                                  },
                                  child: Container(
                                      height: 48,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            SizedBox(child: Text(categoryBloc.getCategoryName(context),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                            const Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              );
                            },
                          )
                        ),
                        CstmTextFeild(
                          isObsecure: false,
                          controller: searchController,
                          hintext: "What are you looking for?",
                        ),
                        CstmTextFeild(
                          isObsecure: false,
                          controller: locationController,
                          hintext: "Location",
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18),
                          height: 48,
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('Entire city',
                                    style: TextStyle(color: Colors.black)),
                                isDense: true,
                                isExpanded: true,
                                onChanged: (dynamic value) {
                                  selectedCity = value;
                                  print(selectedCity);
                                  setState(() {

                                  });
                                },
                                value: selectedCity,
                                items: dropDownListData.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: Text(location),
                                  );
                                }).toList(),
                              )),
                        ),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Future.microtask(() => context.read<SearchAdsBloc>().add(SearchAdsEventSearch(searchController.text,'','','','','',categoryBloc.categorySlug,'','','')));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                backgroundColor:
                                const Color(0xFF212d6e)),
                            child: const Text("Find it"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Visibility(
                  // visible: searchAdsBloc.adList.isEmpty &&
                  //     state is SearchAdsStateLoaded,
                  visible: false,
                  child: SizedBox(
                    // height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context).translate('ads')} ${AppLocalizations.of(context).translate('not_found_title')}",
                        style: const TextStyle(
                            color: redColor, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                  child: BlocConsumer<SearchAdsBloc, SearchAdsState>(
                    listener: (context, state) {
                      if (state is SearchAdsStateMoreError) {
                        Utils.errorSnackBar(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      final adList = searchAdsBloc.adList;
                      if (searchAdsBloc.adList.isEmpty && state is SearchAdsStateLoading) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is SearchAdsStateError) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.3,
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
                          GridProductContainer2(
                            onPressed: (){},
                            title: "${AppLocalizations.of(context).translate('ads')}",
                            adModelList: adList,
                          ),
                          Visibility(
                            visible: state is SearchAdsStateLoadMore,
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
                  )
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                ),
              )
            ],
          ),
      ),
    );
  }
}
