class UserModel {
  String? status;
  Payload? payload;
  String? timestamp;

  UserModel({this.status, this.payload, this.timestamp});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Payload {
  String? email;
  int? id;
  String? imageUrl;
  String? mobile;
  var qrCodeImageUrl;
  List<Roles>? roles;
  var uniqueQRCode;
  String? username;
  String? fcmToken;
  int? defaultDeliveryAddressId;
  List<Addresses>? addresses;

  Payload(
      {this.email,
        this.id,
        this.imageUrl,
        this.mobile,
        this.qrCodeImageUrl,
        this.roles,
        this.uniqueQRCode,
        this.username,
        this.fcmToken,
        this.defaultDeliveryAddressId,
        this.addresses});

  Payload.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    imageUrl = json['image_url'];
    mobile = json['mobile'];
    qrCodeImageUrl = json['qr_code_image_url'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    uniqueQRCode = json['uniqueQRCode'];
    username = json['username'];
    fcmToken = json['fcm_token'];
    defaultDeliveryAddressId = json['default_delivery_address_id'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['mobile'] = this.mobile;
    data['qr_code_image_url'] = this.qrCodeImageUrl;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['uniqueQRCode'] = this.uniqueQRCode;
    data['username'] = this.username;
    data['fcm_token'] = this.fcmToken;
    data['default_delivery_address_id'] = this.defaultDeliveryAddressId;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Addresses {
  String? addressLine1;
  String? addressLine2;
  String? addressType;
  String? cityName;
  String? contactNumber;
  var googlePOI;
  int? id;
  double? latitude;
  double? longitude;
  String? name;
  String? pincode;
  String? stateName;

  Addresses(
      {this.addressLine1,
        this.addressLine2,
        this.addressType,
        this.cityName,
        this.contactNumber,
        this.googlePOI,
        this.id,
        this.latitude,
        this.longitude,
        this.name,
        this.pincode,
        this.stateName});

  Addresses.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    addressType = json['address_type'];
    cityName = json['city_name'];
    contactNumber = json['contact_number'];
    googlePOI = json['googlePOI'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    pincode = json['pincode'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['address_type'] = this.addressType;
    data['city_name'] = this.cityName;
    data['contact_number'] = this.contactNumber;
    data['googlePOI'] = this.googlePOI;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['pincode'] = this.pincode;
    data['state_name'] = this.stateName;
    return data;
  }
}
