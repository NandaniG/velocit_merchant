class KYCDataModel {
  String? status;
  Payload? payload;
  String? timestamp;

  KYCDataModel({this.status, this.payload, this.timestamp});

  KYCDataModel.fromJson(Map<String, dynamic> json) {
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
  int? merchantId;
  Null? addressId;
  int? id;
  String? addressImageUrl;
  String? panNumber;
  String? nameAsPerPan;
  String? panImageUrl;
  String? licenseNumber;
  String? licenseImageUrl;
  String? gstNumber;
  bool? isGstApplicable;
  String? gstImageUrl;

  Payload(
      {this.merchantId,
        this.addressId,
        this.id,
        this.addressImageUrl,
        this.panNumber,
        this.nameAsPerPan,
        this.panImageUrl,
        this.licenseNumber,
        this.licenseImageUrl,
        this.gstNumber,
        this.isGstApplicable,
        this.gstImageUrl});

  Payload.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchant_id'];
    addressId = json['address_id'];
    id = json['id'];
    addressImageUrl = json['address_image_url'];
    panNumber = json['pan_number'];
    nameAsPerPan = json['name_as_per_pan'];
    panImageUrl = json['pan_image_url'];
    licenseNumber = json['license_number'];
    licenseImageUrl = json['license_image_url'];
    gstNumber = json['gst_number'];
    isGstApplicable = json['is_gst_applicable'];
    gstImageUrl = json['gst_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchant_id'] = this.merchantId;
    data['address_id'] = this.addressId;
    data['id'] = this.id;
    data['address_image_url'] = this.addressImageUrl;
    data['pan_number'] = this.panNumber;
    data['name_as_per_pan'] = this.nameAsPerPan;
    data['pan_image_url'] = this.panImageUrl;
    data['license_number'] = this.licenseNumber;
    data['license_image_url'] = this.licenseImageUrl;
    data['gst_number'] = this.gstNumber;
    data['is_gst_applicable'] = this.isGstApplicable;
    data['gst_image_url'] = this.gstImageUrl;
    return data;
  }
}
