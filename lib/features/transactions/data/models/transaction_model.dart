import 'package:catalog_admin/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.sender,
    required super.receiver,
    required super.date,
    required super.status,
    required super.tags,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'date': date,
      'status': status,
      'tags': tags,
    };
  }
}
