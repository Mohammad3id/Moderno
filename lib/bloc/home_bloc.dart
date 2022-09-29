import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:moderno/data/models/news.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/data/repositories/news_repository.dart';
import 'package:moderno/data/repositories/product_repository.dart';
import 'package:moderno/data/repositories/shared/repository_exception.dart';
import 'package:moderno/data/repositories/wishlist_repository.dart';
import 'package:moderno/shared_functionality/format_enum.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _productRepository = ProductRepository.instance;
  final _newsRepository = NewsRepository.instance;
  final _wishlistRepository = WishlistRepository.instance;

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeReloaded>(_onHomeRealoaded);
    on<HomeReturnedFromProductScreen>(_onHomeReturnedFromProductScreen);
    add(HomeInitialized());
  }

  FutureOr<void> _onHomeInitialized(
      HomeInitialized event, Emitter<HomeState> emit) async {
    emit(HomeDataLoadInProgress());
    emit(await _loadHomeState());
  }

  FutureOr<void> _onHomeRealoaded(
      HomeReloaded event, Emitter<HomeState> emit) async {
    emit(HomeDataReloadInProgress());
    await Future.delayed(const Duration(seconds: 1));
    emit(await _loadHomeState());
  }

  FutureOr<HomeState> _loadHomeState() async {
    try {
      final news = await _newsRepository.getNews();
      final deals = await _productRepository.getDeals();
      final featuredProducts = await _productRepository.getFeaturedProducts();

      final Map<String, List<ProductBrief>> featured = {};

      for (final category in featuredProducts.keys) {
        if (featuredProducts[category]!.isEmpty) continue;
        final name = formateEnum(category);
        featured[name] = await Future.wait(featuredProducts[category]!
            .map(
              (product) async => ProductBrief(
                  id: product.id,
                  imageUrl: product.imagesUrls[0],
                  isWishlisted:
                      await _wishlistRepository.isProductWishlisted(product.id),
                  price: product.price,
                  priceBeforDiscount: product.priceBeforeDiscount),
            )
            .toList());
      }

      final bundleOfTheWeek = await _productRepository.getBundleOfTheWeek();

      return HomeDataLoadSuccess(
        news: news,
        featured: featured,
        bundleOfTheWeek: bundleOfTheWeek,
        deals: await Future.wait(deals
            .map(
              (product) async => ProductBrief(
                id: product.id,
                imageUrl: product.imagesUrls.first,
                isWishlisted: await _wishlistRepository.isProductWishlisted(
                  product.id,
                ),
                price: product.price,
                priceBeforDiscount: product.priceBeforeDiscount,
              ),
            )
            .toList()),
      );
    } on RepositoryException catch (e) {
      return HomeDataLoadFail(e.message);
    } catch (e) {
      return HomeDataLoadFail("Unkown error: $e");
    }
  }

  FutureOr<void> _onHomeReturnedFromProductScreen(
    HomeReturnedFromProductScreen event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeDataLoadSuccess) return null;
    final castedState = state as HomeDataLoadSuccess;
    emit(
      HomeDataLoadSuccess(
        news: castedState.news,
        deals: castedState.deals,
        featured: castedState.featured,
      ),
    );
  }
}

// Events
abstract class HomeEvent {}

class HomeInitialized extends HomeEvent {}

class HomeReloaded extends HomeEvent {}

class HomeReturnedFromProductScreen extends HomeEvent {}

// States
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeDataLoadInProgress extends HomeState {}

class HomeDataReloadInProgress extends HomeState {}

class HomeDataLoadFail extends HomeState {
  final String errorMessage;

  HomeDataLoadFail(this.errorMessage);
}

class HomeDataLoadSuccess extends HomeState {
  final List<News> news;
  final List<ProductBrief> deals;
  final Map<String, List<ProductBrief>> featured;
  final Bundle? bundleOfTheWeek;

  HomeDataLoadSuccess({
    required this.news,
    required this.deals,
    required this.featured,
    this.bundleOfTheWeek,
  });
}
