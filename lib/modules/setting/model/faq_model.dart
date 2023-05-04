import 'dart:convert';

import 'package:equatable/equatable.dart';

class FaqModel extends Equatable {
  final int id;
  final String question;
  final String answer;
  final int categoryId;

  final bool isExpanded;
  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    this.isExpanded = false,
  });

  FaqModel copyWith({
    int? id,
    String? title,
    String? question,
    String? answer,
    int? categoryId,
    bool? isExpanded,
  }) {
    return FaqModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      categoryId: categoryId ?? this.categoryId,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'question': question});
    result.addAll({'answer': answer});
    result.addAll({'faq_category_id': categoryId});
    result.addAll({'isExpanded': isExpanded});

    return result;
  }

  factory FaqModel.fromMap(Map<String, dynamic> map) {
    return FaqModel(
      id: map['id']?.toInt() ?? 0,
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      categoryId: map['faq_category_id'] ?? 0,
      isExpanded: map['isExpanded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqModel.fromJson(String source) =>
      FaqModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FaqModel(id: $id, question: $question, answer: $answer, faq_category_id: $categoryId, isExpanded: $isExpanded)';
  }

  @override
  List<Object> get props {
    return [
      id,
      question,
      answer,
      categoryId,
      isExpanded,
    ];
  }
}
