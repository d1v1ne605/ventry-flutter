import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/attribute/attribute_response_dto.dart';
import 'package:ventry_flutter/data/models/attribute/attribute_value_response_dto.dart';
import 'package:ventry_flutter/data/models/attribute/create_attribute_dto.dart';
import 'package:ventry_flutter/data/models/attribute/create_attribute_value_dto.dart';

part 'attribute_api.g.dart';

@RestApi()
abstract class AttributeApi {
  factory AttributeApi(Dio dio, {String baseUrl}) = _AttributeApi;

  @GET('/attributes')
  Future<List<AttributeResponseDto>> getAttributes();

  @POST('/attributes')
  Future<AttributeResponseDto> createAttribute(@Body() CreateAttributeDto body);

  @POST('/attributes/{attributeUid}/values')
  Future<AttributeValueResponseDto> createAttributeValue(
    @Path('attributeUid') String attributeUid,
    @Body() CreateAttributeValueDto body,
  );
}
