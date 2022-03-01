import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/weather.dart';
import '../../../../core/page_models/main_pages_models/weather_tab_model.dart';
import '../../../widgets/header_color.dart';
import 'package:ui_utils/ui_utils.dart';

class WeatherDay extends StatelessWidget {
  Daily daily;
  String day;
  Hourly hourly;
  List<DayDetails> Day;
  WeatherDay(this.daily, this.Day, this.day);
  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<AppLanguageModel>(context, listen: false).appLocal ==
            Locale('en');
    return Scaffold(
      body: BaseWidget<WeatherTabModel>(
        model: WeatherTabModel(day: day),
        initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
          m.getWeatherByCurrentLocation(context);
          //UI.toast(m.details.toString());
        }),
        builder: (context, model, child) {
          return model.busy
              ? buildLoadingScreen(context)
              : model.currentWeather == null
                  ? Center(child: Text('Error'))
                  : Scaffold(
                      body: Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil.screenHeightDp,
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/clear.png',
                                fit: BoxFit.cover,
                                width: ScreenUtil.screenWidthDp),
                            Column(
                              children: [
                                buildHeaderColor(context),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      children: <Widget>[
                                        // app bar.

                                        // All Cities row.
                                        buildCitiesRow(context, model),
                                        // current weather details card.
                                        buildCurrentWeather(
                                            context: context,
                                            model: model,
                                            isEnglish: isEnglish),
                                        // Weather per hour row.
                                        // Daily weather card.

                                        buildDailyWeatherCard(
                                            context,
                                            model.hourWeather,
                                            isEnglish,
                                            model),
                                        if (model.sponsor != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (await canLaunch(
                                                        model.sponsor.url) &&
                                                    model.sponsor.url != null) {
                                                  await launch(
                                                      model.sponsor.url);
                                                }
                                              },
                                              child: Text(
                                                model.sponsor.title,
                                                style: TextStyle(
                                                    color: Colors.grey[400]),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }

  // Loading Screen
  Container buildLoadingScreen(BuildContext context) {
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
  HeaderColor buildHeaderColor(BuildContext context) {
    return HeaderColor(
        hasTitle: true,
        title: AppLocalizations.of(context).get('WEATHER'),
        titleImage: 'weather_header.png');
  }

  // All Cities Row.
  Container buildCitiesRow(BuildContext context, WeatherTabModel model) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.015, horizontal: 5),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: model.cities
              .map((c) => GestureDetector(
                    onTap: () {
                      model.getWeatherByCity(context, c.cityId);
                    },
                    child: Opacity(
                      opacity: 0.65,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(23)),
                          color: model.cityDetails.cityId == c.cityId
                              ? Colors.white24
                              : Colors.white,
                        ),
                        child: Text(
                          AppLocalizations.of(context).get(c.cityName) ??
                              c.cityName,
                          style: TextStyle(
                              color: Color(0xff33336E),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // Current weather card.
  Padding buildCurrentWeather(
      {BuildContext context, WeatherTabModel model, bool isEnglish}) {
    final cities = model.cities;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 5, horizontal: ScreenUtil.screenWidthDp * 0.02),
      child: Row(
        children: <Widget>[
          // forward arrow
          _arrowWidget(
            context: context,
            icon: Icons.arrow_back_ios,
            onTab: () => model.getWeatherByCity(
                context, cities[model.currentCityIndex - 1].cityId),
          ),
          // weather card
          _currentWeatherCard(
              context: context,
              currentWeather: model.currentWeather,
              city: model.cityDetails,
              isEnglish: isEnglish),
          // backware arrow
          _arrowWidget(
            context: context,
            icon: Icons.arrow_forward_ios,
            onTab: () => model.getWeatherByCity(
                context, cities[model.currentCityIndex + 1].cityId),
          ),
        ],
      ),
    );
  }

  GestureDetector _arrowWidget(
      {BuildContext context, IconData icon, Function onTab}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(
          icon,
          size: 18.0,
          color: AppColors.primaryElement,
        ),
      ),
    );
  }

  Expanded _currentWeatherCard(
      {BuildContext context,
      Current currentWeather,
      CityDetails city,
      bool isEnglish}) {
    final locale = AppLocalizations.of(context);

    return Expanded(
      child: Opacity(
        opacity: 0.85,
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: ScreenUtil.screenWidthDp * 0.04),
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil.screenHeightDp * 0.025,
              horizontal: ScreenUtil.screenWidthDp * 0.04),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(13)),
          child: Column(
            children: <Widget>[
              // City name
              InkWell(
                onTap: () {
                  final df = new DateFormat('dd-MM-yy');
                  var date = new DateTime(daily.timestamp);
                  var day = df.format(date);

                  print(day);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/city_icon.png', height: 15),
                    SizedBox(width: 5.0),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          '${intl.DateFormat.EEEE(AppLocalizations.of(context).locale.languageCode).format(DateTime.fromMillisecondsSinceEpoch(daily.timestamp * 1000))}',
                          style: TextStyle(
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),

              // Date text.
              Text(
                '${intl.DateFormat.MMM(locale.locale.languageCode).add_jm().format(DateTime.fromMillisecondsSinceEpoch(currentWeather.time * 1000))}',
                style: TextStyle(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(height: 5),

              // Weather Icon.
              // Image.network(
              //   currentWeather,
              //   height: 20,
              //   width: 20,
              // ),
              SizedBox(height: 5),

              // Temp, humidity and wind.
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/max.png'),
                        Text(
                          '${daily.temperatureMax.split(".")[0]}°',
                          locale: locale.locale,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                              fontSize: 60),
                        ),
                      ],
                    ),
                    Container(
                      color: Color(0xffFEB82B),
                      width: 0.6,
                      height: 80,
                    ),
                    Column(
                      children: [
                        Image.asset('assets/images/min.png'),
                        Text(
                          '${daily.temperatureMin.split(".")[0]}°',
                          locale: locale.locale,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w500,
                              fontSize: 60),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              weatherStatueColumn(currentWeather, isEnglish),
              SizedBox(height: 20),

              // Weather statue message.
            ],
          ),
        ),
      ),
    );
  }

  weatherStatueColumn(Current weather, bool isEnglish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/sun.png',
                height: 20,
                width: 20,
              ),
              SizedBox(width: 3),
              Text(
                '${weather.humidity}°',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Image.asset(
              'assets/images/wind.png',
              height: 20,
              width: 20,
            ),
            SizedBox(width: 3),
            Text(
              '${weather.wind.speed}Km/h',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Montserrat',
              ),
            )
          ]),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/humuidty.png',
                height: 20,
                width: 20,
              ),
              SizedBox(width: 3),
              Text(
                '${weather.humidity}%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Weather per houre row.
  Padding buildHourlyWeatherCard(List<DayDetails> hourly) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.01,
          horizontal: ScreenUtil.screenWidthDp * 0.075),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil.screenHeightDp * 0.015,
            horizontal: ScreenUtil.screenWidthDp * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.0),
          color: const Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: const Color(0x19000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            )
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hourly
                .map(
                  (h) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.screenWidthDp * 0.015),
                    child: Column(
                      children: <Widget>[
                        // weather time.
                        Text(
                          h.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xff33336e),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Text(
                          "${h.temperature}°",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            color: AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Container(
                          width: 15,
                          height: 15,
                          child: dirctionIcon(h.wind.deg),
                        ), // weather icon.
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/wind.png',
                              width: 13,
                              height: 13,
                            ),
                            Text(
                              "${h.wind.speed}Km/h",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Montserrat',
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/humuidty.png',
                              width: 13,
                              height: 13,
                            ),
                            Text(
                              "${h.humidity}%",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Montserrat',
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // weather temp.
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Container buildDailyWeatherCard(BuildContext context, List<Hourly> hourly,
      bool isEnglish, WeatherTabModel model) {
    final locale = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.02,
          horizontal: ScreenUtil.screenWidthDp * 0.065),
      color: Colors.white,
      child: Column(
          children: Day.map((d) => Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // WeekDay
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${d.time}',
                                locale: locale.locale,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${d.temperature.split(".")[0]}°',
                                locale: locale.locale,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            // Weekday data
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'assets/images/wind.png',
                                width: 12,
                                height: 12,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${d.wind.speed}Km/h',
                                locale: locale.locale,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              child: dirctionIcon(d.wind.deg),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // Min temp
                            Image.asset('assets/images/humuidty.png'),

                            Expanded(
                              flex: 1,
                              child: Text(
                                '${d.humidity}%',
                                locale: locale.locale,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Divider(color: Colors.black),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )).toList()),
    );
  }

  dirctionIcon(dynamic number) {
    if (number >= 11.25 && number <= 33.75) {
      return Image.asset("assets/images/NNE.png");
    } else if (number >= 33.75 && number <= 56.25) {
      return Image.asset("assets/images/NE.png");
    } else if (number >= 56.25 && number <= 78.75) {
      return Image.asset("assets/images/ENE.png");
    } else if (number >= 78.75 && number <= 101.25) {
      return Image.asset("assets/images/E.png");
    } else if (number >= 101.25 && number <= 123.75) {
      return Image.asset("assets/images/ESE.png");
    } else if (number >= 123.75 && number <= 146.25) {
      return Image.asset("assets/images/SE.png");
    } else if (number >= 146.25 && number <= 168.75) {
      return Image.asset("assets/images/SSE.png");
    } else if (number >= 168.75 && number <= 191.25) {
      return Image.asset("assets/images/S.png");
    } else if (number >= 191.25 && number <= 213.75) {
      return Image.asset("assets/images/SSW.png");
    } else if (number >= 213.75 && number <= 236.25) {
      return Image.asset("assets/images/SW.png");
    } else if (number >= 236.25 && number <= 258.75) {
      return Image.asset("assets/images/WSW.png");
    } else if (number >= 258.75 && number <= 281.25) {
      return Image.asset("assets/images/W.png");
    } else if (number >= 281.25 && number <= 303.75) {
      return Image.asset("assets/images/WNW.png");
    } else if (number >= 303.75 && number <= 326.25) {
      return Image.asset("assets/images/NW.png");
    } else if (number >= 326.25 && number <= 348.75) {
      return Image.asset("assets/images/NNW.png");
    } else {
      return Image.asset("assets/images/N.png");
    }
  }
}
