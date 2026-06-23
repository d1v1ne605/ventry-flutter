import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';

enum CategoryActionStatus { initial, success, failure }

class CategoryState extends Equatable {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final bool isSubmitting;
  final String searchKeyword;
  final Failure? failure;
  final CategoryActionStatus actionStatus;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.searchKeyword = '',
    this.failure,
    this.actionStatus = CategoryActionStatus.initial,
  });

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    bool? isSubmitting,
    String? searchKeyword,
    Failure? failure,
    CategoryActionStatus? actionStatus,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      failure: failure ?? this.failure,
      actionStatus: actionStatus ?? this.actionStatus,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        isLoading,
        isSubmitting,
        searchKeyword,
        failure,
        actionStatus,
      ];
}
