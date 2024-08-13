import 'package:equatable/equatable.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';

class Filter extends Equatable {
  const Filter({
    this.maxPrice,
    this.minPrice,
    this.tags,
    this.onlyFavorite = false,
  });

  final double? maxPrice;

  final double? minPrice;

  final Set<Tag>? tags;

  final bool onlyFavorite;

  @override
  List<Object?> get props => [maxPrice, minPrice, tags, onlyFavorite];
}
