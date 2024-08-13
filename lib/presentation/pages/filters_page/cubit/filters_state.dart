part of 'filters_cubit.dart';

class FiltersState extends Equatable {
  const FiltersState({
    this.availableTags = const {},
    this.selectedTags = const {},
    this.minPrice,
    this.selectedMinPrice,
    this.maxPrice,
    this.selectedMaxPrice,
    this.onlyFavorite = false,
  });

  final Set<Tag> availableTags;

  final Set<Tag> selectedTags;

  final double? minPrice;

  final double? selectedMinPrice;

  final double? maxPrice;

  final double? selectedMaxPrice;

  final bool onlyFavorite;

  FiltersState copyWith({
    Set<Tag>? availableTags,
    double? minPrice,
    double? maxPrice,
    Set<Tag> Function()? selectedTags,
    double? Function()? selectedMinPrice,
    double? Function()? selectedMaxPrice,
    bool? onlyFavorite,
  }) =>
      FiltersState(
        availableTags: availableTags ?? this.availableTags,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        selectedTags: selectedTags != null ? selectedTags() : this.selectedTags,
        selectedMinPrice: selectedMinPrice != null
            ? selectedMinPrice()
            : this.selectedMinPrice,
        selectedMaxPrice: selectedMaxPrice != null
            ? selectedMaxPrice()
            : this.selectedMaxPrice,
        onlyFavorite: onlyFavorite ?? this.onlyFavorite,
      );

  @override
  List<Object?> get props => [
        availableTags,
        selectedTags,
        minPrice,
        selectedMinPrice,
        maxPrice,
        selectedMaxPrice,
        onlyFavorite,
      ];
}
