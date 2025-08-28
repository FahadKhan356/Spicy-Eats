class AddressModel {
  final int? id;
  final String userId;
  final String? address;
  final String? streetNumber;
  final String? floor;
  final String? label;
  final String? othersDetails;
  final double lat;
  final double long;

  AddressModel({
    this.id,
    required this.userId,
    this.address,
    this.streetNumber,
    this.floor,
    this.label,
    this.othersDetails,
    required this.lat,
    required this.long,
  });

//to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'streetNumber': streetNumber,
      'floor': floor,
      'label': label,
      'othersDetails': othersDetails,
      'lat': lat,
      'long': long,
    };
  }

//fromjson
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      address: json['address'] ?? '',
      streetNumber: json['streetNumber'] ?? '',
      floor: json['floor'] ?? '',
      label: json['label'] ?? '',
      othersDetails: json['othersDetails'] ?? '',
      lat: json['lat'] ?? 0.0,
      long: json['long'] ?? 0.0,
    );
  }
}
