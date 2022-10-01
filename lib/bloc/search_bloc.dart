import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/repositories/product_repository.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';
import 'package:moderno/data/repositories/wishlist_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _productRepository = ProductRepository.instance;
  final _wishlistRepository = WishlistRepository.instance;
  final String searchText;
  SearchBloc(this.searchText) : super(SearchInitial()) {
    on<SearchInitialized>(_onSearchInitialized);
    on<SearchResultsListScrollApproachedEnd>(
        _onSearchResultsListScrollApproachedEnd);
    on<SearchProductAddedToWishlist>(_onSearchProductAddedToWishlist);
    on<SearchProductRemovedFromWishlist>(_onSearchProductRemovedFromWishlist);
    add(SearchInitialized(searchText));
  }

  FutureOr<void> _onSearchInitialized(
      SearchInitialized event, Emitter<SearchState> emit) async {
    emit(SearchLoadInProgress());
    await Future.delayed(const Duration(seconds: 1));
    try {
      final searchResults =
          await _productRepository.searchProducts(event.searchText);
      emit(
        SearchLoadSuccess(
          await Future.wait(
            searchResults
                .map(
                  (product) async => ProductInfo(
                    id: product.id,
                    name: product.name,
                    stockStatus: product.stockStatus,
                    imageUrl: product.imagesUrls.first,
                    isWishlisted: await _wishlistRepository
                        .isProductWishlisted(product.id),
                    price: product.price,
                    priceBeforeDiscount: product.priceBeforeDiscount,
                    isBundle: product is Bundle,
                  ),
                )
                .toList(),
          ),
        ),
      );
    } on RepositoryException catch (e) {
      emit(SearchLoadFail(e.message));
    }
  }

  FutureOr<void> _onSearchResultsListScrollApproachedEnd(
    SearchResultsListScrollApproachedEnd event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchResultsState) {
      final castedState = state as SearchResultsState;
      if (state is SearchLoadMoreInProgress) return;
      emit(SearchLoadMoreInProgress(
        castedState.searchResults,
      ));
      try {
        final newSearchResults = await _productRepository.searchProducts(
          searchText,
          startSearchingFromProductId: castedState.searchResults.last.id,
        );

        if (newSearchResults.isEmpty) {
          emit(SearchNoMoreResults(castedState.searchResults));
          return;
        }

        emit(
          SearchLoadSuccess(
            castedState.searchResults
              ..addAll(
                await Future.wait(newSearchResults.map(
                  (product) async => ProductInfo(
                    id: product.id,
                    name: product.name,
                    stockStatus: product.stockStatus,
                    imageUrl: product.imagesUrls.first,
                    isWishlisted: await _wishlistRepository
                        .isProductWishlisted(product.id),
                    price: product.price,
                    priceBeforeDiscount: product.priceBeforeDiscount,
                    isBundle: product is Bundle,
                  ),
                )),
              ),
          ),
        );
      } on RepositoryException catch (e) {
        emit(SearchLoadFail(e.message));
      }
    }
  }

  FutureOr<void> _onSearchProductAddedToWishlist(
    SearchProductAddedToWishlist event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _wishlistRepository.addProductToWishlist(
          productId: event.wishlistedProductId);
      emit(SearchInterationSuccess(
        "Product added to wishlist.",
        (state as SearchResultsState).searchResults,
      ));
    } on WishlistRepositoryException catch (e) {
      emit(SearchInterationFail(
        e.message,
        (state as SearchResultsState).searchResults,
      ));
    }
  }

  FutureOr<void> _onSearchProductRemovedFromWishlist(
    SearchProductRemovedFromWishlist event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _wishlistRepository.removeProductFromWishlist(
        productId: event.wishlistedProductId,
      );
      emit(SearchInterationSuccess(
        "Product removed from wishlist.",
        (state as SearchResultsState).searchResults,
      ));
    } on WishlistRepositoryException catch (e) {
      emit(SearchInterationFail(
        "Error occured: ${e.message}",
        (state as SearchResultsState).searchResults,
      ));
    }
  }
}

// Events
abstract class SearchEvent {}

class SearchInitialized extends SearchEvent {
  final String searchText;

  SearchInitialized(this.searchText);
}

class SearchResultsListScrollApproachedEnd extends SearchEvent {}

class SearchProductAddedToWishlist extends SearchEvent {
  final String wishlistedProductId;

  SearchProductAddedToWishlist(this.wishlistedProductId);
}

class SearchProductRemovedFromWishlist extends SearchEvent {
  final String wishlistedProductId;

  SearchProductRemovedFromWishlist(this.wishlistedProductId);
}

// States
abstract class SearchState {}

abstract class SearchInProgressState extends SearchState {}

abstract class SearchResultsState extends SearchState {
  final List<ProductInfo> searchResults;

  SearchResultsState(this.searchResults);
}

abstract class SearchFailState {}

abstract class SearchNotificationState extends SearchState {
  final String message;

  SearchNotificationState(this.message);
}

class SearchInitial extends SearchState {}

class SearchLoadInProgress extends SearchInProgressState {}

class SearchLoadSuccess extends SearchResultsState {
  SearchLoadSuccess(super.searchResults);
}

class SearchLoadFail extends SearchFailState
    implements SearchNotificationState {
  @override
  final String message;
  SearchLoadFail(this.message);
}

class SearchLoadMoreInProgress extends SearchResultsState
    implements SearchInProgressState {
  SearchLoadMoreInProgress(super.searchResults);
}

class SearchLoadMoreSuccess extends SearchResultsState {
  SearchLoadMoreSuccess(super.searchResults);
}

class SearchNoMoreResults extends SearchResultsState {
  SearchNoMoreResults(super.searchResults);
}

class SearchLoadMoreFail extends SearchResultsState
    implements SearchNotificationState, SearchFailState {
  @override
  final String message;
  SearchLoadMoreFail(this.message, super.searchResults);
}

class SearchInterationSuccess extends SearchResultsState
    implements SearchNotificationState {
  SearchInterationSuccess(this.message, super.searchResults);

  @override
  final String message;
}

class SearchInterationFail extends SearchResultsState
    implements SearchNotificationState {
  @override
  final String message;
  SearchInterationFail(
    this.message,
    super.searchResults,
  );
}
