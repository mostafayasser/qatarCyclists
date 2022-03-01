import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/auth/authentication_service.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/pages/main_pages/chat_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/events_page.dart';
import 'package:qatarcyclists/ui/pages/main_pages/profile_screen.dart';
import 'package:qatarcyclists/ui/pages/main_pages/weather/weather_tab.dart';
import 'package:qatarcyclists/ui/widgets/buttons/raised_button.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import '../../widgets/buttons/switch_language_button.dart';

import '../../../core/page_models/main_pages_models/home_page_model.dart';
import 'shop_tab.dart';

class HomePageScreen extends StatelessWidget {
  final pages = [
    EventsPage(),
    WeatherTab(),
    ChatPage(),
    ShopTap(),
    WeatherTab(),
  ];

  Drawer draw(BuildContext context, HomePageModel model) {
    final locale = AppLocalizations.of(context);

    return Drawer(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: [
          Column(
            children: [
              model.auth.userLoged
                  ? CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: Text(model.auth.user.name.substring(0, 2)),
                    )
                  : Text(''),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.auth.userLoged ? model.auth.user.name : "",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    color: const Color(0xff91143b),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.auth.userLoged ? model.auth.user.email : "",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 50,
                  child: Button(
                      borderRadius: 25,
                      color: Colors.white,
                      borderColor: Colors.grey[600],
                      text: model.auth.userLoged
                          ? locale.get("EDIT PROFILE") ?? "EDIT PROFILE"
                          : locale.get("Sign in") ?? "Sign in",
                      textColor: Colors.grey[600],
                      onClicked: () {
                        if (model.auth.userLoged) {
                          UI.push(context, Routes.editProfileScreen);
                        } else {
                          UI.push(context, Routes.signIn);
                        }
                      }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (model.auth.userLoged) {
                      UI.push(context, Routes.myEvents);
                    } else {
                      UI.push(context, Routes.signIn);
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/Registered_Events.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        locale.get('Registered Events') ?? 'Registered Events',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.grey[600],
                          // color: const Color(0xff788293),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[800],
              width: double.infinity,
              height: 0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (model.auth.userLoged) {
                  UI.push(context, Routes.myRides);
                } else {
                  UI.push(context, Routes.signIn);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/My_Rides.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        locale.get('My Rides') ?? 'My Rides',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.grey[600],
                          // color: const Color(0xff788293),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[800],
              width: double.infinity,
              height: 0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    UI.push(context, Routes.cycling);
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/Cycling_tracks.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        locale.get('Cycling tracks') ?? 'Cycling tracks',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.grey[600],
                          // color: const Color(0xff788293),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[800],
              width: double.infinity,
              height: 0.2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    UI.push(context, Routes.articlesNews);
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/images/Articles&News.png'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        locale.get('Articles & News') ?? 'Articles & News',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.grey[600],
                          // color: const Color(0xff788293),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Colors.grey[800],
              width: double.infinity,
              height: 0.2,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          model.auth.userLoged
              ? Center(
                  child: Container(
                    width: 150,
                    height: 50,
                    child: Button(
                        borderRadius: 25,
                        color: Color(0xff91143b),
                        borderColor: Colors.white,
                        text: locale.get("Log out") ?? "Log out",
                        textColor: Colors.white,
                        onClicked: () {
                          Provider.of<AuthenticationService>(context,
                                  listen: false)
                              .signOut;
                          UI.push(context, Routes.signIn);
                        }),
                  ),
                )
              : Text(''),
          Spacer(),
          _buildLanguageButton(model, context),
        ]),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidget<HomePageModel>.staticBuilder(
        model: HomePageModel(auth: Provider.of(context)),
        staticBuilder: (context, model) {
          return Scaffold(
            key: model.key,
            endDrawer: draw(context, model),
            bottomNavigationBar: navigationBar(context),
            body: PageView.builder(
              physics: new NeverScrollableScrollPhysics(),
              controller: model.pageController,
              onPageChanged: model.onPageChanged,
              itemBuilder: (context, index) => pages[index],
            ),
          );
        },
      ),
    );
  }

  navigationBar(context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<HomePageModel>.cosnume(builder: (context, model, child) {
      return BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 10,
          iconSize: 25,
          selectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: TextStyle(fontSize: 13, height: 1.3),
          unselectedLabelStyle: TextStyle(fontSize: 11),
          currentIndex: model.pageIndex,
          onTap: (index) => model.onChangeTab(context, index),
          items: [
            BottomNavigationBarItem(
              title: Text(
                locale.get('Events') ?? 'Events',
              ),
              activeIcon:
                  Image.asset('assets/images/event_bar_fill.png', height: 25),
              icon: Image.asset('assets/images/event_bar.png', height: 25),
            ),
            BottomNavigationBarItem(
              title: Text(
                locale.get('Weather') ?? 'Weather',
              ),
              activeIcon:
                  Image.asset('assets/images/weather_bar_fill.png', height: 25),
              icon: Image.asset('assets/images/weather_bar.png', height: 25),
            ),
            BottomNavigationBarItem(
              title: Text(
                locale.get('Chat') ?? 'Chat',
              ),
              activeIcon:
                  Image.asset('assets/images/chat_bar_fill.png', height: 25),
              icon: Image.asset('assets/images/chat_bar.png', height: 25),
            ),
            BottomNavigationBarItem(
              title: Text(
                locale.get('Shop') ?? 'Shop',
              ),
              activeIcon:
                  Image.asset('assets/images/shop_bar_fill.png', height: 25),
              icon: Image.asset('assets/images/shop_bar.png', height: 25),
            ),
            BottomNavigationBarItem(
              title: Text(
                locale.get('Menu') ?? 'Menu',
              ),
              activeIcon: Image.asset('assets/images/menu.png', height: 25),
              icon: Image.asset('assets/images/menu.png', height: 25),
            ),
          ]);
    });
  }

  Column _buildLanguageButton(HomePageModel model, BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchLanguageButton(),
        SizedBox(height: ScreenUtil.screenHeightDp * 0.02),
        // Text(AppLocalizations.of(context).get('SIGN IN')),
      ],
    );
  }
}
