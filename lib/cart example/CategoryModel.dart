class Category {
  String name;
  List<Product> products;

  Category({required this.name, required this.products});

//fromjson
  factory Category.fromjson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> products =
        list.map((product) => Product.fromjson(product)).toList();

    return Category(name: json['name'], products: products);
  }
}

class Product {
  String name;
  String imageUrl;
  String discription;

  Product(
      {required this.discription, required this.imageUrl, required this.name});

//fromjson

  factory Product.fromjson(Map<String, dynamic> json) {
    return Product(
      imageUrl: json['imageUrl'] ?? 'asd',
      name: json['name'] ?? 'asd',
      discription: json['description'] ?? 'asdsaddaaaa',
    );
  }
}
