import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/errors/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';
import 'usecase.dart';

@lazySingleton
class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await repository.getPosts();
  }
}
