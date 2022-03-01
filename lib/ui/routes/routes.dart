import 'package:flutter/material.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/ui/pages/chat_pages/add_chat_page.dart';
import 'package:qatarcyclists/ui/pages/chat_pages/add_group_chat_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/category_events.dart';
import 'package:qatarcyclists/ui/pages/events_pages/create_new_event_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/event_detail_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/join_ride_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/my_events_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/my_rides_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/register_event_page.dart';
import 'package:qatarcyclists/ui/pages/events_pages/register_training_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/edit_profile.dart';
import 'package:qatarcyclists/ui/pages/main_pages/home_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/signin_screen.dart';
import 'package:qatarcyclists/ui/pages/main_pages/signup_screen.dart';
import 'package:qatarcyclists/ui/pages/main_pages/slider_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/splash_screen.dart';
import 'package:qatarcyclists/ui/pages/cycling-tracks.dart';
import 'package:qatarcyclists/ui/pages/articles_news.dart';
import 'package:qatarcyclists/ui/pages/article_page.dart';

class Routes {
  static Widget get splash => SplashScreen();
  static Widget get slider => SliderPage();
  static Widget get signUp => SignUpScreen();
  static Widget get cycling => CyclingTracks();

  static Widget get signIn => SigninScreen();
  static Widget get homePageScreen => HomePageScreen();
  static Widget get editProfileScreen => EditProfile();
  static Widget get myEvents => MyEventsPage();
  static Widget get myRides => MyRidesPage();
  static Widget get articlesNews => ArticlesNews();
  static Widget get article => ArticlePage();

  static Widget categoryEvents(Categories category, Sponsor sponsor) =>
      CategoryEventsPage(
        category: category,
        sponsor: sponsor,
      );
  static Widget eventDetail(EventData event, bool canRegister, category) =>
      EventDetailPage(
          data: event, canRegister: canRegister, category: category);

  static Widget registerEvent({EventData eventData}) =>
      RegisterEventPage(eventData: eventData);
  static Widget registerTraining({EventData eventData}) =>
      RegisterTrainingPage(eventData: eventData);
  static Widget joinRide({EventData eventData}) =>
      JoinRidePage(eventData: eventData);
  static Widget get createNewEvent => CreateNewEventPage();
  static Widget get addChat => AddChatPage();
  static Widget get addGroupChat => AddGroupChatPage();
}
