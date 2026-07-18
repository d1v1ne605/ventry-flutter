import 'package:equatable/equatable.dart';

class AttributeValueEntity extends Equatable {
  final String uid;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttributeValueEntity({
    required this.uid,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [uid, value, createdAt, updatedAt];
}
