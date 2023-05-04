import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ekayzone/dummy_data/all_dudmmy_data.dart';
import 'package:ekayzone/modules/profile/model/public_profile_model.dart';
import 'package:ekayzone/modules/profile/model/social_data_model.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:ekayzone/utils/extensions.dart';
import 'package:ekayzone/utils/utils.dart';

import '../../../../Localization/app_localizations.dart';
import '../../../../core/animation/delayed_animation.dart';
import '../../controller/edit_profile/ads_edit_profile_cubit.dart';

class SocialLinkEdit extends StatefulWidget {
  const SocialLinkEdit({Key? key}) : super(key: key);

  @override
  State<SocialLinkEdit> createState() => _SocialLinkEditState();
}

class _SocialLinkEditState extends State<SocialLinkEdit> {
  List<SocialDataModel> socialDataList = [];

  SocialMedias demoSocialMedia = const SocialMedias(
    id: 0,
    socialMedia: "",
    url: '',
  );

  void addSocial() {
    socialDataList.add(SocialDataModel(
        controller: TextEditingController(),
        socialMedia: demoSocialMedia,
        formKey: GlobalKey()));
  }

  void removeSocial(index) {
    socialDataList.removeAt(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        socialDataList.add(SocialDataModel(
            controller: TextEditingController(),
            socialMedia: demoSocialMedia,
            formKey: GlobalKey()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdEditProfileCubit>();
    return BlocListener<AdEditProfileCubit,EditProfileState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is EditProfileStatePageLoaded) {
          for(int i = 0; i < state.data.socialMedias.length; i++){
            socialDataList.add(
              SocialDataModel(controller: TextEditingController(text: state.data.socialMedias[i].url), socialMedia: state.data.socialMedias[i], formKey: GlobalKey())
            );
          }
          setState(() {

          });
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 5))
              ]),
          child: Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "${AppLocalizations.of(context).translate('social_media')}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )),
            ...List.generate(socialDataList.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DelayedAnimation(
                      delay: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              // height: 60,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 24, bottom: 10),
                                    // height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: ashTextColor, width: 1),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Form(
                                      key: socialDataList[index].formKey,
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: socialDataList[index].socialMedia.id == 0,
                                            child: DropdownButtonFormField<SocialMedias>(
                                              // value: index == 0 ? null : socialDataList[index].socialMedia,
                                                decoration: InputDecoration(
                                                    hintText: "${AppLocalizations.of(context).translate('select_one')}"),
                                                validator: (value) {
                                                  if (value?.id == 0 || value?.socialMedia == '' || value == null) {
                                                    return "${AppLocalizations.of(context).translate('select_one')}";
                                                  }
                                                  return null;
                                                },
                                                selectedItemBuilder: (context) {
                                                  return socialNameList.map<Widget>(
                                                      (SocialMedias e) {
                                                    return Text(
                                                      e.socialMedia.capitalize(),
                                                      style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    );
                                                  }).toList();
                                                },
                                                items: socialNameList
                                                    .map<
                                                        DropdownMenuItem<
                                                            SocialMedias>>((e) =>
                                                        DropdownMenuItem<
                                                            SocialMedias>(
                                                          value: e,
                                                          child: Text(
                                                            e.socialMedia
                                                                .capitalize(),
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.black87,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ))
                                                    .toList(),
                                                onChanged: (socialModel) {
                                                  setState(() {
                                                    // socialDataList[index].copyWith(socialNameModel: socialModel);
                                                    socialDataList[index] =
                                                        SocialDataModel(
                                                            controller:
                                                                TextEditingController(),
                                                            socialMedia:
                                                                socialModel!,
                                                            formKey: socialDataList[index].formKey);
                                                  });
                                                  if (kDebugMode) {
                                                    print(socialDataList[index]
                                                        .socialMedia
                                                        .socialMedia);
                                                  }
                                                }),
                                          ),
                                          TextFormField(
                                            controller:
                                                socialDataList[index].controller,
                                            validator: (value) {
                                              if (value == '' || value == null) {
                                                return "Link required*";
                                              }
                                              return null;
                                            },
                                            maxLines: 1,
                                            decoration: const InputDecoration(
                                                hintText: "Enter link here..."),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -16,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFF4F4F4),
                                        border: Border.all(
                                            color: ashTextColor, width: 1),
                                        // borderRadius: BorderRadius.circular(16)
                                      ),
                                      child: FaIcon(
                                        Utils.getSocialIcon(socialDataList[index]
                                            .socialMedia
                                            .socialMedia),
                                        color: Utils.getSocialIconColor(
                                            socialDataList[index]
                                                .socialMedia
                                                .socialMedia),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Material(
                            color: index == socialDataList.length - 1
                                ? redColor
                                : ashTextColor,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: () {
                                if (index == (socialDataList.length - 1)) {
                                  setState(() {
                                    addSocial();
                                  });
                                } else {
                                  setState(() {
                                    removeSocial(index);
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(50),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: index == socialDataList.length - 1
                                    ? const Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              );
            }),
            SizedBox(
              height: 48,
              child: BlocBuilder<AdEditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                if (state is EditProfileStateSocialLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: redColor,
                      shadowColor: ashColor,
                      side: const BorderSide(
                          width: 0.5,
                          color: redColor,
                          strokeAlign: BorderSide.strokeAlignInside),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onPressed: () {
                    for(SocialDataModel data in socialDataList){
                      if (!data.formKey.currentState!.validate()) {
                        return;
                      }
                    }
                    bloc.socialMediaUpdate(socialDataList);
                  },
                  child: Text(
                    "${AppLocalizations.of(context).translate('save_changes')}",
                    style:
                        const TextStyle(color: redColor, fontWeight: FontWeight.w400),
                  ),
                );
              }),
            )
          ])),
    );
  }
}
