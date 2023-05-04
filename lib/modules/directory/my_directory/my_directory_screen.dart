import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/core/router_name.dart';
import 'package:ekayzone/modules/directory/my_directory/controller/my_directory_bloc.dart';
import 'package:ekayzone/modules/directory/my_directory/controller/my_directory_bloc.dart';
import 'package:ekayzone/utils/constants.dart';

import '../../../utils/utils.dart';
import '../component/directory_card.dart';

class MyDirectoryScreen extends StatefulWidget {
  const MyDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<MyDirectoryScreen> createState() => _MyDirectoryScreenState();
}

class _MyDirectoryScreenState extends State<MyDirectoryScreen> {

  final _scrollController = ScrollController();

  late MyDirectoryBloc directoryBloc;

  @override
  void initState() {
    super.initState();
    directoryBloc = context.read<MyDirectoryBloc>();
    if (directoryBloc.directoryList.isEmpty) {
      directoryBloc.add(
          const MyDirectoryEventSearch());
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
        directoryBloc.add(const MyDirectoryEventLoadMore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Directories"),
      ),
      body: BlocConsumer<MyDirectoryBloc, MyDirectoryState>(
        listener: (context, state) {
          if (state is MyDirectoryStateMoreError) {
            Utils.errorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is MyDirectoryStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MyDirectoryStateInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is MyDirectoryStateError) {
            return Center(
              child: Text(state.message),
            );
          }
          final directoryList = directoryBloc.directoryList;
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: directoryList.isEmpty ? 16 : 0),
                      sliver: SliverToBoxAdapter(
                        child: Visibility(
                          visible: directoryList.isEmpty,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RouteNames.createDirectoryScreen);
                              },
                              child: const Text("Create Directory"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0,),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => DirectoryCard(deleteAd: (){},directoryModel: directoryList[index],),
                          childCount: directoryList.length
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: state is MyDirectoryStateLoadMore,
                child: const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.createDirectoryScreen);
        },
        backgroundColor: redColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
