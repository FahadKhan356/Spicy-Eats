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
  String? lastAddress;

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
    this.lastAddress,
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
      'last_address': lastAddress,
    };
  }

//fromJson

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      // created_at is filled in by the DB default and can legitimately be
      // absent on freshly created rows, so it must never hard-fail parsing.
      createAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
      email: json['email'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      address: json['address'] ?? '',
      contactno: json['contactno'] ?? 0,
      lastAddress: json['last_address'] ?? '',
    );
  }
}

/// Display name used by the account/profile headers.
///
/// [user] is null until `ProfileRepo.fetchuser` fills `userProvider` (both
/// screens read it on their very first frame) and the `users` row itself can
/// have blank columns, so this must never assume a non-null user. Force
/// unwrapping it used to throw "Null check operator used on a null value"
/// right after login.
String accountDisplayName(User? user) {
  return [user?.firstname, user?.lastname]
      .whereType<String>()
      .where((part) => part.trim().isNotEmpty)
      .join(' ');
}

/// Single letter shown in the avatar bubble, 'U' when the name is unknown.
String accountAvatarInitial(String displayName) =>
    displayName.isEmpty ? 'U' : displayName.substring(0, 1).toUpperCase();

/// Phone number as display text, empty string when the column is unset.
String accountContactText(User? user) {
  final contact = user?.contactno;
  return (contact == null || contact == 0) ? '' : contact.toString();
}
