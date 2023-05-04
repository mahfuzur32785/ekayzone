import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../utils/constants.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/rounded_app_bar.dart';
import 'controllers/about_us_cubit/about_us_cubit.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AboutUsCubit>().getAboutUs(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: 'About Us'),
      body: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          if (state is AboutUsStateLoaded) {
            final aboutUsData = state.data;
            return PageRefresh(
              onTap: () => context.read<AboutUsCubit>().getAboutUs(false),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [Html(data: aboutUsData)],
              ),
            );
          } else if (state is AboutUsStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AboutUsStateError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: redColor),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
