import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SearchCategories extends CategoryEvent {
  final String query;

  const SearchCategories(this.query);

  @override
  List<Object?> get props => [query];
}

class CreateCategory extends CategoryEvent {
  final String name;
  final String? imageUrl;

  const CreateCategory({required this.name, this.imageUrl});

  @override
  List<Object?> get props => [name, imageUrl];
}

class UpdateCategory extends CategoryEvent {
  final String categoryUid;
  final String name;
  final String? imageUrl;

  const UpdateCategory({
    required this.categoryUid,
    required this.name,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [categoryUid, name, imageUrl];
}

class DeleteCategory extends CategoryEvent {
  final String categoryUid;

  const DeleteCategory(this.categoryUid);

  @override
  List<Object?> get props => [categoryUid];
}
