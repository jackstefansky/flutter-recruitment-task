import 'package:flutter_recruitment_task/models/filter.dart';
import 'package:flutter_recruitment_task/models/get_products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/cubit/home_cubit.dart';
import 'package:flutter_recruitment_task/repositories/products_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixtures.dart';

class MockMockedProductsRepository extends Mock
    implements MockedProductsRepository {}

void main() {
  group(HomeCubit, () {
    TestWidgetsFlutterBinding.ensureInitialized();

    late ProductsRepository productRepository;
    late HomeCubit homeCubit;

    setUpAll(() {
      registerFallbackValue(GetProductsPage(pageNumber: 1));
    });

    setUp(() {
      productRepository = MockMockedProductsRepository();
      homeCubit = HomeCubit(productRepository);

      when(() => productRepository.getProductsPage(any()))
          .thenAnswer((_) async => page);
    });

    blocTest<HomeCubit, HomeState>(
      'emits [Loading, Loaded] when getNextPage has been called',
      build: () => homeCubit,
      seed: () => const Loading(),
      act: (cubit) => cubit.getNextPage(),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productCafe, productJuice],
          filter: const Filter(),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loading, Error] when getNextPage has failed',
      setUp: () {
        when(
          () => productRepository.getProductsPage(any()),
        ).thenThrow(getProductsException);
      },
      build: () => homeCubit,
      seed: () => const Loading(),
      act: (cubit) => cubit.getNextPage(),
      expect: () => [Error(error: getProductsException)],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with initial product',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.findProduct(productCafe.id),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productJuice, productCafe],
          initialProduct: productCafe,
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with products having cheap tag on applyFilter called',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.applyFilter(Filter(tags: {tagCheap})),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productJuice],
          filter: Filter(tags: {tagCheap}),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with products that price is higher than 10 PLN on applyFilter called',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.applyFilter(const Filter(minPrice: 10)),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productCafe],
          filter: const Filter(minPrice: 10),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with products that price is lower than 10 PLN on applyFilter called',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.applyFilter(const Filter(maxPrice: 10)),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productJuice],
          filter: const Filter(maxPrice: 10),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with products that are favourite on applyFilter called',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.applyFilter(const Filter(onlyFavorite: true)),
      expect: () => [
        Loaded(
          pages: [page],
          products: const [],
          filter: const Filter(onlyFavorite: true),
        ),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits [Loaded] with products that price is lower than 6 PLN'
      'having tag cheap on applyFilter called',
      build: () => homeCubit,
      seed: () => Loaded(
        pages: [page],
        products: [productJuice, productCafe],
      ),
      act: (cubit) => cubit.applyFilter(Filter(maxPrice: 6, tags: {tagCheap})),
      expect: () => [
        Loaded(
          pages: [page],
          products: [productJuice],
          filter: Filter(maxPrice: 6, tags: {tagCheap}),
        ),
      ],
    );
  });
}
