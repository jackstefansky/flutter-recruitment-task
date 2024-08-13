import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/models/filter.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';
import 'package:flutter_recruitment_task/presentation/pages/filters_page/cubit/filters_cubit.dart';
import 'package:flutter_recruitment_task/presentation/widgets/big_text.dart';
import 'package:flutter_recruitment_task/utils/color_utils.dart';

const _defaultSpacer = 16.0;

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  @override
  void initState() {
    super.initState();
    context.read<FiltersCubit>().cacheState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText('Filter'),
        leading: IconButton(
          onPressed: _onExitWithoutApplying,
          icon: const Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: BlocBuilder<FiltersCubit, FiltersState>(
        builder: (context, state) => _FiltersPageBody(state),
      ),
    );
  }

  void _onExitWithoutApplying() {
    context.read<FiltersCubit>().restoreState();
    Navigator.of(context).pop();
  }
}

class _FiltersPageBody extends StatelessWidget {
  const _FiltersPageBody(this.state);

  final FiltersState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _defaultSpacer),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _TagsSelector(
                  availableTags: state.availableTags,
                  selectedTags: state.selectedTags,
                ),
                const SizedBox(height: _defaultSpacer),
                if (state.minPrice != null && state.maxPrice != null)
                  _PriceRangeSelector(
                    minPrice: state.minPrice!,
                    selectedMinPrice: state.selectedMinPrice,
                    maxPrice: state.maxPrice!,
                    selectedMaxPrice: state.selectedMaxPrice,
                  ),
                const SizedBox(height: _defaultSpacer),
                _OtherFilters(onlyFavorite: state.onlyFavorite),
              ],
            ),
          ),
          _FilterButtons(state)
        ],
      ),
    );
  }
}

class _FilterButtons extends StatelessWidget {
  const _FilterButtons(this.state);

  final FiltersState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            child: const Text('Clear filters'),
            onPressed: () => onClearFilterPressed(context),
          ),
        ),
        Expanded(
          child: TextButton(
            child: const Text('Apply filters'),
            onPressed: () => onApplyFilterPressed(context, state: state),
          ),
        )
      ],
    );
  }

  void onApplyFilterPressed(
    BuildContext context, {
    required FiltersState state,
  }) =>
      Navigator.of(context).pop(
        Filter(
          minPrice: state.selectedMinPrice,
          maxPrice: state.selectedMaxPrice,
          tags: state.selectedTags,
          onlyFavorite: state.onlyFavorite,
        ),
      );

  void onClearFilterPressed(BuildContext context) {
    context.read<FiltersCubit>().clearFilters();
    Navigator.of(context).pop(const Filter());
  }
}

class _TagsSelector extends StatelessWidget {
  const _TagsSelector({
    required this.availableTags,
    required this.selectedTags,
  });

  final Set<Tag> availableTags;
  final Set<Tag> selectedTags;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BigText('Tags'),
        Wrap(
          spacing: _defaultSpacer,
          children: availableTags
              .map(
                (tag) => ChoiceChip(
                  label: Text(tag.label),
                  color: MaterialStateColor.resolveWith((states) =>
                      ColorUtils.fromHex(tag.color) ?? Colors.black),
                  selected: isTagSelected(tag),
                  onSelected: (_) => onTagToggled(context, tag: tag),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void onTagToggled(BuildContext context, {required Tag tag}) =>
      context.read<FiltersCubit>().toggleTag(tag);

  bool isTagSelected(Tag tag) => selectedTags.contains(tag);
}

class _PriceRangeSelector extends StatelessWidget {
  const _PriceRangeSelector({
    required this.minPrice,
    required this.selectedMinPrice,
    required this.maxPrice,
    required this.selectedMaxPrice,
  });

  final double minPrice;
  final double? selectedMinPrice;
  final double maxPrice;
  final double? selectedMaxPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BigText('Price'),
        Row(
          children: [
            Text(formatPrice(minPrice)),
            Expanded(
              child: RangeSlider(
                values: RangeValues(
                  selectedMinPrice ?? minPrice,
                  selectedMaxPrice ?? maxPrice,
                ),
                min: minPrice,
                max: maxPrice,
                onChanged: (priceRange) => onPriceRangeChanged(
                  context,
                  priceRange: priceRange,
                ),
                labels: RangeLabels(
                  formatPrice(selectedMinPrice),
                  formatPrice(selectedMaxPrice),
                ),
              ),
            ),
            Text(formatPrice(maxPrice)),
          ],
        ),
      ],
    );
  }

  String formatPrice(double? price) => '${(price ?? 0).toStringAsFixed(2)} PLN';

  void onPriceRangeChanged(
    BuildContext context, {
    required RangeValues priceRange,
  }) =>
      context.read<FiltersCubit>().changePriceRange(
            selectedMinPrice: priceRange.start,
            selectedMaxPrice: priceRange.end,
          );
}

class _OtherFilters extends StatelessWidget {
  const _OtherFilters({required this.onlyFavorite});

  final bool onlyFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BigText('Other filters'),
        Row(
          children: [
            Switch(
              value: onlyFavorite,
              onChanged: (_) => onlyFavoriteToggled(context),
            ),
            const SizedBox(width: _defaultSpacer),
            const Text('Only favorite'),
          ],
        ),
      ],
    );
  }

  void onlyFavoriteToggled(BuildContext context) =>
      context.read<FiltersCubit>().toggleOnlyFavorite();
}
