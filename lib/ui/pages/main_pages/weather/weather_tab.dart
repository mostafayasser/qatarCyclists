import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/services/localization/localization.dart';
import 'package:qatarcyclists/ui/pages/main_pages/weather/weather_day.dart';
import 'package:qatarcyclists/ui/routes/routes.dart';
import 'package:qatarcyclists/ui/styles/colors.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/weather.dart';
import '../../../../core/page_models/main_pages_models/weather_tab_model.dart';
import '../../../widgets/header_color.dart';

class WeatherTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<AppLanguageModel>(context, listen: false).appLocal ==
            Locale('en');
    return BaseWidget<WeatherTabModel>(
      model: WeatherTabModel(),
      initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) {
        m.getWeatherByCurrentLocation(context);
        m.hourWeathertest();
      }),
      builder: (context, model, child) {
        return model.busy
            ? buildLoadingScreen(context)
            : model.currentWeather == null
                ? Center(child: Text('Error'))
                : Container(
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil.screenHeightDp,
                    child: Stack(
                      children: <Widget>[
                        Image.asset('assets/images/clear.png',
                            fit: BoxFit.cover, width: ScreenUtil.screenWidthDp),
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
                                    buildHourlyWeatherCard(model.hourlyWeather),
                                    // Daily weather card.
                                    buildDailyWeatherCard(
                                        context,
                                        model.dailyWeather,
                                        model.hourWeather,
                                        isEnglish,
                                        model.hourlyWeather,
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
                                              await launch(model.sponsor.url);
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
                  );
      },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/city_icon.png', height: 15),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        isEnglish ? city.nameEn : city.nameAr,
                        style: TextStyle(
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),

              // Date text.
              Text(
                '${intl.DateFormat.MMMEd(locale.locale.languageCode).add_jm().format(DateTime.fromMillisecondsSinceEpoch(currentWeather.time * 1000))}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  // color: const Color(0xff788293),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),

              // Weather Icon.
              // Image.network(
              //   currentWeather,
              //   height: 20,
              //   width: 20,
              // ),
              Icon(Icons.cloud_queue),
              SizedBox(height: 5),

              // Temp, humidity and wind.
              Container(
                width: double.infinity,
                child: Column(
                  // alignment: Alignment.center,
                  // overflow: Overflow.visible,
                  children: <Widget>[
                    Text(
                      '${currentWeather.temperature.split(".")[0]}°',
                      locale: locale.locale,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 60),
                    ),
                  ],
                ),
              ),
              weatherStatueColumn(currentWeather, isEnglish),
              SizedBox(height: 20),

              // Weather statue message.
              Text(
                locale.get('Weather condition for cycling:') ??
                    'Weather condition for cycling:',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: const Color(0xff788293),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isEnglish
                    ? currentWeather.weatherType
                    : currentWeather.weatherTypeAr,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    color: Colors.green),
              )
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

  Container buildDailyWeatherCard(
      BuildContext context,
      List<Daily> daily,
      List<Hourly> hourly,
      bool isEnglish,
      List<DayDetails> Days,
      WeatherTabModel model) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil.screenHeightDp * 0.02,
          horizontal: ScreenUtil.screenWidthDp * 0.065),
      color: Colors.white,
      child: Column(
          children: daily
              .map((d) => Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          final df = new DateFormat('dd-MM-yy');
                          int y = d.timestamp * 1000;

                          DateTime date =
                              DateTime.fromMillisecondsSinceEpoch(y);

                          var day = df.format(date);
                          model.hourWeathertest(dayy: day);

                          if (model.details != null) {
                            UI.push(context, WeatherDay(d, Days, day));
                          } else {}
                          // final dayDetails = hourly
                          //     .where((element) => element.date == day)
                          //     .first
                          //     .dayDetails;

                          // print(dayDetails);
                        },
                        child: Container(
                          child: Row(children: <Widget>[
                            // WeekDay
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${intl.DateFormat.EEEE(AppLocalizations.of(context).locale.languageCode).format(DateTime.fromMillisecondsSinceEpoch(d.timestamp * 1000))}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Montserrat',
                                  color: const Color(0xff788293),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),

                            // Weekday data
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    // icon
                                    Image.network(
                                      d.weatherIcon,
                                      width: 20,
                                      height: 20,
                                    ),

                                    Expanded(
                                      flex: 3,
                                      child: Icon(
                                        Icons.cloud_queue,
                                        size: 20,
                                      ),
                                    ),

                                    // Min temp
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${d.temperatureMin.split(".")[0]}°',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          color: const Color(0xff788293),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Max temp
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${d.temperatureMax.split(".")[0]}°',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                          color: const Color(0xffb4bac4),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Statue
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        isEnglish
                                            ? d.weatherType
                                            : d.weatherTypeAr,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                          color: const Color(0xff32cd2f),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                      Divider(color: Colors.black),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ))
              .toList()),
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
