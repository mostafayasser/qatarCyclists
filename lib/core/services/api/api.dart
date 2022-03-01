import '../../../core/services/preference/preference.dart';

class RequestType {
  static const String Get = 'get';
  static const String Post = 'post';
  static const String Put = 'put';
  static const String Delete = 'delete';
}

class Header {
  static Map<String, dynamic> get fcmKey => {
        "Authorization":
            "key=AAAA54-hrqU:APA91bFl78p-KCKJC6-fe4rjMabS9pj3e_mp7guYFcu4IgN54hNvFeINBkKVF7NT2Pzzh7Gpks8QLp2stIKkZab15zXzMLABIQfGO2k4LlWTsJb9E9GzENJhH-ZW9Jhlsu_OnFg0RMGg"
      };
  static Map<String, dynamic> get userAuth =>
      {'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}'};
}

class EndPoint {
  static const String REGISTER = 'register';
  static const String LOGIN = 'login';
  static const String FORGOTPASSWORD = 'forgot-password';
  static const String MYRIDES = 'my-rides';
  static const String MYEVENTSTRAININGS = 'my-events-trainings';
  static const String EVENTREGISTER = 'events/register';
  static const String TrainingREGISTER = 'trainings/register';
  static const String JOINRIDE = "user-rides/register";
  static const String USERRIDES = 'user-rides';
  static const String EVENTSALL = 'events';
  static const String NEWSARTICLES = 'news-articles';
  static const String CYCLETRACKS = 'cycle-tracks';

  static const String UpdateProfile = 'update-profile';
  static const String UpdateProfileImage = 'update-profile-image';
  static const String TOKEN = 'auth/token';
  static const String FCMTOKEN = 'fcmToken';
  static const String UPDATEFCMTOKEN = 'update-device';
  static const String CurrentLocation = 'weather/current-location';
  static const String CurrentCity = 'weather/current-city';
  static const String USER = 'user';
  static const String USERNOTIFICATION = 'userNotification';
  static const String PermessionGroup = 'permessionGroup';
  static const String APPSETTINGS = 'appsettings';
  static const String POST = 'post';
  static const String COMMENT = 'comment';
  static const String REPLY = 'reply';
  static const String WorkStage = 'workStage';
  static const String NewCustomer = 'newCustomer';
  static const String WorkStageFile = 'workStageFile';
  static const String ProjectCategory = 'projectCategory';
  static const String Project = 'project';
  static const String ProjectReport = 'projectReport';
  static const String Projectfile = 'projectfile';
  static const String ProjectWorkStage = 'projectWorkStage';
  static const String ProjectWorkStagefile = 'projectWorkStageFile';
  static const String ProjectEngineers = 'projectEngineer';
  static const String UserRating = 'userRating';
  static const String ProjectAttendance = 'projectAttendance';
  static const String SuggestionAndCompliant = 'suggestionAndCompliant';
  static const String PURCHASED = 'purchaseRequest';
  static const String FINANCE = 'projectFinances';
}
