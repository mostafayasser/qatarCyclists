import 'package:flutter/material.dart';
import 'package:base_notifier/base_notifier.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/models/cyclingtrack.dart';
import 'package:url_launcher/url_launcher.dart';

class CyclingTracks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseWidget<CyclingTracksModel>(
          initState: (m) => m.getCyclingTracks(context),
          model: CyclingTracksModel(
            local: AppLocalizations.of(context),
            api: Provider.of(context),
            auth: Provider.of(context),
          ),
          builder: (context, model, _) {
            return FocusWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // app bar.
                  buildHeaderColor(context),
                  // image & title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      locale.get('CYCLING TRACKS') ?? 'CYCLING TRACKS',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey[600],
                          fontSize: 15),
                    ),
                  ),
                  model.busy
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : listCard(context, model, locale)
                ],
              ),
            );
          }),
    );
  }

  Widget listCard(
      BuildContext context, CyclingTracksModel model, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.cyclingTrack.responsee.result.data.length,
          itemBuilder: (context, i) {
            return Card(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            model.cyclingTrack.responsee.result.data[i].media[0]
                                .url,
                            width: 150,
                            height: 100,
                          )),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.cyclingTrack.responsee.result.data[i].title,
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.cyclingTrack.responsee.result.data[i]
                                      .venue,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 30,
                              width: 130,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Color(0xff91143b))),
                                onPressed: () {
                                  openMap(
                                      double.parse(model.cyclingTrack.responsee
                                          .result.data[i].lat),
                                      double.parse(model.cyclingTrack.responsee
                                          .result.data[i].long));
                                },
                                color: Color(0xff91143b),
                                textColor: Colors.white,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/go.png',
                                      width: 10,
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        locale.get('Get Direction') ??
                                            'Get Direction',
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              '',
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/direction.png',
                                    width: 15,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '33 km',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryText),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Container buildLoadingScreen(context) {
    return Container(
      width: ScreenUtil.screenWidthDp,
      height: ScreenUtil.screenHeightDp,
      child: Column(
        children: <Widget>[
          buildHeaderColor(context),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  // Header color & icon.
  HeaderColor buildHeaderColor(context) {
    final locale = AppLocalizations.of(context);

    return HeaderColor(
      hasTitle: true,
      title: locale.get('CYCLING TRACKS') ?? 'CYCLING TRACKS',
      //titleImage: 'profile_bar.png',
      titleImageColor: AppColors.accentElement,
      hasBack: true,
    );
  }
}

class CyclingTracksModel extends BaseNotifier {
  AppLocalizations local;
  final HttpApi api;
  final AuthenticationService auth;
  CyclingTracksModel({this.local, this.api, this.auth}) {}

  CyclingTrackModel cyclingTrack;

  getCyclingTracks(context) async {
    setBusy();
    try {
      cyclingTrack = await api.getCycleTracks(context);
      print("Cycle Tracks");
      print(cyclingTrack.responsee.result.data.length);
    } catch (e) {
      setError();
    }
    setIdle();
  }
}
