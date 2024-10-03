class Categories {
  String? categoryid;
  String? categoryname;
  String? categorydescription;
  String? restiuid;

  Categories(
      {this.categoryname,
      this.categoryid,
      this.restiuid,
      this.categorydescription});

//tomap tojson
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryid,
      'category_name': categoryname,
      'rest_uid': restiuid,
      'category_description': categorydescription,
    };
  }

//frommap fromjson

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categoryid: json['category_id'],
      categoryname: json['category_name'],
      categorydescription: json['category_description'],
      restiuid: json['rest_uid'],
    );
  }
}
