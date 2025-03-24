class User {
  String? id;
  DateTime? createAt;
  String? email;
  String? name;
  double? latitude;
  double? longitude;
  String? address;
  int? contactno;

  User({
    this.id,
    this.createAt,
    this.email,
    this.name,
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
      "name": name,
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
      name: json['name'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      address: json['address'] ?? '',
      contactno: json['contactno'] ?? 0,
    );
  }
}
