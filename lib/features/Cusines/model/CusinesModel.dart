class CusinesModel {
  final int id;
  final DateTime created_at;
  final String cusineName;
  final String cusineImage;

  CusinesModel({
    required this.id,
    required this.created_at,
    required this.cusineName,
    required this.cusineImage,
  });

  /// Create from JSON (Supabase row)
  factory CusinesModel.fromJson(Map<String, dynamic> json) {
    return CusinesModel(
      id: json['id'] as int,
      created_at: DateTime.parse(json['created_at'] as String),
      cusineName: json['cusineName'] as String,
      cusineImage: json['cusineImage'] as String,
    );
  }

  /// Convert to JSON (for insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at.toIso8601String(),
      'cusine_name': cusineName,
      'cusine_image': cusineImage,
    };
  }

  /// Copy with new values
  CusinesModel copyWith({
    int? id,
    DateTime? createdAt,
    String? cusineName,
    String? cusineImage,
  }) {
    return CusinesModel(
      id: id ?? this.id,
      created_at: createdAt ?? this.created_at,
      cusineName: cusineName ?? this.cusineName,
      cusineImage: cusineImage ?? this.cusineImage,
    );
  }
}
