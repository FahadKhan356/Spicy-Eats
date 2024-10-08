class DishData {
  int? dishid;
  String? dish_name;
  String? dish_description;
  String? dish_imageurl;
  int? dish_price;
  String? dish_schedule_meal;
  String? cusine;
  int? dish_discount;

  DishData({
    this.dishid,
    this.dish_description,
    this.dish_imageurl,
    this.dish_price,
    this.dish_schedule_meal,
    this.cusine,
    this.dish_name,
    this.dish_discount,
  });

//tojson
  Map<String, dynamic> tojson() {
    return {
      'dishid': dishid,
      'dish_name': dish_name,
      'dish_price': dish_price,
      'dish_discount': dish_discount,
      'dish_description': dish_description,
      'dish_imageurl': dish_imageurl,
      'dish_schedule_meal': dish_schedule_meal,
      'cusine': cusine,
    };
  }

//fromjson
  factory DishData.fromJson(Map<String, dynamic> json) {
    return DishData(
      dishid: json['id'] ?? 0,
      dish_name: json['dish_name'] ?? '',
      dish_price: json['dish_price'] ?? 0,
      dish_discount: json['dish_discount'] ?? 0,
      dish_description: json['dish_description'] ?? '',
      dish_imageurl: json['dish_imageurl'] ?? '',
      dish_schedule_meal: json['dish_schedule_meal'] ?? '',
      cusine: json['cusine'] ?? '',
    );
  }
}
