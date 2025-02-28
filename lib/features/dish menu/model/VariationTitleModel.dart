class VariattionTitleModel {
  int id;
  String variationTitle;
  bool isRequired;
  String? subtitle;
  List<Variation> variations;

  VariattionTitleModel({
    required this.id,
    required this.variationTitle,
    required this.isRequired,
    required this.variations,
    this.subtitle,
  });

//tojson
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'title': variationTitle,
      'isRequired': isRequired,
      'subtitle': subtitle,
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
    );
  }
}

class Variation {
  int id;
  String variationName;
  double variationPrice;
  int variation_id;

  Variation(
      {required this.id,
      required this.variationName,
      required this.variationPrice,
      required this.variation_id});

// tojson
  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'variation_name': variationName,
      'variation_price': variationPrice,
      'variation_id': variation_id,
    };
  }

//fromjson
  factory Variation.fromjson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'] ?? 0,
      variationName: json['variation_name'] ?? '',
      variationPrice: json['variation_price'] ?? '',
      variation_id: json['variation_id'] ?? '',
    );
  }
}
