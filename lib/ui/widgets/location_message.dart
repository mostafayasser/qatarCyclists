import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qatarcyclists/core/services/firebase/fire_store_service.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMessage extends StatelessWidget {
  final double lat;
  final double long;
  final String time;
  final bool sent;
  final String senderName;
  final String id;

  LocationMessage(
      {Key key,
      this.lat,
      this.long,
      this.time,
      this.sent,
      this.senderName,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {
      Marker(
        markerId: MarkerId("marker"),
        position: LatLng(lat, long),
      )
    };
    return GestureDetector(
      onLongPress: () async {
        if (sent) {
          final res = await UI.dialog(
            context: context,
            title: "Delete this message",
            msg: "Are you sure you want to delete this message?",
            accept: true,
            acceptMsg: "Delete",
            cancelMsg: "Cancel",
          );
          if (res != null && res) {
            FireStoreService.deleteMessage(id);
          }
        }
      },
      child: Align(
        alignment:
            sent ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
        child: Container(
          width: ScreenUtil.screenWidthDp / 1.2,
          // height: 66,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          alignment: AlignmentDirectional.topStart,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(17),
                topEnd: Radius.circular(17),
                bottomEnd: !sent ? Radius.circular(17) : Radius.circular(0),
                bottomStart: sent ? Radius.circular(17) : Radius.circular(0),
              ),
              color: sent ? Colors.grey[400] : AppColors.primaryElement),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!sent)
                Text(
                  senderName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              Container(
                height: ScreenUtil.screenHeightDp / 3.5,
                child: GoogleMap(
                  key: Key('$id location'),
                  padding: EdgeInsets.only(top: 25),
                  mapToolbarEnabled: false,
                  markers: markers,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  // zoomControlsEnabled: false,
                  // compassEnabled: true,
                  //liteModeEnabled: true,
                  onTap: (ltlng) async {
                    /* final url =
                        'http://maps.apple.com/?q=${ltlng.latitude},${ltlng.longitude}'; */
                    final url =
                        'https://www.google.com/maps/search/?api=1&query=${ltlng.latitude},${ltlng.longitude}';

                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    zoom: 15,
                    tilt: 10,
                    target: LatLng(lat, long),
                  ),
                ),
              ),
              Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Text(time, style: TextStyle(color: Colors.white)))
            ],
          ),
        ),
      ),
    );
  }
}
