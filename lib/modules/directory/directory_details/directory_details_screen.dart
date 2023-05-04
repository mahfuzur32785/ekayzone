import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/directory/directory_details/controller/directory_details_bloc.dart';

import '../model/directory_model.dart';
import 'component/directory_details_claim.dart';
import 'component/directory_details_contact.dart';
import 'component/directory_details_image.dart';
import 'component/directory_details_info.dart';
import 'component/directory_details_map_view.dart';
import 'component/directory_details_share.dart';

class DirectoryDetailsScreen extends StatefulWidget {
  const DirectoryDetailsScreen({Key? key, required this.directoryModel})
      : super(key: key);
  final DirectoryModel directoryModel;

  @override
  State<DirectoryDetailsScreen> createState() => _DirectoryDetailsScreenState();
}

class _DirectoryDetailsScreenState extends State<DirectoryDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<DirectoryDetailsBloc>().add(
        DirectoryDetailsEventGetData(
            widget.directoryModel.id, widget.directoryModel.slug)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Directory Details"),
      ),
      body: BlocBuilder<DirectoryDetailsBloc, DirectoryDetailsState>(
        builder: (context, state) {
          if (state is DirectoryDetailsStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DirectoryDetailsStateError) {
            return Center(
              child: Text(state.message),
            );
          }
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 8,
                ),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsImage(
                  image: widget.directoryModel.thumbnail,
                ),
              ),
              SliverToBoxAdapter(
                child:
                    DirectoryDetailsInfo(directoryModel: widget.directoryModel),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsClaim(postId: widget.directoryModel.id,),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsContact(postId: widget.directoryModel.id,),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsShare(
                    directoryModel: widget.directoryModel),
              ),
              SliverToBoxAdapter(
                child: DirectoryDetailsMapView(
                    directoryModel: widget.directoryModel),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
