import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class EventItemHorizontal extends StatelessWidget {
  final EventData ride;
  final bool virtical;
  final Function onTap;
  final category;

  const EventItemHorizontal(
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
            Expanded(child: image(context), flex: 2),
            Expanded(
              flex: 3,
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            // width: 80,
                            // padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      text: (locale.get('Attending') ??
                                          'Attending'),
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
                        ),
                        (ride.type == 'user_ride')
                            ? Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: Colors.grey[400],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Text(
                                        ride.owner.name != null
                                            ? ride.owner.name
                                            : '',
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  height: 24,
                                  alignment: Alignment.center,
                                  margin: EdgeInsetsDirectional.only(start: 5),
                                  child: Text(
                                    (free
                                        ? locale.get('Free')
                                        : locale.get('QAR') +
                                            ' ' +
                                            (cost?.toString() ?? '0')),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 11),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentElement,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                ),
                              )
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
        child: Container(
          // margin: EdgeInsetsDirectional.only(end: 5),
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
      ),
    );
  }
}
