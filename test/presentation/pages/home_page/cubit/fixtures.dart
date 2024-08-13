import 'package:flutter_recruitment_task/models/products_page.dart';

final Exception getProductsException = Exception('Could not get products');

const tagBest =
    Tag(tag: 'best', label: 'Best', color: '#ff0000', labelColor: '#000000');
const tagCheap =
    Tag(tag: 'cheap', label: 'Cheap', color: '#00ff00', labelColor: '#000000');
const tagNew =
    Tag(tag: 'new', label: 'New', color: '#0000ff', labelColor: '#000000');

final productCafe = Product(
  id: '32',
  name: 'Kawa',
  mainImage: '',
  description: '',
  available: true,
  isFavorite: false,
  isBlurred: false,
  sellerId: 'seller123',
  tags: [tagBest, tagNew],
  offer: Offer(
    skuId: '',
    sellerId: '',
    sellerName: '',
    subtitle: '',
    isSponsored: false,
    isBest: false,
    regularPrice: Price(amount: 12.99, currency: 'PLN'),
    promotionalPrice: null,
    normalizedPrice:
        NormalizedPrice(amount: 12.99, currency: 'PLN', unitLabel: '1/sz'),
    promotionalNormalizedPrice: null,
    omnibusPrice: null,
    omnibusLabel: '',
    tags: [tagBest],
  ),
);

final productJuice = Product(
  id: '99',
  name: 'Sok',
  mainImage: '',
  description: '',
  available: true,
  isFavorite: false,
  isBlurred: false,
  sellerId: 'seller999',
  tags: [tagCheap],
  offer: Offer(
    skuId: '',
    sellerId: '',
    sellerName: '',
    subtitle: '',
    isSponsored: false,
    isBest: false,
    regularPrice: Price(amount: 5.99, currency: 'PLN'),
    promotionalPrice: null,
    normalizedPrice:
        NormalizedPrice(amount: 5.99, currency: 'PLN', unitLabel: '1/sz'),
    promotionalNormalizedPrice: null,
    omnibusPrice: null,
    omnibusLabel: '',
    tags: [tagCheap],
  ),
);

final page = ProductsPage(
  totalPages: 3,
  pageNumber: 1,
  pageSize: 2,
  products: [productCafe, productJuice],
);
