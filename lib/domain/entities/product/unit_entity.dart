import 'package:equatable/equatable.dart';

class UnitEntity extends Equatable {
  const UnitEntity({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];
}
