import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/Localization/controller/locale_cubit.dart';
import 'package:ekayzone/modules/directory/directory_view.dart';
import 'package:ekayzone/modules/home/controller/cubit/home_controller_cubit.dart';
import 'package:ekayzone/modules/languages/controller/language_cubit.dart';
import 'package:ekayzone/modules/profile/profile_screen.dart';
import 'package:ekayzone/utils/constants.dart';
import 'package:upgrader/upgrader.dart';

import '../../Localization/app_localizations.dart';
import '../../core/router_name.dart';
import '../../utils/utils.dart';
import '../ads/ads_screen.dart';
import '../app_event/events/events_screen.dart';
import '../authentication/controllers/login/login_bloc.dart';
import '../home/home_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'main_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _homeController = MainController();

  late List<Widget> pageList;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // BlocProvider.of<LocaleCubit>(context).toEnglish();
      context.read<LanguageCubit>().getLanguages();
      context.read<LoginBloc>().add(const LoginEventCheckProfile());
      context.read<HomeControllerCubit>().getHomeData();
    });

    pageList = [
      HomeScreen(),
      // const AdsScreen(),
      // const DirectoryPage(),
      ProfileScreen(),
    ];
  }

  final _className = "MainPage";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: 0,
      stream: _homeController.naveListener.stream,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data ?? 0;

        return BlocListener<LoginBloc, LoginModelState>(
          key: UniqueKey(),
          listener: (context, state) {
            // log(state.state.toString(), name: _className);
            if (state.state is LoginStateLogOut) {
              Utils.closeDialog(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.authenticationScreen, (route) => false);
            } else if (state.state is LoginStateLogOutLoading) {
              Utils.loadingDialog(context);
            } else if (state.state is LoginStateSignOutError) {
              final currentState = state.state as LoginStateSignOutError;
              Utils.closeDialog(context);
              Utils.errorSnackBar(context, currentState.errorMsg);
            }
          },
          child: Scaffold(
            extendBody: true,
            key: UniqueKey(),
            body: WillPopScope(
              onWillPop: () => _homeController.onBackPressed(context,index),
              child: UpgradeAlert(
                upgrader: Upgrader(
                  dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
                ),
                child: IndexedStack(
                  index: index,
                  children: pageList,
                ),
              ),
            ),
            bottomNavigationBar: MyBottomNavigationBar(
                mainController: _homeController, selectedIndex: index,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Visibility(
              visible: context.read<LoginBloc>().isLoggedIn && index == 1,
              child: FloatingActionButton(
                onPressed: (){
                  if (index == 3) {
                    Navigator.pushNamed(context, RouteNames.createDirectoryScreen);
                  } else {
                    Navigator.pushNamed(context, RouteNames.postAd);
                  }
                },
                backgroundColor: redColor,
                shape: const CircleBorder(),
                tooltip: "${AppLocalizations.of(context).translate('post_ad')}",
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }
}
