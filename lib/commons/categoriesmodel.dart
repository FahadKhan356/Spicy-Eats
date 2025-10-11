class Categories {
  String category_id;
  String category_name;
  String rest_uid;
  String category_description;

  Categories(
      {required this.category_id,
      required this.category_name,
      required this.rest_uid,
      required this.category_description});

//tojson
  Map<String, dynamic> tojson() {
    return {
      'category_id': category_id,
      'category_name': category_name,
      'rest_uid': rest_uid,
      'category_description': category_description,
    };
  }

//fromjson
  factory Categories.fromjson(Map<String, dynamic> json) {
    return Categories(
        category_id: json['category_id'] ?? '',
        category_name: json['category_name'] ?? '',
        rest_uid: json['rest_uid'] ?? '',
        category_description: json['category_description'] ?? '');
  }
}
