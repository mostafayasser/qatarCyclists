import 'my_rides.dart';

class TrainingModel {
  int id;
  String startDate;
  String endTime;
  int trainingId;
  String title;
  String venue;
  String lat;
  String long;
  String slug;
  String shareUrl;
  String description;
  int status;
  int register;
  int registrationsCount;
  String type;
  Media media;

  TrainingModel(
      {this.id,
      this.startDate,
      this.endTime,
      this.trainingId,
      this.title,
      this.venue,
      this.lat,
      this.long,
      this.slug,
      this.shareUrl,
      this.description,
      this.status,
      this.register,
      this.registrationsCount,
      this.type,
      this.media});

  TrainingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endTime = json['end_time'];
    trainingId = json['training_id'];
    title = json['title'];
    venue = json['venue'];
    lat = json['lat'];
    long = json['long'];
    slug = json['slug'];
    shareUrl = json['share_url'];
    description = json['description'];
    status = json['status'];
    register = json['register'];
    registrationsCount = json['registrations_count'];
    type = json['type'];
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_date'] = this.startDate;
    data['end_time'] = this.endTime;
    data['training_id'] = this.trainingId;
    data['title'] = this.title;
    data['venue'] = this.venue;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['slug'] = this.slug;
    data['share_url'] = this.shareUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    data['register'] = this.register;
    data['registrations_count'] = this.registrationsCount;
    data['type'] = this.type;
    if (this.media != null) {
      data['media'] = this.media.toJson();
    }
    return data;
  }
}
