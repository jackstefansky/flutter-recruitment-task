import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_recruitment_task/models/products_page.dart';

part 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(const FiltersState());

  FiltersState? _cachedState;

  void cacheState() => _cachedState = state;

  void restoreState() {
    if (_cachedState != null) emit(_cachedState!);
  }

  void setFilterData({
    required Set<Tag> availableTags,
    required double minPrice,
    required double maxPrice,
  }) =>
      emit(state.copyWith(
        availableTags: availableTags,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ));

  void clearFilters() => emit(state.copyWith(
        selectedTags: () => {},
        selectedMinPrice: () => null,
        selectedMaxPrice: () => null,
        onlyFavorite: false,
      ));

  void toggleTag(Tag tag) {
    final selectedTags = {...state.selectedTags};
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }

    emit(state.copyWith(selectedTags: () => selectedTags));
  }

  void changePriceRange({
    required double selectedMinPrice,
    required double selectedMaxPrice,
  }) =>
      emit(state.copyWith(
        selectedMinPrice: () => selectedMinPrice,
        selectedMaxPrice: () => selectedMaxPrice,
      ));

  void toggleOnlyFavorite() =>
      emit(state.copyWith(onlyFavorite: !state.onlyFavorite));
}
