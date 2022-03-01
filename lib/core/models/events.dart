import 'package:qatarcyclists/core/models/my_rides.dart';

class EventsAll {
  Events events;
  Sponsor sponsor;

  EventsAll({this.events, this.sponsor});

  EventsAll.fromJson(Map<String, dynamic> json) {
    events =
        json['events'] != null ? new Events.fromJson(json['events']) : null;
    sponsor =
        json['sponsor'] != null ? new Sponsor.fromJson(json['sponsor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events.toJson();
    }
    if (this.sponsor != null) {
      data['sponsor'] = this.sponsor.toJson();
    }
    return data;
  }
}

class Events {
  FeaturedEvents featuredEvents;
  List<Categories> categories;

  Events({this.featuredEvents, this.categories});

  Events.fromJson(Map<String, dynamic> json) {
    featuredEvents = json['featured_events'] != null
        ? new FeaturedEvents.fromJson(json['featured_events'])
        : null;
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.featuredEvents != null) {
      data['featured_events'] = this.featuredEvents.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeaturedEvents {
  List<EventData> data;
  int total;
  int currentPage;
  int perPage;
  int totalPages;

  FeaturedEvents(
      {this.data, this.total, this.currentPage, this.perPage, this.totalPages});

  FeaturedEvents.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<EventData>();
      print(json['data'][0]['id']);

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

class Categories {
  String key;
  String title;

  Categories({this.key, this.title});

  Categories.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['title'] = this.title;
    return data;
  }
}

class Sponsor {
  int id;
  String title;
  String page;
  int status;
  String description;
  String url;
  String createdAt;
  int createdBy;
  List<Media> media;

  Sponsor(
      {this.id,
      this.title,
      this.page,
      this.status,
      this.description,
      this.url,
      this.createdAt,
      this.createdBy,
      this.media});

  Sponsor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    page = json['page'];
    status = json['status'];
    description = json['description'];
    url = json['url'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    media = new List<Media>();
    media.add(Media.fromJson(json['media']));
    /*  if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    } */
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['page'] = this.page;
    data['status'] = this.status;
    data['description'] = this.description;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
