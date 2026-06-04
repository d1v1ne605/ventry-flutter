import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

@LazySingleton(as: PostRemoteDataSource)
class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await dio.get('/posts');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Server Error');
    }
  }
}
