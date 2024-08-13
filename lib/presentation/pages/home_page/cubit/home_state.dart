part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

class Loading extends HomeState {
  const Loading();

  @override
  List<Object> get props => [];
}

class Error extends HomeState {
  const Error({required this.error});

  final dynamic error;

  @override
  List<Object> get props => [error];
}

class Loaded extends HomeState {
  const Loaded({
    required this.pages,
    this.products = const [],
    this.filter = const Filter(),
    this.initialProduct,
  });

  final List<ProductsPage> pages;

  final List<Product> products;

  final Filter filter;

  final Product? initialProduct;

  Loaded copyWith({
    List<ProductsPage>? pages,
    Filter? filter,
    List<Product>? products,
    Product? initialProduct,
  }) =>
      Loaded(
        pages: pages ?? this.pages,
        filter: filter ?? this.filter,
        products: products ?? this.products,
        initialProduct: initialProduct ?? this.initialProduct,
      );

  @override
  List<Object?> get props => [pages, filter, products, initialProduct];
}

extension LoadedStateExtension on Loaded {
  List<Product> get allProducts =>
      pages.map((page) => page.products).expand((product) => product).toList();

  Set<Tag> get availableTags =>
      allProducts.map((p) => p.tags).expand((tags) => tags).toSet();

  double get minPrice => allProducts
      .reduce((c, n) => c.offer.itemPrice < n.offer.itemPrice ? c : n)
      .offer
      .itemPrice;

  double get maxPrice => allProducts
      .reduce((c, n) => c.offer.itemPrice > n.offer.itemPrice ? c : n)
      .offer
      .itemPrice;
}

extension OfferExtension on Offer {
  bool get onPromotion => promotionalPrice != null;

  double get itemPrice =>
      onPromotion ? promotionalPrice!.amount : regularPrice.amount;
}
