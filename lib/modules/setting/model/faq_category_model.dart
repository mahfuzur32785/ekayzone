import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:ekayzone/modules/setting/model/faq_model.dart';

class FaqCategoryModel extends Equatable{
  const FaqCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.order,
    required this.faqs,
  });

  final int id;
  final String name;
  final String slug;
  final String icon;
  final int order;
  final List<FaqModel> faqs;

  FaqCategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? icon,
    int? order,
    List<FaqModel>? faqs,
  }) =>
      FaqCategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        icon: icon ?? this.icon,
        order: order ?? this.order,
        faqs: faqs ?? this.faqs,
      );

  factory FaqCategoryModel.fromJson(String str) => FaqCategoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FaqCategoryModel.fromMap(Map<String, dynamic> json) => FaqCategoryModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    icon: json["icon"],
    order: json["order"],
    faqs: json["faqs"] == null ? [] : List<FaqModel>.from(json["faqs"]!.map((x) => FaqModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "slug": slug,
    "icon": icon,
    "order": order,
    "faqs": List<dynamic>.from(faqs.map((x) => x.toMap())),
  };

  @override
  String toString() {
    return 'FaqCategoryModel(id: $id, name: $name, slug: $slug, icon: $icon, order: $order, faqs: $faqs)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      slug,
      icon,
      order,
      faqs,
    ];
  }
}