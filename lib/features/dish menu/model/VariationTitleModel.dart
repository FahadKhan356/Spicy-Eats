class VariattionTitleModel {
  int? id;
  String? variationTitle;
  bool? isRequired;
  String? subtitle;
  List<Variation>? variations;
  int? maxSeleted;
  int? dishid;

  VariattionTitleModel(
      {required this.id,
      required this.variationTitle,
      required this.isRequired,
      required this.variations,
      this.subtitle,
      required this.maxSeleted,
      required this.dishid});

//tojson
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'title': variationTitle,
      'isRequired': isRequired,
      'subtitle': subtitle,
      'variation': variations,
      'maxSeleted': maxSeleted,
      'dishid': dishid,
    };
  }

//fromjson
  factory VariattionTitleModel.fromjson(Map<String, dynamic> json) {
    return VariattionTitleModel(
        id: json['id'] ?? 0,
        variationTitle: json['title'] ?? '',
        isRequired: json['isRequired'] ?? false,
        subtitle: json['subtitle'] ?? '',
        variations: (json['variations'] as List)
            .map((e) => Variation.fromjson(e))
            .toList(),
        maxSeleted: json['maxSeleted'] ?? 0,
        dishid: json['dishid'] ?? 0);
  }
}

class Variation {
  int? id;
  String? variationName;
  double? variationPrice;
  int? variation_id;
  bool? selected;

  Variation({
    required this.id,
    required this.variationName,
    required this.variationPrice,
    required this.variation_id,
    required this.selected,
  });

// tojson
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'variation_name': variationName,
      'variation_price': variationPrice,
      'variation_id': variation_id,
      'selected': selected,
    };
  }

//fromjson
  factory Variation.fromjson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'] ?? 0,
      variationName: json['variation_name'] ?? '',
      variationPrice: json['variation_price'] ?? '',
      variation_id: json['variation_id'] ?? '',
      selected: json['selected'] ?? false,
    );
  }
}
