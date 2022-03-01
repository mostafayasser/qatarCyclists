import 'package:base_notifier/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/ui/widgets/dialog.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../models/weather.dart';
import '../../services/api/http_api.dart';
import '../../services/localization/localization.dart';

class WeatherTabModel extends BaseNotifier {
  Weather _weather;
  String day;
  List<DayDetails> _hourlyWeather = [];

  WeatherTabModel({this.day});
  Current get currentWeather => _weather?.current;
  CityDetails get cityDetails => _weather?.cityDetails;
  List<Daily> get dailyWeather => _weather?.daily;
  List<Cities> get cities => _weather?.cities;
  Sponsor get sponsor => _weather?.sponsor;

  // Merge two date hourly-list into one list<DayDetails>.
  List<DayDetails> get hourlyWeather {
    _hourlyWeather.clear();
    _weather.hourly.forEach((date) {
      date.dayDetails.forEach((d) => _hourlyWeather.add(d));
    });
    return _hourlyWeather;
  }

  List<Hourly> get hourWeather {
    return _weather.hourly;
  }

  List<DayDetails> details;

  hourWeathertest({String dayy}) {
    setBusy();
    _weather.hourly.forEach((element) {
      if (element.date == dayy) {
        details = element.dayDetails;
        return;
      }
    });
    setIdle();
    // return _we?ather.hourly;
  }

  /// Current City index
  int get currentCityIndex =>
      cities.indexWhere((c) => c.cityId == cityDetails.cityId);

  /// Get Weather by current location
  Future<void> getWeatherByCurrentLocation(BuildContext context) async {
    final api = Provider.of<HttpApi>(context, listen: false);
    final local = AppLocalizations.of(context);

    setBusy();
    // get current location
    final currentPosition = await getCurrentLocation();
    if (currentPosition == null) {
      setIdle();

      CustomDialog(title: local.get('failed'), msg: "Can't get your location");
      return;
    }

    final fetchedWeather = await api.getWeatherByCurrentLocation(
        longitude: currentPosition.longitude,
        latitude: currentPosition.latitude);
    if (fetchedWeather == null) {
      CustomDialog(title: local.get('failed'), msg: '');
      setIdle();

      return;
    } else {
      _weather = fetchedWeather;
    }
    setIdle();
  }

  // Get weather by city id.
  Future<void> getWeatherByCity(BuildContext context, int cityId) async {
    final api = Provider.of<HttpApi>(context, listen: false);
    final local = AppLocalizations.of(context);

    setBusy();

    final fetchedWeather = await api.getWeatherByCity(cityId: cityId);
    if (fetchedWeather == null) {
      CustomDialog(title: local.get('failed'), msg: '');
      setIdle();

      return;
    } else {
      _weather.cityDetails = fetchedWeather.cityDetails;
      _weather.current = fetchedWeather.current;
      _weather.hourly = fetchedWeather.hourly;
      _weather.daily = fetchedWeather.daily;
      setState();
    }
    setIdle();
  }

  /// Try to Get current location.
  /// If success return location.
  /// If fail return null.
  Future<Position> getCurrentLocation() async {
    try {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      print(position.longitude);
      return position;
    } catch (e) {
      Logger().e(e);
      return Position(latitude: 25.2854, longitude: 51.531);
    }
  }
}
