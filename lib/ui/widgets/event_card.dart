import 'package:base_notifier/base_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';

class EventCard extends StatelessWidget {
  final EventData ride;
  final bool virtical;
  final Function onTap;
  final category;
  const EventCard(
      {Key key, this.ride, this.virtical = false, this.onTap, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: virtical
          ? ScreenUtil.portrait
              ? ScreenUtil.screenWidthDp / 2
              : ScreenUtil.screenWidthDp / 3
          : null,
      // height: virtical ? ScreenUtil.portrait ? ScreenUtil.screenWidthDp / 2 : ScreenUtil.screenWidthDp / 3 : null,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => onTap == null
            ? UI.push(context, Routes.eventDetail(ride, true, category))
            : onTap(),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: virtical
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      image(context),
                      Container(
                        padding: EdgeInsetsDirectional.only(
                            start: 10, top: virtical ? 5 : null),
                        child: content(context),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      image(context),
                      Expanded(
                        child: Container(
                            height: 120,
                            padding:
                                const EdgeInsetsDirectional.only(start: 10),
                            child: content(context)),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  image(BuildContext context) {
    return RoundedWidget(
      child: Container(
        width: 132,
        height: 100,
        // margin: EdgeInsetsDirectional.only(end: 5),
        child: (ride.media.url == null || ride.media.url.isEmpty)
            ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: ride.media.url,
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
      ),
    );
  }

  content(BuildContext context) {
    final locale = AppLocalizations.of(context);

    final free = ride?.freePaid == 1 ?? false;
    final cost = ride.cost;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ride.title,
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
            overflow: TextOverflow.ellipsis),
        if (!virtical)
          Text(ride.venue,
              style: TextStyle(color: Colors.grey, fontSize: 12),
              overflow: TextOverflow.ellipsis),
        if (!virtical) SizedBox(height: 5),
        if (!virtical)
          Text(ride.description,
              style: TextStyle(color: Colors.grey, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2),
        SizedBox(height: 5),
        Text(DateFormat('MMMMd, yyyy').format(DateTime.parse(ride.startDate)),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        Text(DateFormat('jm').format(DateTime.parse(ride.startDate)),
            style: TextStyle(color: AppColors.secondaryText, fontSize: 13)),
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            if (!virtical)
              Container(
                width: 80,
                height: 24,
                alignment: Alignment.center,
                child: RichText(
                    text: TextSpan(
                  text: (ride?.registrationsCount?.toString() ?? '0'),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(text: ' '),
                    TextSpan(
                      text: (locale.get('Attending') ?? 'Attending'),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                )),
                decoration: BoxDecoration(
                  color: AppColors.primaryElement,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            if (virtical)
              Text('Read More',
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
            Container(
              width: 80,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsetsDirectional.only(start: 5),
              child: Text(
                (ride.type == 'user_ride'
                    ? locale
                        .get((ride?.status ?? 0) == 1 ? 'Approved' : 'Pending')
                    : free
                        ? locale.get('Free')
                        : locale.get('QAR') + ' ' + (cost?.toString() ?? '0')),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
              ),
              decoration: BoxDecoration(
                color: AppColors.accentElement,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
