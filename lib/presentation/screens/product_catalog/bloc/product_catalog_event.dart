import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';

abstract class ProductCatalogEvent extends Equatable {
  const ProductCatalogEvent();

  @override
  List<Object?> get props => [];
}

class LoadSkus extends ProductCatalogEvent {
  const LoadSkus();
}

class SearchSkus extends ProductCatalogEvent {
  final String query;

  const SearchSkus(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterSkus extends ProductCatalogEvent {
  final String? status;
  final bool? isStockAlert;

  const FilterSkus({this.status, this.isStockAlert});

  @override
  List<Object?> get props => [status, isStockAlert];
}

class CreateProduct extends ProductCatalogEvent {
  final CreateProductParams params;

  const CreateProduct(this.params);

  @override
  List<Object?> get props => [params];
}
