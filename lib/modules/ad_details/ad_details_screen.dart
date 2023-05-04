import 'package:ekayzone/modules/home/home_screen.dart';
import 'package:ekayzone/modules/profile/controller/public_profile/public_profile_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ekayzone/core/router_name.dart';
import 'package:ekayzone/modules/ad_details/component/image_slider.dart';
import 'package:ekayzone/modules/ad_details/controller/ad_details_cubit.dart';
import 'package:ekayzone/modules/ad_details/controller/ad_details_state.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';
import 'package:ekayzone/utils/extensions.dart';
import 'package:ekayzone/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../../Localization/app_localizations.dart';
import '../../core/remote_urls.dart';
import '../../utils/constants.dart';
import '../home/component/horizontal_ad_container.dart';

class AdDetailsScreen extends StatefulWidget {
  const AdDetailsScreen({Key? key, required this.slug}) : super(key: key);
  final String slug;

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {

  final scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.slug);
    }
    super.initState();
    Future.microtask(
        () => context.read<AdDetailsCubit>().getAdDetails(widget.slug, true));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  final _className = 'ProductDetailsScreen';

  bool isTap = false;
  // bool isClick = false;
  void _onTapDown(TapDownDetails details) {
    setState(() {
      isTap = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      setState(() {
        isTap = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<LoginBloc>().userInfo;
    final bloc = context.read<PublicProfileCubit>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FE),
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context).translate('ad_details')}"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: iconThemeColor,
          ),
        ),
      ),
      body: BlocBuilder<AdDetailsCubit, AdDetailsState>(
          builder: (context, state) {
        if (state is AdDetailsStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdDetailsStateError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: redColor),
            ),
          );
        }
        if (state is AdDetailsStateLoaded) {
          state.adDetailsResponseModel.adDetails.id.toString().log();
          state.adDetailsResponseModel.adDetails.wishListed.toString().log();
          return CustomScrollView(
            slivers: [
              //IMAGE SLIDER
              SliverToBoxAdapter(
                child: ImageSlider(
                  gallery: state.adDetailsResponseModel.adDetails.galleries,
                  height: MediaQuery.of(context).size.width * 0.8,
                  adDetails: state.adDetailsResponseModel.adDetails,
                ),
              ),

              ///ADS DETAILS AND SHARE OPTIONS
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(0, 0),
                              blurRadius: 3),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "R${state.adDetailsResponseModel.adDetails.price}",
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            state.adDetailsResponseModel.adDetails.title,
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1),
                          ),
                        ),

                        Row(
                          children: [
                            Transform.rotate(
                                angle: -5,
                                child: const Icon(
                                  Icons.local_offer_outlined,
                                  size: 16,
                                  color: Colors.black54,
                                )),
                            Text(
                              "Category: ${state.adDetailsResponseModel.adDetails.category!.name}",
                              style: GoogleFonts.lato(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 0,
                                child: const Icon(
                                  Icons.local_movies_outlined,
                                  size: 14,
                                  color: Colors.black54,
                                )),
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  "Sub-Category: ${state.adDetailsResponseModel.adDetails.subcategory?.name}",
                                  style: GoogleFonts.lato(
                                      fontSize: 14, color: Colors.black54),
                                  maxLines: 1,overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.black54,
                            ),
                            Text(
                              "Location: ${state.adDetailsResponseModel.adDetails.city}",
                              style: GoogleFonts.lato(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.post_add,
                              size: 16,
                              color: Colors.black54,
                            ),
                            Text(
                              "Posted at: ${Utils.timeAgo(state.adDetailsResponseModel.adDetails.customer!.createdAt)}",
                              style: GoogleFonts.lato(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        ///Chat with seller button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (userData != null) {
                                if(bloc.isMe(userData.user.id)){
                                  Utils.showSnackBar(context, "You can not message with yourself");
                                  return;
                                } else {
                                  Navigator.pushNamed(
                                      context, RouteNames.chatDetails,
                                      arguments: state.adDetailsResponseModel
                                          .adDetails.customer?.username);
                                }
                              } else {
                                Utils.openSignInDialog(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2))),
                            icon: const FaIcon(FontAwesomeIcons.message,
                                size: 18),
                            label: Text(
                              "${AppLocalizations.of(context).translate('Chat With Seller')}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        ///Phone button
                        Visibility(
                          visible: state.adDetailsResponseModel.adDetails.showPhone && state.adDetailsResponseModel.adDetails.phone.isNotEmpty,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // isClick = true;
                                // setState(() {
                                //
                                // });
                                phoneCall(state.adDetailsResponseModel.adDetails.phone,context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF212d6e),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              icon: const FaIcon(
                                FontAwesomeIcons.phone,
                                size: 18,
                              ),
                              label: Text(
                                userData!=null ? state.adDetailsResponseModel.adDetails.phone : "Login to View Phone",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        ///Email button
                        Visibility(
                          visible: state.adDetailsResponseModel.adDetails.showEmail == '1' && state.adDetailsResponseModel.adDetails.email.isNotEmpty,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // isClick = true;
                                // setState(() {
                                //
                                // });
                                sendEmail(state.adDetailsResponseModel.adDetails.email,context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF212d6e),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              icon: const FaIcon(
                                FontAwesomeIcons.envelope,
                                size: 20,
                              ),
                              label: Text(
                                userData!=null ? state.adDetailsResponseModel.adDetails.email : "Login to View Email",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),

                        ///Whatsapp button
                        Visibility(
                          visible: state.adDetailsResponseModel.adDetails.showWhatsapp == '1' && state.adDetailsResponseModel.adDetails.whatsapp.isNotEmpty,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // isClick = true;
                                // setState(() {
                                //
                                // });
                                sendWhatsappMessage("https://api.whatsapp.com/send?phone=${state.adDetailsResponseModel.adDetails.whatsapp}&text=Hello there", context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1faf54),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              icon: const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 20,
                              ),
                              label: Text(
                                userData!=null ? "Send Message via whatsapp" : "Login to Chat with Whatsapp",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),

                        const Text(
                          "Share this ad",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              "Share",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                            Image(
                              image: AssetImage('assets/social/facebook.png'),
                              height: 30,
                              width: 30,
                            ),
                            Image(
                              image: AssetImage('assets/social/twitter.png'),
                              height: 30,
                              width: 30,
                            ),
                            Image(
                              image: AssetImage('assets/social/linkedin.png'),
                              height: 30,
                              width: 30,
                            ),
                            Image(
                              image: AssetImage('assets/social/pinterest.png'),
                              height: 30,
                              width: 30,
                            ),
                            Image(
                              image: AssetImage('assets/social/mail.png'),
                              height: 30,
                              width: 30,
                            ),
                            Image(
                              image: AssetImage('assets/social/whatsapp.png'),
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Wrap(
                        //   crossAxisAlignment: WrapCrossAlignment.start,
                        //   alignment: WrapAlignment.start,
                        //   runAlignment: WrapAlignment.start,
                        //   spacing: 8,
                        //   runSpacing: 8,
                        //   children: [
                        //     Visibility(
                        //       visible: state.adDetailsResponseModel.adDetails.featured == 1,
                        //       child: SizedBox(
                        //         height: 40,
                        //         child: Chip(
                        //           backgroundColor: Colors.amber.withOpacity(0.2),
                        //           label: Text("${AppLocalizations.of(context).translate('featured')}",style: const TextStyle(color: Colors.amber,fontSize: 12,),),
                        //           avatar: const Icon(Icons.check,color: Colors.amber,size: 20,),
                        //         ),
                        //       ),
                        //     ),
                        //     Visibility(
                        //       visible: state.adDetailsResponseModel.adDetails.customer?.emailVerifiedAt != null,
                        //       child: SizedBox(
                        //         height: 40,
                        //         child: Chip(
                        //           backgroundColor: Colors.pink.withOpacity(0.2),
                        //           label: Text("${AppLocalizations.of(context).translate('member')}",style: const TextStyle(color: Colors.pink,fontSize: 12,),),
                        //           avatar: const Icon(Icons.star,color: Colors.pink,size: 20,),
                        //         ),
                        //       ),
                        //     ),
                        //     Visibility(
                        //       visible: state.adDetailsResponseModel.adDetails.customer?.emailVerifiedAt != null,
                        //       child: SizedBox(
                        //         height: 40,
                        //         child: Chip(
                        //           backgroundColor: Colors.green.withOpacity(0.2),
                        //           label: const Text("Verified User",style: TextStyle(color: Colors.green,fontSize: 12,),),
                        //           avatar: const Icon(Icons.verified_user_rounded,color: Colors.green,size: 20,),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const Divider(),
                        //
                        // Wrap(
                        //   crossAxisAlignment: WrapCrossAlignment.start,
                        //   alignment: WrapAlignment.start,
                        //   runAlignment: WrapAlignment.start,
                        //   spacing: 8,
                        //   runSpacing: 8,
                        //   children: [
                        //     SizedBox(
                        //       height: 40,
                        //       child: Chip(
                        //         backgroundColor: ashColor.withOpacity(0.1),
                        //         label: Text(state.adDetailsResponseModel.adDetails.address,style: const TextStyle(color: Colors.black87,fontSize: 12,),),
                        //         avatar: const Icon(Icons.location_on_outlined,color: Colors.black54,size: 20,),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 40,
                        //       child: Chip(
                        //         backgroundColor: ashColor.withOpacity(0.1),
                        //         label: Text(Utils.timeAgo(state.adDetailsResponseModel.adDetails.createdAt),style: const TextStyle(color: Colors.black87,fontSize: 12,),),
                        //         avatar: const Icon(Icons.watch_later_outlined,color: Colors.black54,size: 20,),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 40,
                        //       child: Chip(
                        //         backgroundColor: ashColor.withOpacity(0.1),
                        //         label: Text("${state.adDetailsResponseModel.adDetails.totalViews} ${AppLocalizations.of(context).translate('viewed')}",style: const TextStyle(color: Colors.black87,fontSize: 12,),),
                        //         avatar: const Icon(Icons.remove_red_eye_outlined,color: Colors.black54,size: 20,),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 16,
                        // ),
                        // Text(state.adDetailsResponseModel.adDetails.title,style: const TextStyle(color: Colors.black87,fontSize: 16),),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        // Text("${AppLocalizations.of(context).translate('features')}",style: const TextStyle(color: Colors.black54,fontSize: 16),),
                        // ...List.generate(state.adDetailsResponseModel.adDetails.adFeatures.length, (index) {
                        //   return SizedBox(
                        //     height: 40,
                        //     child: Chip(
                        //       backgroundColor: Colors.white,
                        //       label: Text(state.adDetailsResponseModel.adDetails.adFeatures[index].name,style: const TextStyle(color: Colors.black54,fontSize: 13,),),
                        //       avatar: const Icon(Icons.check,color: Colors.green,size: 20,),
                        //     ),
                        //   );
                        // }),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        //   margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(16),
                        //       boxShadow: [
                        //         BoxShadow(
                        //             color: Colors.grey.withOpacity(0.2),
                        //             offset: const Offset(0,0),
                        //             blurRadius: 3
                        //         ),
                        //       ]
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           CircleAvatar(
                        //             radius: 30,
                        //             child: ClipRRect(
                        //               borderRadius: BorderRadius.circular(100),
                        //               child: CustomImage(
                        //                 // path: RemoteUrls.imageUrl(productModel.image),
                        //                   path: state.adDetailsResponseModel.adDetails.customer?.image != '' ? '${RemoteUrls.rootUrl}${state.adDetailsResponseModel.adDetails.customer?.image}' : null,
                        //                   fit: BoxFit.cover
                        //               ),
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 8,
                        //           ),
                        //           Expanded(
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 SizedBox(child: Text("${state.adDetailsResponseModel.adDetails.customer?.name}",maxLines: 1,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
                        //                 Visibility(
                        //                   visible: state.adDetailsResponseModel.adDetails.customer?.showPhone == 1,
                        //                     child: SizedBox(child: Text("${state.adDetailsResponseModel.adDetails.customer?.phone}",maxLines: 1,style: const TextStyle(fontWeight: FontWeight.w500),))),
                        //               ],
                        //             ),
                        //           ),
                        //           GestureDetector(
                        //             onTap: (){
                        //               Navigator.pushNamed(context, RouteNames.publicProfile,arguments: state.adDetailsResponseModel.adDetails.customer?.username);
                        //             },
                        //             onTapDown: _onTapDown,
                        //             onTapUp: _onTapUp,
                        //             child: Text("${AppLocalizations.of(context).translate('view_profile')}",style: TextStyle(color: isTap ? Colors.black87 : Colors.blue,fontWeight: FontWeight.w500),),
                        //           )
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         height: 16,
                        //       ),
                        //       SizedBox(
                        //         height: 48,
                        //         child: ElevatedButton.icon(
                        //           onPressed: (){
                        //             if (userData != null) {
                        //               Navigator.pushNamed(context, RouteNames.chatDetails,arguments: state.adDetailsResponseModel.adDetails.customer?.username);
                        //             } else {
                        //               Utils.openSignInDialog(context);
                        //             }
                        //           },
                        //           icon: const FaIcon(FontAwesomeIcons.commentDots),
                        //           label: Text("${AppLocalizations.of(context).translate('send_message')}"),
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 16,
                        //       ),
                        //       SizedBox(
                        //         height: 48,
                        //         child: OutlinedButton.icon(
                        //           onPressed: () async {
                        //             if (userData != null) {
                        //               final Uri emailUri = Uri(
                        //                 scheme: 'mailto',
                        //                 path: '${state.adDetailsResponseModel.adDetails.customer?.email}',
                        //               );
                        //               await launchUrl(emailUri,mode: LaunchMode.externalNonBrowserApplication).then((value) {
                        //                   if (!value) {
                        //                     Utils.showSnackBar(context, "Couldn't Send Mail");
                        //                   }
                        //               });
                        //             } else {
                        //               Utils.openSignInDialog(context);
                        //             }
                        //           },
                        //           icon: const FaIcon(FontAwesomeIcons.envelope),
                        //           label: Text("${AppLocalizations.of(context).translate('send_message_via_email')}"),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                      ],
                    ),
                  ),
                ),
              ),

              ///DESCRIPTION SECTION
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(0, 0),
                              blurRadius: 3),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${AppLocalizations.of(context).translate('description')}",
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(state.adDetailsResponseModel.adDetails.description),
                      ],
                    ),
                  ),
                ),
              ),

              ///SELLER INFORMATION'S SECTION
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(0, 0),
                              blurRadius: 3),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "${AppLocalizations.of(context).translate('Seller Informations')}",
                              style: GoogleFonts.lato(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: ashColor,
                          backgroundImage: NetworkImage("${RemoteUrls.rootUrl2}${state.adDetailsResponseModel.adDetails.customer!.image}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            state.adDetailsResponseModel.adDetails.customer!.name,
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: double.parse("${state.adDetailsResponseModel.adDetails.customer!.averageReview}"),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: const EdgeInsets.only(right: 2),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star_border,
                                  color: Color(0xffF0A732),
                                  // size: 5,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "(${state.adDetailsResponseModel.adDetails.customer!.totalReview})",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("Reviews"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Joined "),
                              Text(DateFormat.yMMMMd().format(DateTime.parse("${state.adDetailsResponseModel.adDetails.customer!.createdAt}")),
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Total Listed Ads "),
                              Text("${state.adDetailsResponseModel.adDetails.customer!.totalAds}",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            height: 40,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteNames.publicShopScreen,arguments: state.adDetailsResponseModel.adDetails.customer?.username);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF212d6e),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2))),
                              child: const Text(
                                "Member Shop",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///RELATED ADS SECTION
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: HorizontalProductContainer(
                    adModelList: state.adDetailsResponseModel.relatedAds,
                    title:
                        "${AppLocalizations.of(context).translate('Recommended Ads for you')}",
                    onPressed: () {},
                    from: 'details_page',
                  ),
                ),
              ),

              //.......... Related Ads horizontal ..........
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     decoration: BoxDecoration(
              //         color: Colors.white.withAlpha(950),
              //         borderRadius: BorderRadius.circular(16),
              //         boxShadow: const [
              //           BoxShadow(
              //               offset: Offset(5,5),
              //               blurRadius: 3,
              //               color: ashColor,
              //               blurStyle: BlurStyle.inner
              //           )
              //         ]
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 16.0),
              //           child: Text("Related Ads",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
              //         ),
              //         const SizedBox(
              //           height: 16,
              //         ),
              //         SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           padding: const EdgeInsets.symmetric(horizontal: 16),
              //           child: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               ConstrainedBox(
              //                 constraints: BoxConstraints(
              //                   // maxHeight: MediaQuery.of(context).size.width * 1.2,
              //                   maxHeight: 430,
              //                   minHeight: MediaQuery.of(context).size.width * 0.8,
              //                 ),
              //                 child: ListView.separated(
              //                   clipBehavior: Clip.none,
              //                   addAutomaticKeepAlives: true,
              //                   shrinkWrap: true,
              //                   // padding: const EdgeInsets.symmetric(horizontal: 16),
              //                   addRepaintBoundaries: true,
              //                   scrollDirection: Axis.horizontal,
              //                   itemBuilder: (context,index){
              //                     // return ListProductCard(productModel: products[index],width: MediaQuery.of(context).size.width * 0.9,);
              //                     return SizedBox();
              //                   },
              //                   itemCount: products.length,
              //                   separatorBuilder: (BuildContext context, int index) {
              //                     return const SizedBox(
              //                       width: 16,
              //                     );
              //                   },
              //                 ),
              //               )
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              )
            ],
          );
        }
        // log(state.toString(), name: _className);
        return const SizedBox();
      }),
    );
  }

  phoneCall(phoneNumber, context) async {
    if (phoneNumber.toString().isNotEmpty) {
      final url = Uri.parse('tel:"$phoneNumber"');
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No phone number found')));
    }
  }

  sendEmail(email, context) async {
    if (email.toString().isNotEmpty) {
      final url = Uri.parse('mailto:$email');
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No Email has found')));
    }
  }

  Future<void> sendWhatsappMessage(url, context) async {

    print(url);

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
            Uri.parse(url),
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
          mode: LaunchMode.externalApplication
        );
      }
    } on Exception {
      print('WhatsApp is not installed');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No Whatsapp Number has found')));
    }
  }

}
