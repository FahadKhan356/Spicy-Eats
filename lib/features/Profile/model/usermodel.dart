class User {
  String? id;
  DateTime? createAt;
  String? email;
  String? firstname;
  String? lastname;
  double? latitude;
  double? longitude;
  String? address;
  int? contactno;

  User({
    this.id,
    this.createAt,
    this.email,
    this.firstname,
    this.lastname,
    this.latitude,
    this.longitude,
    this.address,
    this.contactno,
  });

//tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': DateTime.now(),
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "latitude": latitude,
      'longitude': longitude,
      "address": address,
      'contactno': contactno,
    };
  }

//fromJson

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      createAt: DateTime.parse(json['created_at']),
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      address: json['address'] ?? '',
      contactno: json['contactno'] ?? 0,
    );
  }
}
