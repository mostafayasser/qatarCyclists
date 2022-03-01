import 'package:qatarcyclists/core/models/my_rides.dart';

class MyEventsTrainings {
  Events events;
  Events trainings;

  MyEventsTrainings({this.events, this.trainings});

  MyEventsTrainings.fromJson(Map<String, dynamic> json) {
    events = json['events'] != null ? new Events.fromJson(json['events']) : null;
    trainings = json['trainings'] != null ? new Events.fromJson(json['trainings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events.toJson();
    }
    if (this.trainings != null) {
      data['trainings'] = this.trainings.toJson();
    }
    return data;
  }
}

class Events {
  List<EventData> data;
  int total;
  int currentPage;
  int perPage;
  int totalPages;

  Events({this.data, this.total, this.currentPage, this.perPage, this.totalPages});

  Events.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<EventData>();
      json['data'].forEach((v) {
        data.add(new EventData.fromJson(v));
      });
    }
    total = json['total'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['total_pages'] = this.totalPages;
    return data;
  }
}
