import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String sender;
  final String receiver;
  final String date;
  final String status;
  final List<String> tags;

  const TransactionEntity({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.date,
    required this.status,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, sender, receiver, date, status, tags];
}
