import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String uid;
  final String name;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.uid,
    required this.name,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  CategoryEntity copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [uid, name, imageUrl, createdAt, updatedAt];
}
