import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class PastEventItem extends StatelessWidget {
  final EventData ride;
  final bool canRegister;
  final category;

  const PastEventItem({Key key, this.ride, this.canRegister, this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return InkWell(
      onTap: () => UI.push(context, Routes.eventDetail(ride, false, category)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        padding: EdgeInsetsDirectional.only(bottom: 6, top: 6, start: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, offset: Offset(0, 0), blurRadius: 3)
            ]),
        child: Row(
          children: [
            Expanded(
              child: image(context),
              flex: 1,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride.title,
                        style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(ride.venue,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis),
                    SizedBox(
                      height: 10,
                    ),
                    Text(ride.description,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ride.startDate != null && ride.startDate != ""
                          ? Text(
                              DateFormat(
                                      'MMMMd, yyyy', locale.locale.languageCode)
                                  .format(DateTime.parse(ride.startDate)),
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis)
                          : Text(
                              locale.get('To be announced') ??
                                  'To be announced',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        Container(
                          // width: 80,
                          padding: EdgeInsets.all(5),
                          height: 24,
                          alignment: Alignment.center,
                          child: RichText(
                              maxLines: 1,
                              text: TextSpan(
                                text: (ride?.registrationsCount?.toString() ??
                                    '0'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(text: ' '),
                                  TextSpan(
                                    text:
                                        (locale.get('Attended') ?? 'Attended'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ],
                              )),
                          decoration: BoxDecoration(
                            color: AppColors.primaryElement,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  image(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: RoundedWidget(
        child: (ride.media.url == null || ride.media.url.isEmpty)
            ? Image.asset('assets/images/logo.png',
                height: locale.locale == Locale('en') ? 110 : 140,
                fit: BoxFit.cover)
            : CachedNetworkImage(
                imageUrl: ride.media.url ?? '',
                height: locale.locale == Locale('en') ? 110 : 140,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                    'assets/images/logo.png',
                    height: locale.locale == Locale('en') ? 110 : 140,
                    fit: BoxFit.cover)),
      ),
    );
  }
}
