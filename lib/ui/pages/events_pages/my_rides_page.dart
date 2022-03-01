import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/page_models/events_pages_models/my_rides_page_model.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/styles/styles.dart';
import 'package:qatarcyclists/ui/widgets/event_item_horizontal.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';

class MyRidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<MyRidesPageModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.getMyEvents(context)),
            model: MyRidesPageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                state: NotifierState.busy),
            builder: (context, model, child) {
              return model.busy
                  ? buildLoadingData(context, model, locale)
                  : buildMyEventsData(context, model);
            }),
      ),
    );
  }

  buildLoadingData(
      BuildContext context, MyRidesPageModel model, AppLocalizations locale) {
    return Column(
      children: <Widget>[
        buildHeaderColor(context, locale),
        Expanded(child: Center(child: LoadingIndicator())),
      ],
    );
  }

  // Header color & icon.
  Widget buildHeaderColor(context, locale) {
    return HeaderColor(
      hasBack: true,
      hasTitle: true,
      title: locale.get('RIDES') ?? 'RIDES',
      titleImageColor: AppColors.accentElement,
    );
  }

  buildMyEventsData(BuildContext context, MyRidesPageModel model) {
    return Container(
      height: ScreenUtil.screenHeightDp,
      width: ScreenUtil.screenWidthDp,
      child: Column(
        children: <Widget>[
          buildHeaderColor(context, AppLocalizations.of(context)),
          Expanded(
              child: Column(
            children: [
              buildEventTypeRow(context, model),
              buildEventList(context, model),
            ],
          ))
        ],
      ),
    );
  }

  buildEventTypeRow(BuildContext context, MyRidesPageModel model) {
    final locale = AppLocalizations.of(context);
    final isEnglish =
        Provider.of<AppLanguageModel>(context, listen: false).appLocal ==
            Locale('en');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          opacity: model.index == 0 ? 1 : .4,
          child: InkWell(
            onTap: () => model.index == 1
                ? model.changeTap(index: 0, context: context)
                : {},
            child: Container(
              width: ScreenUtil.screenWidthDp / 4,
              height: 28,
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: isEnglish ? Radius.circular(8) : Radius.circular(0),
                      right:
                          isEnglish ? Radius.circular(0) : Radius.circular(8)),
                  border: Border.all(color: Colors.grey),
                  color: model.index == 0 ? Colors.grey[400] : Colors.white),
              child: Text(
                locale.get('REGISTERED') ?? 'REGISTERED',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xff1d2022)),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: model.index == 1 ? 1 : .4,
          child: InkWell(
            onTap: () => model.index == 0
                ? model.changeTap(index: 1, context: context)
                : {},
            child: Container(
              width: ScreenUtil.screenWidthDp / 4,
              height: 28,
              padding: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(!isEnglish ? 8 : 0),
                      right: Radius.circular(!isEnglish ? 0 : 8)),
                  border: Border.all(color: Colors.grey),
                  color: model.index == 1 ? Colors.grey[400] : Colors.white),
              child: Text(
                locale.get('MY Rides') ?? 'MY Rides',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xff1d2022)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildEventList(BuildContext context, MyRidesPageModel model) {
    final locale = AppLocalizations.of(context);

    return Expanded(
        child: model.index == 0
            ? model.busy
                ? CircularProgressIndicator()
                : model.myRides.myRides.data.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        itemCount: model.myRides.myRides.data.length,
                        itemBuilder: (context, index) {
                          final ride = model.myRides.myRides.data[index];
                          return EventItemHorizontal(ride: ride);
                        },
                      )
                    : Center(child: Text(locale.get('empty') ?? 'empty'))
            : model.myRides.hostedRides.data.isNotEmpty
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    itemCount: model.myRides.hostedRides.data.length,
                    itemBuilder: (context, index) {
                      final ride = model.myRides.hostedRides.data[index];

                      return EventItemHorizontal(ride: ride);
                    },
                  )
                : Center(child: Text(locale.get('empty') ?? 'empty')));
  }
}
