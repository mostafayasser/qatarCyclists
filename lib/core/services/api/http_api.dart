import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:qatarcyclists/core/models/events.dart';
import 'package:qatarcyclists/core/models/my_events.dart';
import 'package:qatarcyclists/core/models/my_rides.dart';
import 'package:qatarcyclists/core/models/newsarticles.dart';
import 'package:qatarcyclists/core/models/cyclingtrack.dart';

import 'package:qatarcyclists/core/models/weather.dart';

import '../../../core/models/user.dart';
import '../../../core/services/auth/authentication_service.dart';
import '../localization/localization.dart';
import 'api.dart';

class HttpApi {
  Dio _dio;
  final baseUrl = 'http://35.159.52.137/api/v1/';
  static final imageBaseUrl = 'http://35.159.52.137';

  HttpApi(BuildContext context) {
    setupDio();
  }

  setupDio() =>
      _dio = Dio(BaseOptions(connectTimeout: 15000, receiveTimeout: 15000));

  Future<dynamic> request(String url,
      {dynamic body,
      BuildContext context,
      Function onSendProgress,
      Map<String, dynamic> headers,
      String type = RequestType.Get,
      Map<String, dynamic> queryParameters,
      String contentType = Headers.jsonContentType,
      ResponseType responseType = ResponseType.json}) async {
    Response response;
    final options = Options(
        headers: headers, contentType: contentType, responseType: responseType);

    if (onSendProgress == null) {
      onSendProgress = (int sent, int total) {
        // print('$url\n sent: $sent total: $total\n');
      };
    }

    Logger().i('🍉request $baseUrl$url');

    try {
      switch (type) {
        case RequestType.Get:
          {
            response = await _dio.get(baseUrl + url,
                queryParameters: queryParameters, options: options);
          }
          break;
        case RequestType.Post:
          {
            response = await _dio.post(baseUrl + url,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                data: body,
                options: options);
          }
          break;
        case RequestType.Put:
          {
            response = await _dio.put(baseUrl + url,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        case RequestType.Delete:
          {
            response = await _dio.delete(baseUrl + url,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        default:
          break;
      }
      if (response.statusCode == 200) {
        /// 🦄map of string dynamic...
        return response.data;
      } else {
        Logger().e('🌐🌐ERROR in http $type for $url:🌐🌐\n' +
            '${response.statusCode}: ${response.statusMessage} ${response.data}');

        return response.data;
        // await checkSessionExpired(context: context, response: response);
      }
    } on DioError catch (e) {
      Logger().e('🌐🌐DIO ERROR in http $type for $url:🌐🌐\n' +
          '${e.response.statusCode}: ${e.response.statusMessage} ${e.response.data}\n' +
          e.toString());
      // await checkSessionExpired(context: context, response: e.response);
      return e.response.data;
    }
  }

  checkSessionExpired({Response response, BuildContext context}) async {
    if (context != null &&
        (response.statusCode == 401 || response.statusCode == 500)) {
      final expiredMsg = response.data['error'];
      final authExpired =
          expiredMsg != null && expiredMsg == 'unauthorized user';

      if (authExpired) {
        await AuthenticationService.handleAuthExpired(context: context);
      }
    }
  }

  Future<User> signUp(
      {String fullName, String email, String mobile, String password}) async {
    final body = {
      "name": fullName,
      "email": email,
      "password": password,
      'mobile': mobile
    };
    try {
      final responseData = await request(
        EndPoint.REGISTER,
        type: RequestType.Post,
        body: body,
        contentType: Headers.formUrlEncodedContentType,
      );
      // Returned user from response

      if (responseData != null &&
          responseData['Response']['result']['user'] != null) {
        return User.fromJson(responseData['Response']['result']['user']);
      }
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<User> signIn(
      {@required String email, @required String password}) async {
    final body = {"email": email, "password": password};
    try {
      final responseData = await request(
        EndPoint.LOGIN,
        type: RequestType.Post,
        body: body,
        contentType: Headers.formUrlEncodedContentType,
      );
      if (responseData != null &&
          responseData['Response']['result']['user'] != null) {
        return User.fromJson(responseData['Response']['result']['user']);
      }
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  forgotPassword({@required String email}) async {
    final body = {"email": email};
    try {
      final responseData = await request(
        EndPoint.FORGOTPASSWORD,
        type: RequestType.Post,
        body: body,
        contentType: Headers.jsonContentType,
      );
      if (responseData != null && responseData['Response'] != null) {
        return responseData['Response']['status'];
      }
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  updateUserFcm({String fcmToken, context}) async {
    final body = {
      "device_token": fcmToken,
      "version": 2.0,
      "os_type": Platform.isIOS ? "ios" : "android",
    };
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});

    try {
      final responseData = await request(
        EndPoint.UPDATEFCMTOKEN,
        type: RequestType.Post,
        body: body,
        headers: header,
        contentType: Headers.jsonContentType,
      );
      if (responseData != null) {
        print(responseData);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  refreshToken() {}

  sendNotification({
    @required String chatId,
    @required bool group,
    List<String> tokens,
    @required String body,
    @required String title,
  }) async {
    tokens.removeWhere((o) => o == null);
    print(tokens);

    if (tokens.isEmpty) return;

    final reqBody = {
      "notification": {
        "title": title,
        "body": body,
        "name": "qatar cyclists",
        "image": "https://i.ibb.co/yyZgt0B/logo.png"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "chatId": chatId,
        "title": title,
        "body": body,
        "group": group
      },
      "registration_ids": tokens
    };

    try {
      final response = await _dio.post("https://fcm.googleapis.com/fcm/send",
          data: reqBody,
          options: Options(
            headers: Header.fcmKey,
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType,
          ));

      if (response != null && response.data != null) {
        print(response.data);
      }
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<User> updateUserProfileInfo({
    @required String fullName,
    @required String email,
    @required String mobile,
    String password,
  }) async {
    final body = {"name": fullName, "email": email, "mobile": mobile};
    if (password != null) {
      body["password"] = password;
    }

    try {
      final responseData = await request(
        EndPoint.UpdateProfile,
        type: RequestType.Post,
        body: body,
        contentType: Headers.formUrlEncodedContentType,
        headers: Header.userAuth,
      );

      if (responseData != null && responseData['Response']['result'] != null) {
        print(responseData['Response']['result']);
        if (password != null) {
          //   FireAuthService.changePassword(password);
        }
        return User.fromJson(responseData['Response']['result']);
      }
      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<User> updateProfileImage({File image}) async {
    final formData = FormData.fromMap({
      "type": "update",
      "image": await MultipartFile.fromFile(image.path, filename: "profile.png")
    });

    try {
      final responseData = await request(
        EndPoint.UpdateProfileImage,
        type: RequestType.Post,
        body: formData,
        contentType: Headers.formUrlEncodedContentType,
        headers: Header.userAuth,
      );
      Logger().e(responseData);
      if (responseData != null && responseData['Response']['result'] != null) {
        return User.fromJson(responseData['Response']['result']);
      }

      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<Weather> getWeatherByCurrentLocation(
      {@required double longitude, @required double latitude}) async {
    final body = {"lat": latitude, "long": longitude};
    try {
      final responseData = await request(
        EndPoint.CurrentLocation,
        type: RequestType.Post,
        body: body,
        contentType: Headers.formUrlEncodedContentType,
      );
      if (responseData != null && responseData['Response']['result'] != null) {
        Logger().i(responseData['Response']['result']);
        return Weather.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<Weather> getWeatherByCity({@required int cityId}) async {
    final body = {"city_id": cityId};
    try {
      final responseData = await request(
        EndPoint.CurrentCity,
        type: RequestType.Post,
        body: body,
        contentType: Headers.formUrlEncodedContentType,
      );
      if (responseData != null && responseData['Response']['result'] != null) {
        Logger().i(responseData['Response']['result']);
        return Weather.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<MyRides> getMyRides(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});
    try {
      final responseData = await request(
        EndPoint.MYRIDES,
        type: RequestType.Post,
        headers: header,
        contentType: Headers.formUrlEncodedContentType,
      );

      if (responseData != null && responseData['Response']['result'] != null) {
        return MyRides.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<MyEventsTrainings> getMyEventsTrainigns(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});

    try {
      final responseData = await request(
        EndPoint.MYEVENTSTRAININGS,
        type: RequestType.Post,
        headers: header,
        contentType: Headers.formUrlEncodedContentType,
      );
      if (responseData != null && responseData['Response']['result'] != null) {
        return MyEventsTrainings.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<EventsAll> getEventsAll(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});

    try {
      final responseData = await request(
        EndPoint.EVENTSALL,
        type: RequestType.Post,
        headers: header,
        contentType: Headers.formUrlEncodedContentType,
      );

      if (responseData != null && responseData['Response']['result'] != null) {
        return EventsAll.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<NewsArticlesModel> getNewsArticles(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});
    try {
      final responseData = await request(
        EndPoint.NEWSARTICLES,
        type: RequestType.Get,
        headers: header,
      );

      if (responseData != null && responseData != null) {
        return NewsArticlesModel.fromJson(responseData);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<CyclingTrackModel> getCycleTracks(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});
    try {
      final responseData = await request(
        EndPoint.CYCLETRACKS,
        type: RequestType.Get,
        headers: header,
      );

      if (responseData != null && responseData != null) {
        return CyclingTrackModel.fromJson(responseData);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<MyRides> getRegistredRides(context) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});
    try {
      final responseData = await request(
        EndPoint.USERRIDES,
        type: RequestType.Get,
        headers: header,
        contentType: Headers.formUrlEncodedContentType,
      );

      if (responseData != null && responseData['Response']['result'] != null) {
        return MyRides.fromJson(responseData['Response']['result']);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<List<EventData>> getCategoryEvents(context,
      {Categories category}) async {
    final locale = AppLocalizations.of(context);
    var header = Header.userAuth;
    header.addAll({"language": locale.locale.languageCode});
    print(header);
    try {
      final responseData = await request(EndPoint.EVENTSALL,
          type: RequestType.Post,
          headers: header,
          body: {"filter": category.key},
          contentType: Headers.formUrlEncodedContentType);

      Logger().i(responseData);

      if (responseData != null &&
          responseData['Response']['result']['events'][category.key] != null) {
        var data = List<EventData>();
        responseData['Response']['result']['events'][category.key]['data']
            .forEach((v) {
          data.add(EventData.fromJson(v));
        });
        return data;
      } else {
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<bool> registerEvent(
      {String email, String mobile, String name, int eventId}) async {
    final Map<String, dynamic> body = {
      'email': email,
      'mobile': mobile,
      'name': name,
      'event': eventId
    };

    try {
      final responseData = await request(EndPoint.EVENTREGISTER,
          type: RequestType.Post,
          headers: Header.userAuth,
          body: body,
          contentType: Headers.formUrlEncodedContentType);

      try {
        if (responseData != null &&
            responseData['Response']['result']['registered'] != null) {
          return true;
        }
      } catch (e) {}

      try {
        if (responseData != null &&
            responseData['Response']['message'] == 'Already registered') {
          return false;
        }
      } catch (e) {}

      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<bool> joinRide(
      {String email, String mobile, String name, int eventId}) async {
    final Map<String, dynamic> body = {
      'email': email,
      'mobile': mobile,
      'name': name,
      'ride': eventId
    };

    try {
      final responseData = await request(EndPoint.JOINRIDE,
          type: RequestType.Post,
          headers: Header.userAuth,
          body: body,
          contentType: Headers.formUrlEncodedContentType);

      try {
        if (responseData != null &&
            responseData['Response']['status'] == true) {
          return true;
        }
      } catch (e) {}

      try {
        print("responseeeeeee: $responseData");
        if (responseData != null &&
            responseData['Response']['message'] == 'Already registered') {
          return false;
        }
      } catch (e) {}

      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<bool> createUserRide(
      {String title,
      String description,
      String date,
      String venue,
      LatLng latLng}) async {
    final Map<String, dynamic> body = {
      'title': title,
      'venue': venue,
      'ride_date': date,
      'lat': latLng.latitude,
      'long': latLng.longitude,
      'description': description,
    };

    try {
      final responseData = await request(EndPoint.USERRIDES,
          type: RequestType.Post,
          headers: Header.userAuth,
          body: body,
          contentType: Headers.formUrlEncodedContentType);

      if (responseData != null &&
          responseData['Response']['result']['id'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  registerTraining(
      {int trainingId,
      String email,
      String mobile,
      String name,
      bool needCycle,
      String gender,
      String height}) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'height': height,
      'mobile': mobile,
      'training': trainingId,
      'cycle_need': needCycle ? 1 : 0,
      'gender': gender
    };

    try {
      final responseData = await request(EndPoint.TrainingREGISTER,
          type: RequestType.Post,
          headers: Header.userAuth,
          body: body,
          contentType: Headers.formUrlEncodedContentType);

      try {
        if (responseData != null &&
            responseData['Response']['result']['training']['id'] != null) {
          return true;
        }
      } catch (e) {}

      try {
        if (responseData != null &&
            responseData['Response']['message'] == 'Already registered') {
          return false;
        }
      } catch (e) {}

      return null;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }
}
