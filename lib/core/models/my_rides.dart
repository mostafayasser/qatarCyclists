class MyRides {
  Rides myRides;
  Rides hostedRides;

  MyRides({this.myRides, this.hostedRides});

  MyRides.fromJson(Map<String, dynamic> json) {
    myRides =
        json['my_rides'] != null ? Rides.fromJson(json['my_rides']) : Rides();
    hostedRides = json['hosted_rides'] != null
        ? Rides.fromJson(json['hosted_rides'])
        : Rides();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.myRides != null) {
      data['my_rides'] = this.myRides.toJson();
    }
    if (this.hostedRides != null) {
      data['hosted_rides'] = this.hostedRides.toJson();
    }
    return data;
  }
}

class Rides {
  List<EventData> data = [];
  int total;
  int currentPage;
  int perPage;
  int totalPages;

  Rides(
      {this.data, this.total, this.currentPage, this.perPage, this.totalPages});

  Rides.fromJson(Map<String, dynamic> json) {
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

class EventData {
  String title;
  int id;
  int register;
  int cost;
  int registrationsCount;
  int freePaid;
  int trainingId;
  String startDate;
  String endDate;
  String venue;
  String lat;
  String long;
  String slug;
  String shareUrl;
  String description;
  int status;
  String createdAt;
  List<Registrations> registrations;
  String type;
  Owner owner;
  Media media;

  EventData(
      {this.title,
      this.id,
      this.cost,
      this.trainingId,
      this.registrationsCount,
      this.register,
      this.startDate,
      this.freePaid,
      this.endDate,
      this.venue,
      this.lat,
      this.long,
      this.slug,
      this.shareUrl,
      this.description,
      this.status,
      this.createdAt,
      this.registrations,
      this.type,
      this.owner,
      this.media});

  EventData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    trainingId = json['training_id'] != null ? json['training_id'] : 0;
    startDate = json['start_date'];
    endDate = json['end_date'];
    venue = json['venue'];
    register = json['register'];
    cost = json['cost'];
    registrationsCount = json['registrations_count'];
    freePaid = json['free_paid'];
    lat = json['lat'];
    long = json['long'];
    slug = json['slug'];
    shareUrl = json['share_url'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['registrations'] != null) {
      registrations = new List<Registrations>();
      json['registrations'].forEach((v) {
        registrations.add(Registrations.fromJson(v));
      });
    }
    type = json['type'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    if (json['media'] is List && json['media'] != null) {
      media = new Media.fromJson(json['media'][0]);
    } else if (json['media'] != null) {
      media = new Media.fromJson(json['media']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    // ignore: unnecessary_statements
    data['training_id'] != null ? data['training_id'] = this.trainingId : null;
    data['start_date'] = this.startDate;
    data['free_paid'] = this.freePaid;
    data['end_date'] = this.endDate;
    data['registrations_count'] = this.registrationsCount;
    data['venue'] = this.venue;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['slug'] = this.slug;
    data['share_url'] = this.shareUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    data['register'] = this.register;
    data['created_at'] = this.createdAt;
    if (this.registrations != null) {
      data['registrations'] =
          this.registrations.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media.toJson();
    }
    return data;
  }
}

class Registrations {
  int id;
  int rideId;
  int user;
  String name;
  String email;
  String mobile;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  Registrations(
      {this.id,
      this.rideId,
      this.user,
      this.name,
      this.email,
      this.mobile,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Registrations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rideId = json['ride_id'];
    user = json['user'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ride_id'] = this.rideId;
    data['user'] = this.user;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Owner {
  String id;
  String name;

  Owner({this.id, this.name});

  Owner.fromJson(Map<String, dynamic> json) {
    id = (json['id'] is int) ? "${json['id']}" : json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Media {
  String url;
  String name;

  Media({this.url, this.name});

  Media.fromJson(Map<String, dynamic> json) {
    print(json);
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['name'] = this.name;
    return data;
  }
}
