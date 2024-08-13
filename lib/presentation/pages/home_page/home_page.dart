import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/filters_page/cubit/filters_cubit.dart';
import 'package:flutter_recruitment_task/presentation/pages/filters_page/filters_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/home_page/cubit/home_cubit.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';
import 'package:flutter_recruitment_task/utils/color_utils.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

const _mainPadding = EdgeInsets.symmetric(horizontal: 16.0);

class HomePage extends StatelessWidget {
  const HomePage({this.initialProductId, super.key});

  final String? initialProductId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: _listenToState,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const BigText('Products'),
          actions: [
            if (state is Loaded)
              IconButton(
                onPressed: () => _onFilterPressed(context, state),
                icon: const Icon(Icons.filter_list),
              )
          ],
        ),
        body: Padding(
          padding: _mainPadding,
          child: switch (state) {
            Error() => BigText('Error: ${state.error}'),
            Loading() => const BigText('Loading...'),
            Loaded() => _LoadedWidget(state: state),
          },
        ),
      ),
    );
  }

  void _listenToState(BuildContext context, HomeState state) {
    if (state is Loaded) {
      context.read<FiltersCubit>().setFilterData(
            availableTags: state.availableTags,
            minPrice: state.minPrice,
            maxPrice: state.maxPrice,
          );

      if (initialProductId == null || state.initialProduct != null) return;

      context.read<HomeCubit>().findProduct(initialProductId!);
    }

    if (state is Error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  Future<void> _onFilterPressed(
    BuildContext context,
    Loaded state,
  ) async =>
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const FiltersPage()))
          .then((filter) {
        if (filter != null) context.read<HomeCubit>().applyFilter(filter);
      });
}

class _LoadedWidget extends StatefulWidget {
  const _LoadedWidget({required this.state});

  final Loaded state;

  @override
  State<_LoadedWidget> createState() => _LoadedWidgetState();
}

class _LoadedWidgetState extends State<_LoadedWidget> {
  final controller = AutoScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToProduct();
  }

  @override
  void didUpdateWidget(covariant _LoadedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.initialProduct == oldWidget.state.initialProduct) return;

    _scrollToProduct();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        _ProductsSliverList(
          controller: controller,
          products: widget.state.products,
        ),
        const _GetNextPageButton(),
      ],
    );
  }

  void _scrollToProduct() {
    if (widget.state.initialProduct == null) return;

    final productIndex = widget.state.products.indexOf(
      widget.state.initialProduct!,
    );

    controller.scrollToIndex(
      productIndex,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class _ProductsSliverList extends StatelessWidget {
  const _ProductsSliverList({
    required this.controller,
    required this.products,
  });

  final AutoScrollController controller;

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      addAutomaticKeepAlives: true,
      itemCount: products.length,
      itemBuilder: (context, index) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: _ProductCard(products[index]),
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(product.name),
          _Tags(product: product),
        ],
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: product.tags.map(_TagWidget.new).toList(),
    );
  }
}

class _TagWidget extends StatelessWidget {
  const _TagWidget(this.tag);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.fromHex(tag.color);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        color: MaterialStateProperty.all(color),
        label: Text(tag.label),
      ),
    );
  }
}

class _GetNextPageButton extends StatelessWidget {
  const _GetNextPageButton();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: TextButton(
        onPressed: context.read<HomeCubit>().getNextPage,
        child: const BigText('Get next page'),
      ),
    );
  }
}
