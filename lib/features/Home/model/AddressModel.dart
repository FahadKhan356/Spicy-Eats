class AddressModel {
  final String userId;
  final String? address;
  final String? streetNumber;
  final String? floor;
  final String? label;
  final String? othersDetails;

  AddressModel(
      {required this.userId,
      this.address,
      this.streetNumber,
      this.floor,
      this.label,
      this.othersDetails});

//to json
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address,
      'streetNumber': streetNumber,
      'floor': floor,
      'label': label,
      'othersDetails': othersDetails,
    };
  }

//fromjson
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      userId: json['userId'] ?? '',
      address: json['address'] ?? '',
      streetNumber: json['streetNumber'] ?? '',
      floor: json['floor'] ?? '',
      label: json['label'] ?? '',
      othersDetails: json['othersDetails'] ?? '',
    );
  }
}
