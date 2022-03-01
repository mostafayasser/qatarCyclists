import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:qatarcyclists/ui/widgets/event_item_horizontal.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:qatarcyclists/ui/widgets/past_event_item.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

enum CategoryType { upcoming_events, user_rides, trainings, past_events }

class CategoryEventsPage extends StatelessWidget {
  final Categories category;
  final Sponsor sponsor;

  const CategoryEventsPage({Key key, this.category, this.sponsor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    // print(sponsor.url);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<CategoryEventsPageModel>(
            initState: (m) => m.getCategoryEvents(context),
            model: CategoryEventsPageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                state: NotifierState.busy,
                category: category),
            builder: (context, model, child) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildHeaderColor(
                        context,
                        (model.category.title).toUpperCase() ??
                            "UPCOMING EVENTS"),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTitleComming(model, locale),
                          if (model.categoryType == CategoryType.user_rides)
                            FlatButton(
                              onPressed: () => model.auth.userLoged
                                  ? model.createNewRide(context)
                                  : UI.push(context, Routes.signIn),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsetsDirectional.only(end: 5),
                                    width: 23,
                                    height: 23,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[200]),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.primaryElement,
                                      size: 17,
                                    ),
                                  ),
                                  Text(
                                    locale.get('Create ride') ?? 'Create ride',
                                    style: TextStyle(
                                        color: AppColors.primaryElement),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    Expanded(
                      child: model.busy
                          ? buildLoadingData(context)
                          : buildCategoryEventsData(context, model),
                    ),
                    sponsor != null
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(sponsor.url) &&
                                      sponsor.url != null) {
                                    await launch(sponsor.url);
                                  }
                                },
                                child: Text(
                                  sponsor.title,
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                          )
                        : Align()
                  ],
                ),
              );
            }),
      ),
    );
  }

  buildTitleComming(CategoryEventsPageModel model, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Text(
        locale.get(model.category.title).toUpperCase() ?? 'UPCOMING EVENTS',
        style: TextStyle(color: Colors.grey[400], fontSize: 20),
      ),
    );
  }

  buildLoadingData(BuildContext context) {
    return Center(child: LoadingIndicator());
  }

  // Header color & icon.
  Widget buildHeaderColor(context, title) {
    final locale = AppLocalizations.of(context);
    print("title $title");
    print("title ${locale.get(title)}");
    return HeaderColor(
      hasBack: true,
      hasTitle: true,
      titleImage: 'event_bar_fill.png',
      title: locale.get(title) ?? title,
    );
  }

  buildCategoryEventsData(BuildContext context, CategoryEventsPageModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: ScreenUtil.portrait
          ? ScreenUtil.screenHeightDp * 0.80
          : ScreenUtil.screenHeightDp * 0.7,
      // padding: EdgeInsets.only(bottom: 44),
      child: model.events?.isNotEmpty ?? false
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: model.events.length,
              itemBuilder: (context, index) {
                final ride = model.events[index];
                return (model.categoryType == CategoryType.past_events)
                    ? PastEventItem(
                        ride: ride,
                        canRegister: false,
                        category: model.categoryType)
                    : EventItemHorizontal(
                        ride: ride, category: model.categoryType);
              },
            )
          : Center(child: Text(locale.get('empty') ?? 'empty')),
    );
  }

  buildEventList(BuildContext context, {List<EventData> events = const []}) {}
}

class CategoryEventsPageModel extends BaseNotifier {
  final HttpApi api;
  final Categories category;
  final AuthenticationService auth;
  CategoryType categoryType;
  List<EventData> events;
  CategoryEventsPageModel(
      {NotifierState state, this.category, this.api, this.auth})
      : super(state: state) {
    try {
      categoryType = CategoryType.values.firstWhere(
          (o) => o.toString().contains(category.key),
          orElse: () => null);
    } catch (e) {
      print(e);
    }
  }

  getCategoryEvents(BuildContext context) async {
    try {
      events = await api.getCategoryEvents(context, category: category);
    } catch (e) {
      setError();
    }
    setIdle();
  }

  createNewRide(BuildContext context) async {
    if (categoryType == CategoryType.user_rides) {
      final created = await UI.push(context, Routes.createNewEvent);
      if (created != null && created) {
        setBusy();
        getCategoryEvents(context);
      }
    }
  }
}
