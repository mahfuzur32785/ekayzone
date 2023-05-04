import 'dart:convert';

class EventModel {
  EventModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.details,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    required this.endDate,
    required this.timezone,
    required this.allDayEventStatus,
    required this.image,
    required this.categoryId,
    required this.tagId,
    required this.eventStatus,
    required this.status,
    required this.venueId,
    required this.organiserId,
    required this.wheelchair,
    required this.accessible,
    required this.eventInfoLink,
    required this.cost,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.start,
    required this.end,
  });

  final int id;
  final int userId;
  final String title;
  final String slug;
  final String shortDescription;
  final String details;
  final DateTime startDate;
  final String startTime;
  final String endTime;
  final DateTime endDate;
  final String timezone;
  final int allDayEventStatus;
  final String image;
  final String categoryId;
  final String tagId;
  final int eventStatus;
  final int status;
  final int venueId;
  final String organiserId;
  final int wheelchair;
  final int accessible;
  final String eventInfoLink;
  final double cost;
  final DateTime createdAt;
  final int createdBy;
  final int updatedBy;
  final dynamic start;
  final dynamic end;

  EventModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? slug,
    String? shortDescription,
    String? details,
    DateTime? startDate,
    String? startTime,
    String? endTime,
    DateTime? endDate,
    String? timezone,
    int? allDayEventStatus,
    String? image,
    String? categoryId,
    String? tagId,
    int? eventStatus,
    int? status,
    int? venueId,
    String? organiserId,
    int? wheelchair,
    int? accessible,
    String? eventInfoLink,
    double? cost,
    DateTime? createdAt,
    int? createdBy,
    int? updatedBy,
    dynamic start,
    dynamic end,
  }) =>
      EventModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        shortDescription: shortDescription ?? this.shortDescription,
        details: details ?? this.details,
        startDate: startDate ?? this.startDate,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        endDate: endDate ?? this.endDate,
        timezone: timezone ?? this.timezone,
        allDayEventStatus: allDayEventStatus ?? this.allDayEventStatus,
        image: image ?? this.image,
        categoryId: categoryId ?? this.categoryId,
        tagId: tagId ?? this.tagId,
        eventStatus: eventStatus ?? this.eventStatus,
        status: status ?? this.status,
        venueId: venueId ?? this.venueId,
        organiserId: organiserId ?? this.organiserId,
        wheelchair: wheelchair ?? this.wheelchair,
        accessible: accessible ?? this.accessible,
        eventInfoLink: eventInfoLink ?? this.eventInfoLink,
        cost: cost ?? this.cost,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory EventModel.fromJson(String str) => EventModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EventModel.fromMap(Map<String, dynamic> json) => EventModel(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    title: json["title"] ?? '',
    slug: json["slug"] ?? '',
    shortDescription: json["short_description"] ?? '',
    details: json["details"] ?? '',
    startDate: DateTime.parse(json["start_date"]),
    startTime: json["start_time"] ?? '',
    endTime: json["end_time"] ?? '',
    endDate: DateTime.parse(json["end_date"]),
    timezone: json["timezone"] ?? '',
    allDayEventStatus: json["all_day_event_status"] ?? 0,
    image: json["image"] ?? '',
    categoryId: json["category_id"] ?? '',
    tagId: json["tag_id"] ?? '',
    eventStatus: json["event_status"] ?? 0,
    status: json["status"] ?? 0,
    venueId: json["venue_id"] ?? 0,
    organiserId: json["organiser_id"] ?? '',
    wheelchair: json["wheelchair"] ?? 0,
    accessible: json["accessible"] ?? 0,
    eventInfoLink: json["event_info_link"] ?? '',
    cost: json["cost"] == null ? 0.0 : json["cost"]?.toDouble(),
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"] ?? 0,
    updatedBy: json["updated_by"] ?? 0,
    start: json["start"],
    end: json["end"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "slug": slug,
    "short_description": shortDescription,
    "details": details,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "timezone": timezone,
    "all_day_event_status": allDayEventStatus,
    "image": image,
    "category_id": categoryId,
    "tag_id": tagId,
    "event_status": eventStatus,
    "status": status,
    "venue_id": venueId,
    "organiser_id": organiserId,
    "wheelchair": wheelchair,
    "accessible": accessible,
    "event_info_link": eventInfoLink,
    "cost": cost,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "start": start,
    "end": end,
  };
}