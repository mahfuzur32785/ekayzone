import 'dart:convert';

class DirectoryModel {
  DirectoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.userId,
    required this.categoryId,
    required this.subcategoryId,
    required this.description,
    required this.email,
    required this.phone,
    required this.phone2,
    required this.thumbnail,
    required this.status,
    required this.totalReports,
    required this.totalViews,
    required this.createdAt,
    required this.address,
    required this.map,
    required this.street,
    required this.municipality,
    required this.plusCode,
    required this.lat,
    required this.lang,
    required this.website,
    required this.openingHours,
    required this.domain,
    required this.reviewUrl,
    required this.reviewCount,
    required this.averageRating,
    required this.businessProfileLink,
    required this.googleKnowledgeUrl,
  });

  final int id;
  final String title;
  final String slug;
  final int userId;
  final int categoryId;
  final int subcategoryId;
  final String description;
  final String email;
  final String phone;
  final String phone2;
  final String thumbnail;
  final String status;
  final int totalReports;
  final int totalViews;
  final DateTime createdAt;
  final String address;
  final String map;
  final String street;
  final String municipality;
  final int plusCode;
  final String lat;
  final String lang;
  final String website;
  final String openingHours;
  final String domain;
  final String reviewUrl;
  final String reviewCount;
  final String averageRating;
  final String businessProfileLink;
  final String googleKnowledgeUrl;

  DirectoryModel copyWith({
    int? id,
    String? title,
    String? slug,
    int? userId,
    int? categoryId,
    int? subcategoryId,
    String? description,
    String? email,
    String? phone,
    String? phone2,
    String? thumbnail,
    String? status,
    int? totalReports,
    int? totalViews,
    DateTime? createdAt,
    String? address,
    String? map,
    String? street,
    String? municipality,
    int? plusCode,
    String? lat,
    String? lang,
    String? website,
    String? openingHours,
    String? domain,
    String? reviewUrl,
    String? reviewCount,
    String? averageRating,
    String? businessProfileLink,
    String? googleKnowledgeUrl,
  }) =>
      DirectoryModel(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        userId: userId ?? this.userId,
        categoryId: categoryId ?? this.categoryId,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        description: description ?? this.description,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        phone2: phone2 ?? this.phone2,
        thumbnail: thumbnail ?? this.thumbnail,
        status: status ?? this.status,
        totalReports: totalReports ?? this.totalReports,
        totalViews: totalViews ?? this.totalViews,
        createdAt: createdAt ?? this.createdAt,
        address: address ?? this.address,
        map: map ?? this.map,
        street: street ?? this.street,
        municipality: municipality ?? this.municipality,
        plusCode: plusCode ?? this.plusCode,
        lat: lat ?? this.lat,
        lang: lang ?? this.lang,
        website: website ?? this.website,
        openingHours: openingHours ?? this.openingHours,
        domain: domain ?? this.domain,
        reviewUrl: reviewUrl ?? this.reviewUrl,
        reviewCount: reviewCount ?? this.reviewCount,
        averageRating: averageRating ?? this.averageRating,
        businessProfileLink: businessProfileLink ?? this.businessProfileLink,
        googleKnowledgeUrl: googleKnowledgeUrl ?? this.googleKnowledgeUrl,
      );

  factory DirectoryModel.fromJson(String str) => DirectoryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DirectoryModel.fromMap(Map<String, dynamic> json) => DirectoryModel(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    slug: json["slug"] ?? '',
    userId: json["user_id"] ?? 0,
    categoryId: json["category_id"] ?? 0,
    subcategoryId: json["subcategory_id"] ?? 0,
    description: json["description"] ?? '',
    email: json["email"] ?? '',
    phone: json["phone"] ?? '',
    phone2: json["phone_2"] ?? '',
    thumbnail: json["thumbnail"] ?? '',
    status: json["status"] ?? 0,
    totalReports: json["total_reports"] ?? 0,
    totalViews: json["total_views"] ?? 0,
    createdAt: DateTime.parse(json["created_at"]),
    address: json["address"] ?? '',
    map: json["map"] ?? '',
    street: json["street"] ?? '',
    municipality: json["municipality"] ?? '',
    plusCode: json["plus_code"] ?? 0,
    lat: json["lat"] == null
        ? ''
        : (json["lat"] is double)
        ? (json["lat"] as double).toString()
        : json["lat"],
    lang: json["lang"] == null
        ? '0.0'
        : (json["lang"] is double)
        ? (json["lang"] as double).toString()
        : json["lang"],
    website: json["website"] ?? '',
    openingHours: json["opening_hours"] ?? '',
    domain: json["domain"] ?? '',
    reviewUrl: json["review_url"] ?? '',
    reviewCount: json["review_count"] ?? '',
    averageRating: json["average_rating"] ?? '',
    businessProfileLink: json["business_profile_link"] ?? '',
    googleKnowledgeUrl: json["google_knowledge_url"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "slug": slug,
    "user_id": userId,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "description": description,
    "email": email,
    "phone": phone,
    "phone_2": phone2,
    "thumbnail": thumbnail,
    "status": status,
    "total_reports": totalReports,
    "total_views": totalViews,
    "created_at": createdAt.toIso8601String(),
    "address": address,
    "map": map,
    "street": street,
    "municipality": municipality,
    "plus_code": plusCode,
    "lat": lat,
    "lang": lang,
    "website": website,
    "opening_hours": openingHours,
    "domain": domain,
    "review_url": reviewUrl,
    "review_count": reviewCount,
    "average_rating": averageRating,
    "business_profile_link": businessProfileLink,
    "google_knowledge_url": googleKnowledgeUrl,
  };
}