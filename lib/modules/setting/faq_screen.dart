import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar_leading.dart';
import '../../widgets/page_refresh.dart';
import 'component/faq_app_bar.dart';
import 'component/faq_list_widget.dart';
import 'controllers/faq_cubit/faq_cubit.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<FaqCubit>().getFaqList(true));
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 120;
    return Scaffold(
      body: PageRefresh(
        onTap: () => context.read<FaqCubit>().getFaqList(false),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: redColor),
              title: Text(
                'FAQ',
                style: TextStyle(color: Colors.white),
              ),
              titleSpacing: 0,
              leading: AppbarLeading(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            BlocBuilder<FaqCubit, FaqCubitState>(
              builder: (context, state) {
                if (state is FaqCubitStateLoaded) {
                  if (state.faqCategoryList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Faq Not Found!",style: GoogleFonts.firaSansCondensed(fontSize: 18),),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 48,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: OutlinedButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Back"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return MultiSliver(
                    children: [
                      SliverToBoxAdapter(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: [
                            ...List.generate(state.faqCategoryList.length, (index) {
                              return Material(
                                borderRadius: BorderRadius.circular(6),
                                color: selectedIndex == index ? redColor : Colors.white,
                                elevation: 3,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: (){
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(state.faqCategoryList[index].icon, size: 24,color: selectedIndex == index ? Colors.white : Colors.black87,),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(state.faqCategoryList[index].name,style: TextStyle(color: selectedIndex == index ? Colors.white : Colors.black87),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 16,
                        ),
                      ),
                      SliverLayoutBuilder(
                        builder: (context,constraints) {
                          if (state.faqCategoryList[selectedIndex].faqs.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black45)
                                    ),
                                    child: Text("Data Not Found For #${state.faqCategoryList[selectedIndex].name}")),
                              ),
                            );
                          }
                          return FaqListWidget(faqList: state.faqCategoryList[selectedIndex].faqs);
                        }
                      ),
                    ],
                  );
                } else if (state is FaqCubitStateLoading) {
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is FaqCubitStateError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        state.errorMessage,
                        style: const TextStyle(color: redColor),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
