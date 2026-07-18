import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/usecases/category/create_category_usecase.dart';
import 'package:ventry_flutter/domain/usecases/category/delete_category_usecase.dart';
import 'package:ventry_flutter/domain/usecases/category/get_categories_usecase.dart';
import 'package:ventry_flutter/domain/usecases/category/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounceTime(duration), mapper);
  };
}

@injectable
class CategoryBloc extends BaseViewModel<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  CategoryBloc(
    AppLogger logger,
    this._getCategoriesUseCase,
    this._createCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
  ) : super(const CategoryState(), logger) {
    on<LoadCategories>(_onLoadCategories);
    on<SearchCategories>(
      _onSearchCategories,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final result = await _getCategoriesUseCase(null);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, failure: failure));
      },
      (categories) {
        emit(
          state.copyWith(
            isLoading: false,
            categories: categories,
            searchKeyword: '',
          ),
        );
      },
    );
  }

  Future<void> _onSearchCategories(
    SearchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        failure: null,
        searchKeyword: event.query,
      ),
    );

    final result = await _getCategoriesUseCase(
      event.query.isEmpty ? null : event.query,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, failure: failure));
      },
      (categories) {
        emit(state.copyWith(isLoading: false, categories: categories));
      },
    );
  }

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionStatus: CategoryActionStatus.initial,
      ),
    );

    final result = await _createCategoryUseCase(
      CreateCategoryParams(name: event.name, imageUrl: event.imageUrl),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: failure,
            actionStatus: CategoryActionStatus.failure,
          ),
        );
      },
      (newCategory) {
        emit(
          state.copyWith(
            isSubmitting: false,
            actionStatus: CategoryActionStatus.success,
            categories: [newCategory, ...state.categories], // Add to the top
          ),
        );
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionStatus: CategoryActionStatus.initial,
      ),
    );

    final result = await _updateCategoryUseCase(
      UpdateCategoryParams(
        categoryUid: event.categoryUid,
        name: event.name,
        imageUrl: event.imageUrl,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: failure,
            actionStatus: CategoryActionStatus.failure,
          ),
        );
      },
      (updatedCategory) {
        final updatedList = state.categories.map((c) {
          if (c.uid == updatedCategory.uid) return updatedCategory;
          return c;
        }).toList();

        emit(
          state.copyWith(
            isSubmitting: false,
            actionStatus: CategoryActionStatus.success,
            categories: updatedList,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        actionStatus: CategoryActionStatus.initial,
      ),
    );

    final result = await _deleteCategoryUseCase(event.categoryUid);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: failure,
            actionStatus: CategoryActionStatus.failure,
          ),
        );
      },
      (deletedUid) {
        final updatedList = state.categories
            .where((c) => c.uid != deletedUid)
            .toList();

        emit(
          state.copyWith(
            isSubmitting: false,
            actionStatus: CategoryActionStatus.success,
            categories: updatedList,
          ),
        );
      },
    );
  }
}
