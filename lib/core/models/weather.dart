import 'package:qatarcyclists/core/models/events.dart';

class Weather {
  Current current;
  CityDetails cityDetails;
  List<Hourly> hourly;
  List<Daily> daily;
  List<Cities> cities;
  Sponsor sponsor;

  Weather(
      {this.current,
      this.cityDetails,
      this.hourly,
      this.daily,
      this.cities,
      this.sponsor});

  Weather.fromJson(Map<String, dynamic> json) {
    try {
      sponsor = json['sponsor'] != null
          ? new Sponsor.fromJson(json['sponsor'])
          : null;
      current = json['current'] != null
          ? new Current.fromJson(json['current'])
          : null;
      cityDetails = json['city_details'] != null
          ? new CityDetails.fromJson(json['city_details'])
          : null;
      if (json['hourly'] != null) {
        hourly = new List<Hourly>();
        json['hourly'].forEach((v) {
          hourly.add(new Hourly.fromJson(v));
        });
      }
      if (json['daily'] != null) {
        daily = new List<Daily>();
        json['daily'].forEach((v) {
          daily.add(new Daily.fromJson(v));
        });
      }
      if (json['cities'] != null) {
        cities = new List<Cities>();
        json['cities'].forEach((v) {
          cities.add(new Cities.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.cityDetails != null) {
      data['city_details'] = this.cityDetails.toJson();
    }
    if (this.hourly != null) {
      data['hourly'] = this.hourly.map((v) => v.toJson()).toList();
    }
    if (this.daily != null) {
      data['daily'] = this.daily.map((v) => v.toJson()).toList();
    }
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  int time;
  String temperature;
  String weatherType;
  String weatherTypeAr;
  String weatherIcon;
  String humidity;
  Wind wind;
  dynamic visibility;
  String sunrise;
  String sunset;
  dynamic uvIndex;

  Current(
      {this.time,
      this.temperature,
      this.weatherType,
      this.weatherTypeAr,
      this.weatherIcon,
      this.humidity,
      this.wind,
      this.visibility,
      this.sunrise,
      this.sunset,
      this.uvIndex});

  Current.fromJson(Map<String, dynamic> json) {
    try {
      time = json['time'];
      temperature = json['temperature'].toString();
      weatherType = json['weather_type'];
      weatherTypeAr = json['weather_type_ar'];
      weatherIcon = json['weather_icon'];
      humidity = json['humidity'].toString();
      wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
      visibility = json['visibility'];
      sunrise = json['sunrise'].toString();
      sunset = json['sunset'].toString();
      uvIndex = json['uv_index'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature'] = this.temperature;
    data['weather_type'] = this.weatherType;
    data['weather_type_ar'] = this.weatherTypeAr;
    data['weather_icon'] = this.weatherIcon;
    data['humidity'] = this.humidity;
    if (this.wind != null) {
      data['wind'] = this.wind.toJson();
    }
    data['visibility'] = this.visibility;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['uv_index'] = this.uvIndex;
    return data;
  }
}

class Wind {
  dynamic speed;
  dynamic deg;

  Wind({this.speed, this.deg});

  Wind.fromJson(Map<String, dynamic> json) {
    try {
      speed = json['speed'];
      deg = json['deg'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speed'] = this.speed;
    data['deg'] = this.deg;
    return data;
  }
}

class CityDetails {
  int cityId;
  String nameEn;
  String nameAr;
  String country;
  double latitude;
  double longitude;
  dynamic utcOffset;

  CityDetails(
      {this.cityId,
      this.nameEn,
      this.nameAr,
      this.country,
      this.latitude,
      this.longitude,
      this.utcOffset});

  CityDetails.fromJson(Map<String, dynamic> json) {
    try {
      cityId = json['city_id'];
      nameEn = json['name_en'];
      nameAr = json['name_ar'];
      country = json['country'];
      latitude = json['latitude'];
      longitude = json['longitude'];
      utcOffset = json['utc_offset'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['name_en'] = this.nameEn;
    data['name_ar'] = this.nameAr;
    data['country'] = this.country;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['utc_offset'] = this.utcOffset;
    return data;
  }
}

class Hourly {
  String date;
  List<DayDetails> dayDetails;

  Hourly({this.date, this.dayDetails});

  Hourly.fromJson(Map<String, dynamic> json) {
    try {
      date = json['date'];
      if (json['day_details'] != null) {
        dayDetails = new List<DayDetails>();
        json['day_details'].forEach((v) {
          dayDetails.add(new DayDetails.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.dayDetails != null) {
      data['day_details'] = this.dayDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DayDetails {
  String time;
  String temperature;
  String humidity;
  String weatherType;
  String weatherTypeAr;
  String weatherIcon;
  int timestamp;
  String timeHrUtc;
  Wind wind;

  DayDetails(
      {this.time,
      this.temperature,
      this.humidity,
      this.weatherType,
      this.weatherTypeAr,
      this.weatherIcon,
      this.timestamp,
      this.timeHrUtc,
      this.wind});

  DayDetails.fromJson(Map<String, dynamic> json) {
    try {
      time = json['time'];
      temperature = json['temperature'].toString();
      humidity = json['humidity'].toString();
      weatherType = json['weather_type'];
      weatherTypeAr = json['weather_type_ar'];
      weatherIcon = json['weather_icon'];
      timestamp = json['timestamp'];
      timeHrUtc = json['time_hr_utc'];
      wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['weather_type'] = this.weatherType;
    data['weather_type_ar'] = this.weatherTypeAr;
    data['weather_icon'] = this.weatherIcon;
    data['timestamp'] = this.timestamp;
    data['time_hr_utc'] = this.timeHrUtc;
    if (this.wind != null) {
      data['wind'] = this.wind.toJson();
    }
    return data;
  }
}

class Daily {
  String temperature;
  String temperatureMin;
  String temperatureMax;
  String humidity;
  String weatherType;
  String weatherTypeAr;
  String weatherIcon;
  int timestamp;
  String timeHrQatar;

  Daily(
      {this.temperature,
      this.temperatureMin,
      this.temperatureMax,
      this.humidity,
      this.weatherType,
      this.weatherTypeAr,
      this.weatherIcon,
      this.timestamp,
      this.timeHrQatar});

  Daily.fromJson(Map<String, dynamic> json) {
    try {
      temperature = json['temperature'].toString();
      temperatureMin = json['temperature_min'].toString();
      temperatureMax = json['temperature_max'].toString();
      humidity = json['humidity'].toString();
      weatherType = json['weather_type'];
      weatherTypeAr = json['weather_type_ar'];
      weatherIcon = json['weather_icon'];
      timestamp = json['timestamp'];
      timeHrQatar = json['time_hr_qatar'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['temperature_min'] = this.temperatureMin;
    data['temperature_max'] = this.temperatureMax;
    data['humidity'] = this.humidity;
    data['weather_type'] = this.weatherType;
    data['weather_type_ar'] = this.weatherTypeAr;
    data['weather_icon'] = this.weatherIcon;
    data['timestamp'] = this.timestamp;
    data['time_hr_qatar'] = this.timeHrQatar;
    return data;
  }
}

class Cities {
  int id;
  int cityId;
  String cityName;

  Cities({this.id, this.cityId, this.cityName});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    return data;
  }
}
