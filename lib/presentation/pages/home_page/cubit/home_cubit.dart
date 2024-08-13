import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_recruitment_task/models/filter.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._productsRepository) : super(const Loading());

  final ProductsRepository _productsRepository;
  final List<ProductsPage> _pages = [];
  var _param = GetProductsPage(pageNumber: 1);

  var _filter = const Filter();

  Future<void> getNextPage() async {
    try {
      final totalPages = _pages.lastOrNull?.totalPages;
      if (totalPages != null && _param.pageNumber > totalPages) return;
      final newPage = await _productsRepository.getProductsPage(_param);
      _param = _param.increasePageNumber();
      _pages.add(newPage);
      emit(
        Loaded(
          pages: _pages,
          products: _pages
              .map((page) => page.products)
              .expand((product) => product)
              .toList(),
          filter: _filter,
        ),
      );
    } catch (e) {
      emit(Error(error: e));
    }
  }

  Future<void> findProduct(String productId) async {
    if (state is! Loaded) return;

    var page = (state as Loaded).pages.last;

    Product? product;

    for (var i = 0; i < page.totalPages; i++) {
      product = page.products.where((p) => p.id == productId).firstOrNull;

      if (product != null) {
        return emit((state as Loaded).copyWith(initialProduct: product));
      } else {
        await getNextPage();
        page = (state as Loaded).pages.last;
      }
    }
  }

  void applyFilter(Filter filter) {
    if (state is! Loaded) return;
    _filter = filter;

    final loaded = state as Loaded;

    var products = loaded.allProducts.where((product) {
      final tagMatches = filter.tags == null ||
          filter.tags!.every((tag) => product.tags.contains(tag));

      final priceMatches =
          product.offer.itemPrice >= (filter.minPrice ?? loaded.minPrice) &&
              product.offer.itemPrice <= (filter.maxPrice ?? loaded.maxPrice);

      final onlyFavorite =
          !filter.onlyFavorite || (product.isFavorite ?? false);

      return tagMatches && priceMatches && onlyFavorite;
    }).toList();

    emit(loaded.copyWith(
      filter: filter,
      products: products,
    ));
  }
}
