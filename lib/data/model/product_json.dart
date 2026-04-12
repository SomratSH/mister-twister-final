import 'package:mister_twister/domain/entities/product_model.dart';

class ProductJson {
  int? id;
  String? name;
  String? description;
  String? slug;
  int? stock;
  String? unitPrice;
  double? priceWithTax;
  Category? category;
  List<Images>? images;

  ProductJson({
    this.id,
    this.name,
    this.description,
    this.slug,
    this.stock,
    this.unitPrice,
    this.priceWithTax,
    this.category,
    this.images,
  });

  ProductJson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    slug = json['slug'];
    stock = json['stock'];
    unitPrice = json['unit_price'];
    priceWithTax = json['price_with_tax'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['stock'] = this.stock;
    data['unit_price'] = this.unitPrice;
    data['price_with_tax'] = this.priceWithTax;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ProductModel toDomain() => ProductModel(
    id: id ?? 0,
    name: name ?? '',
    description: description ?? '',
    price: priceWithTax?.toStringAsFixed(2) ?? '',
    imageUrl: images?.map((e) => e.url ?? '').toList() ?? [],
    stock: stock?.toString() ?? '0',
  );
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Images {
  int? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
