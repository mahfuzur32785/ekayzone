import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Localization/app_localizations.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../main_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    Key? key,
    required this.mainController,
    required this.selectedIndex,
  }) : super(key: key);
  final MainController mainController;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 9,
      color: const Color(0x00ffffff),
      shadowColor: blackColor,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,

          selectedLabelStyle: const TextStyle(fontSize: 14, color: redColor),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, color: Color(0xff85959E)),
          items: <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: const Icon(Icons.home,
                  color: paragraphColor),
              activeIcon: const Icon(Icons.home,color: redColor,),
              label: "${AppLocalizations.of(context).translate('home')}",
            ),

            // BottomNavigationBarItem(
            //   tooltip: "${AppLocalizations.of(context).translate('events')}",
            //   activeIcon: const Icon(Icons.calendar_month,color: redColor,),
            //   icon: const Icon(Icons.calendar_month, color: paragraphColor),
            //   label: "${AppLocalizations.of(context).translate('events')}",
            // ),

            // BottomNavigationBarItem(
            //   tooltip: "${AppLocalizations.of(context).translate('ads')}",
            //   activeIcon: const Icon(Icons.ad_units,color: redColor,),
            //   icon: const Icon(Icons.ad_units, color: paragraphColor),
            //   label: "${AppLocalizations.of(context).translate('ads')}",
            // ),

            // BottomNavigationBarItem(
            //   tooltip: "${AppLocalizations.of(context).translate('Directory')}",
            //   activeIcon: const Icon(Icons.search,color: redColor,),
            //   icon: const Icon(Icons.search, color: paragraphColor),
            //   label: "${AppLocalizations.of(context).translate('Directory')}",
            // ),

            BottomNavigationBarItem(
              tooltip: "${AppLocalizations.of(context).translate('profile')}",
              activeIcon:
              const Icon(Icons.person_outline_outlined, color: redColor),
              icon:
              const Icon(Icons.person_outline_outlined, color: paragraphColor),
              label: "${AppLocalizations.of(context).translate('profile')}",
            ),
          ],
          // type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (int index) {
            print("$index");
            mainController.naveListener.sink.add(index);
          },
        ),
      ),
    );
  }
}
