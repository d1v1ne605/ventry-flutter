import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/usecases/get_posts.dart';
import '../../../../domain/usecases/usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPosts getPosts;

  HomeBloc(this.getPosts) : super(HomeInitial()) {
    on<GetPostsEvent>((event, emit) async {
      emit(HomeLoading());
      final result = await getPosts(NoParams());
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (posts) => emit(HomeLoaded(posts)),
      );
    });
  }
}
