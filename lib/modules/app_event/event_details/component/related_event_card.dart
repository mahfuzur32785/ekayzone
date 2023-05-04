import 'package:flutter/material.dart';
import 'package:ekayzone/modules/app_event/model/event_model.dart';
import 'package:ekayzone/modules/home/component/price_card_widget.dart';
import 'package:ekayzone/modules/home/model/ad_model.dart';
import '../../../../core/remote_urls.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_image.dart';

class RelatedEventCard extends StatelessWidget {
  final EventModel eventModel;
  final double? width;
  final Function onPressed;
  const RelatedEventCard({
    Key? key,
    required this.eventModel,
    this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(6, 6)),
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(-6, -6)),
        ]
        // border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage()),
            const SizedBox(height: 0),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  "${eventModel.startDate} - ${eventModel.endDate}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: blackColor.withOpacity(.5),
                  ),
                ),
              ),
              const Spacer(),
              // Text('${productModel.rating}'),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            child: Text(
              eventModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black87,fontSize: 16, fontWeight: FontWeight.w500, height: 1),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            child: Text(
              eventModel.shortDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  height: 1),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  eventModel.cost > 0 ? "\$${eventModel.cost}" : "Free",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: eventModel.cost > 0 ? Colors.amber : Colors.green,
                      fontWeight: FontWeight.w600,
                      height: 1),
                ),
              ),
              // const Spacer(),
              Expanded(
                child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(shape: StadiumBorder()),
                        onPressed: () {
                          onPressed();
                        },
                        child: const Text("View Details"))),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white
          // border: Border(bottom: BorderSide(color: borderColor)),
          ),
      // height: 250,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        child: CustomImage(
            // path: RemoteUrls.imageUrl(productModel.image),
            //   path: adModel.galleries.isNotEmpty ? adModel.galleries[0].imageUrl : null,
            path: '${RemoteUrls.rootUrl}${eventModel.image}',
            fit: BoxFit.cover),
      ),
    );
  }
}
