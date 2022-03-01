import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/core/services/api/http_api.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/widgets/category_card.dart';
import 'package:qatarcyclists/ui/widgets/event_item_vertical.dart';
import 'package:qatarcyclists/ui/widgets/header_color.dart';
import 'package:qatarcyclists/ui/widgets/loading_widget.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<EventsPageModel>(
            initState: (m) => m.getEvents(context),
            model: EventsPageModel(
                api: Provider.of(context),
                auth: Provider.of(context),
                state: NotifierState.busy),
            builder: (context, model, child) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  children: [
                    buildHeaderColor(context),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 5, right: 20),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  locale.get('FEATURED EVENTS') ??
                                      'FEATURED EVENTS',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            model.busy
                                ? buildLoadingData(context)
                                : buildMyEventsData(context, model),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

buildLoadingData(BuildContext context) {
  return Center(child: LoadingIndicator());
}

// Header color & icon.
Widget buildHeaderColor(context) {
  final locale = AppLocalizations.of(context);
  return HeaderColor(
    hasBack: false,
    hasTitle: true,
    titleImage: 'event_bar_fill.png',
    title: locale.get("EVENTS"),
  );
}

buildMyEventsData(BuildContext context, EventsPageModel model) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      buildFeaturedEvents(context, model),
      ...buildCategories(context, model),
      if (model.eventsAll.sponsor != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: GestureDetector(
            onTap: () async {
              if (await canLaunch(model.eventsAll.sponsor.url) &&
                  model.eventsAll.sponsor.url != null) {
                await launch(model.eventsAll.sponsor.url);
              }
            },
            child: Text(
              model.eventsAll.sponsor.title,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        )
    ],
  );
}

buildCategories(BuildContext context, EventsPageModel model) {
  final locale = AppLocalizations.of(context);
  bool categoriesAvailable =
      (model?.eventsAll?.events?.categories != null) ?? false;

  return !categoriesAvailable
      ? [Center(child: Text(locale.get('empty') ?? 'empty'))]
      : List.generate(
          model.eventsAll.events.categories.length,
          (i) {
            final category = model.eventsAll.events.categories[i];
            return CategoryCard(
              category: category,
              onTap: () => model.openCategory(
                  context, category, model.eventsAll.sponsor),
            );
          },
        );
}

buildFeaturedEvents(BuildContext context, EventsPageModel model) {
  final locale = AppLocalizations.of(context);
  bool featuredAvailable =
      (model?.eventsAll?.events?.featuredEvents?.data != null) ?? false;

  return !featuredAvailable
      ? Center(child: Text(locale.get('empty')))
      : Container(
          width: ScreenUtil.screenWidthDp,
          height: 280,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: model.eventsAll.events.featuredEvents.data.length,
            itemBuilder: (context, index) {
              final ride = model.eventsAll.events.featuredEvents.data[index];
              return EventItemVertical(ride: ride);
            },
          ),
        );
}

class EventsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  EventsAll eventsAll;
  EventsPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  getEvents(context) async {
    try {
      eventsAll = await api.getEventsAll(context);
      print("eventsAll");
      print(eventsAll);
    } catch (e) {
      setError();
    }
    setIdle();
  }

  openCategory(BuildContext context, Categories category, Sponsor sponsor) {
    UI.push(context, Routes.categoryEvents(category, sponsor));
  }
}
