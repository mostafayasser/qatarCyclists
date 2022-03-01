import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/buttons/normal_button.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:share/share.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

enum CategoryType { upcoming_events, user_rides, trainings, past_events }

class EventDetailPage extends StatelessWidget {
  final EventData data;
  final bool canRegister;
  final category;
  const EventDetailPage(
      {Key key, this.data, this.canRegister = true, this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<EventDetailPageModel>(
            model: EventDetailPageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                eventData: data),
            builder: (context, model, child) {
              return Column(
                children: <Widget>[
                  buildHeaderColor(context, category),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: 238.7,
                          height: 222.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: model.eventData.media.url == null ||
                                      model.eventData.media.url == ""
                                  ? AssetImage('assets/images/logo.png')
                                  : NetworkImage(model.eventData.media.url),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        buildBody(context, model),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  // Header color & icon.
  Widget buildHeaderColor(context, category) {
    final locale = AppLocalizations.of(context);
    print("category : $category");
    return HeaderColor(
      hasBack: true,
      hasTitle: true,
      titleImage: 'event_bar_fill.png',
      title: category == null
          ? locale.get("EVENT DETAILS") ?? "EVENT DETAILS"
          : category.index == CategoryType.trainings.index
              ? locale.get("TRAINING DETAILS") ?? "TRAINING DETAILS"
              : category.index == CategoryType.user_rides.index
                  ? locale.get("RIDE DETAILS") ?? "RIDE DETAILS"
                  : locale.get("EVENT DETAILS") ?? "EVENT DETAILS",
    );
  }

  Widget buildBody(context, EventDetailPageModel model) {
    final locale = AppLocalizations.of(context);
    final formatter = DateFormat('MMMMd, yyyy', locale.locale.languageCode);
    final timeFormatter = DateFormat('jm', locale.locale.languageCode);
    final endDate = data.endDate != null && data.endDate.isNotEmpty
        ? formatter.format(DateTime.parse(data.endDate))
        : '';
    final startDate = data.startDate != null && data.startDate.isNotEmpty
        ? formatter.format(DateTime.parse(data.startDate))
        : '';

    final endTime = data.endDate != null && data.endDate.isNotEmpty
        ? timeFormatter.format(DateTime.parse(data.endDate))
        : '';
    final startTime = data.startDate != null && data.startDate.isNotEmpty
        ? timeFormatter.format(DateTime.parse(data.startDate))
        : '';

    final free =
        (data?.freePaid == 0 ?? false) || ((data?.cost ?? 0) == 0 ?? false);
    final cost = data.cost;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Stack(
        children: [
          Container(
            height: ScreenUtil.screenHeightDp / 1.15,
          ),
          buildEventCard(context, startDate, locale, endDate, startTime,
              endTime, free, cost, model),
        ],
      ),
    );
  }

  Container buildEventCard(
      context,
      String startDate,
      AppLocalizations locale,
      String endDate,
      String startTime,
      String endTime,
      bool free,
      int cost,
      EventDetailPageModel model) {
    Logger().i(data.toJson());
    final dateAnnounced = startDate != null && startDate != "";
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 3, offset: Offset(0, 0))
          ]),
      margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 50),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  data.title,
                  style:
                      TextStyle(color: AppColors.secondaryText, fontSize: 25),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                        "Check out Qatar Cyclists event ${data.title} at ${data.venue} on $startDate",
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  })
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: <Widget>[
              Icon(Icons.location_on, size: 17, color: Colors.grey),
              SizedBox(
                width: 10,
              ),
              Text(data.venue,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          SizedBox(height: 5),
          if (data.owner != null)
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  data.owner.name != null ? data.owner.name : '',
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[400]),
                )
              ],
            ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category == null
                        ? locale.get("EVENT DETAILS") ?? "EVENT DETAILS"
                        : category.index == CategoryType.trainings.index
                            ? locale.get("TRAINING DATE") ?? "TRAINING DATE"
                            : category.index == CategoryType.user_rides.index
                                ? locale.get("RIDE DATE") ?? "RIDE DATE"
                                : locale.get("EVENT DATE") ?? "EVENT DATE",
                  ),
                  SizedBox(height: 5),
                  dateAnnounced && endDate != null && endDate != ""
                      ? Text(startDate + ' - \n' + endDate,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis)
                      : endDate == null || endDate == ""
                          ? Text(startDate,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis)
                          : Text(
                              locale.get('To be announced') ??
                                  'To be announced',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  //if (dateAnnounced)
                  endTime != null && endTime != ""
                      ? Text(startTime + ' - ' + endTime,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis)
                      : Text(startTime,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 55,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.primaryElement,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(locale.get('Attending') ?? 'Attending',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                            Text(data?.registrationsCount?.toString() ?? '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 45,
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.accentElement,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!free)
                              Text(locale.get('QAR') ?? 'QAR',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            Text(
                                free
                                    ? locale.get('Free') ?? 'Free'
                                    : cost?.toString() ?? '0',
                                style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: RoundedWidget(
                  child: Container(
                    // width: ScreenUtil.screenWidthDp / 3,
                    height: ScreenUtil.screenHeightDp / 5.5,
                    child: GoogleMap(
                        padding: EdgeInsets.only(top: 25),
                        buildingsEnabled: false,
                        mapToolbarEnabled: false,
                        onTap: (ltlng) async {
                          /* final url =
                              'http://maps.apple.com/?q=${ltlng.latitude},${ltlng.longitude}'; */
                          // final url =
                          //     'https://www.google.com/maps/search/?api=1&query=${ltlng.latitude},${ltlng.longitude}';
                          // if (await canLaunch(url)) {
                          //   await launch(url);
                          // }

                          var url = 'geo:${ltlng.latitude},${ltlng.longitude}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            // iOS
                            url =
                                'http://maps.apple.com/?ll=${ltlng.latitude},${ltlng.longitude}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        },
                        compassEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        circles: (data.lat != null && data.long != null)
                            ? Set.from([
                                Circle(
                                    circleId: CircleId(data.id.toString()),
                                    center: LatLng(
                                        double.tryParse(data?.lat ?? '22.2'),
                                        double.tryParse(data?.long ?? '22.2')),
                                    fillColor:
                                        Colors.lightBlue[400].withOpacity(.4),
                                    radius: 20,
                                    strokeColor: Colors.blue.withOpacity(.5),
                                    strokeWidth: 1,
                                    visible: true)
                              ])
                            : null,
                        initialCameraPosition: CameraPosition(
                          zoom: 16,
                          tilt: 10,
                          target: LatLng(double.tryParse(data?.lat ?? '22.2'),
                              double.tryParse(data?.long ?? '22.2')),
                        )),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(category == null
              ? locale.get("EVENT DETAILS") ?? "EVENT DETAILS"
              : category.index == CategoryType.trainings.index
                  ? locale.get("TRAINING DETAILS") ?? "TRAINING DETAILS"
                  : category.index == CategoryType.user_rides.index
                      ? locale.get("RIDE DETAILS") ?? "RIDE DETAILS"
                      : locale.get("EVENT DETAILS") ?? "EVENT DETAILS"),
          SizedBox(height: 5),
          Text(
            data.description,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          if ((data.register == 1 && canRegister) || data.type == "user_ride")
            buildRegisterButton(context, locale, model)
        ],
      ),
    );
  }

  Align buildRegisterButton(BuildContext context, AppLocalizations locale,
      EventDetailPageModel model) {
    return Align(
      alignment: Alignment.center,
      child: NormalButton(
        text: model.eventData.type == "user_ride"
            ? locale.get('JOIN') ?? 'JOIN'
            : locale.get('REGISTER') ?? 'REGISTER',
        width: 222,
        localize: false,
        gradient: null,
        onPressed: () => model.registerEvent(context),
        busy: false,
      ),
    );
  }
}

class EventDetailPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final EventData eventData;

  EventDetailPageModel({
    NotifierState state,
    this.eventData,
    this.api,
    this.auth,
  }) : super(state: state);

  registerEvent(BuildContext context) async {
    if (!auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else {
      final route = eventData.type == 'training'
          ? Routes.registerTraining(eventData: eventData)
          : eventData.type == 'user_ride'
              ? Routes.joinRide(eventData: eventData)
              : Routes.registerEvent(eventData: eventData);

      final registered = await UI.push(context, route) as bool ?? false;
      if (registered != null && registered) {
        eventData.register = 1;
        eventData.registrationsCount = eventData.registrationsCount + 1;
        setState();
      }
    }
  }
}
