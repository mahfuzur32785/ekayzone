import 'dart:convert';

import 'package:ekayzone/modules/home/model/pricing_model.dart';

class PlansBillingModel {
  PlansBillingModel({
    required this.id,
    required this.orderId,
    required this.transactionId,
    required this.paymentProvider,
    required this.planId,
    required this.userId,
    required this.amount,
    required this.currencySymbol,
    required this.usdAmount,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.plan,
  });

  final int id;
  final String orderId;
  final String transactionId;
  final String paymentProvider;
  final int planId;
  final int userId;
  final String amount;
  final String currencySymbol;
  final String usdAmount;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PricingModel plan;

  PlansBillingModel copyWith({
    int? id,
    String? orderId,
    String? transactionId,
    String? paymentProvider,
    int? planId,
    int? userId,
    String? amount,
    String? currencySymbol,
    String? usdAmount,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    PricingModel? plan,
  }) =>
      PlansBillingModel(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        transactionId: transactionId ?? this.transactionId,
        paymentProvider: paymentProvider ?? this.paymentProvider,
        planId: planId ?? this.planId,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        usdAmount: usdAmount ?? this.usdAmount,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        plan: plan ?? this.plan,
      );

  factory PlansBillingModel.fromJson(String str) => PlansBillingModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlansBillingModel.fromMap(Map<String, dynamic> json) => PlansBillingModel(
    id: json["id"],
    orderId: json["order_id"],
    transactionId: json["transaction_id"],
    paymentProvider: json["payment_provider"],
    planId: json["plan_id"],
    userId: json["user_id"],
    amount: json["amount"],
    currencySymbol: json["currency_symbol"],
    usdAmount: json["usd_amount"],
    paymentStatus: json["payment_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    plan: PricingModel.fromMap(json["plan"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "transaction_id": transactionId,
    "payment_provider": paymentProvider,
    "plan_id": planId,
    "user_id": userId,
    "amount": amount,
    "currency_symbol": currencySymbol,
    "usd_amount": usdAmount,
    "payment_status": paymentStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "plan": plan.toMap(),
  };
}