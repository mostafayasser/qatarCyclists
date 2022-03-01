import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class EventItemVertical extends StatelessWidget {
  final EventData ride;
  final bool virtical;
  final Function onTap;
  final category;

  const EventItemVertical(
      {Key key, this.ride, this.virtical, this.onTap, this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final free =
        (ride?.freePaid == 0 ?? false) || ((ride?.cost ?? 0) == 0 ?? false);

    final cost = ride.cost;

    return InkWell(
      onTap: () => onTap == null
          ? UI.push(context, Routes.eventDetail(ride, true, category))
          : onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, offset: Offset(0, 0), blurRadius: 3)
            ]),
        child: Column(
          children: [
            image(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170,
                    child: Text(ride.title,
                        style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ride.startDate != null && ride.startDate != ""
                        ? Text(
                            DateFormat(
                                    'MMMMd, yyyy', locale.locale.languageCode)
                                .format(DateTime.parse(ride.startDate)),
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis)
                        : Text(
                            locale.get('To be announced') ?? 'To be announced',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis),
                  ),
                  Row(
                    children: [
                      Text(locale.get('Read More') ?? 'Read More',
                          style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Container(
                        width: 80,
                        // height: 24,
                        alignment: Alignment.center,
                        margin: EdgeInsetsDirectional.only(start: 5),
                        child: Text(
                          (ride.type == 'user_ride'
                              ? locale.get((ride?.status ?? 0) == 1
                                  ? 'Approved'
                                  : 'Pending')
                              : free
                                  ? locale.get('Free')
                                  : locale.get('QAR') +
                                      ' ' +
                                      (cost?.toString() ?? '0')),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentElement,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  image(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: RoundedWidget(
        child: Container(
          width: 160,
          height: 130,
          // margin: EdgeInsetsDirectional.only(end: 5),
          child: (ride.media.url == null || ride.media.url.isEmpty)
              ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
              : CachedNetworkImage(
                  imageUrl: ride.media.url,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
