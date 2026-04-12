import 'package:mister_twister/domain/entities/catagory_model.dart';

class CategoryJson {
  int? id;
  String? name;
  String? slug;

  CategoryJson({this.id, this.name, this.slug});

  CategoryJson.fromJson(Map<String, dynamic> json) {
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

  CatagoryModel toDomain() {
    return CatagoryModel(id: id, name: name, slug: slug);
  }
}
