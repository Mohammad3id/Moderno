import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/search_bloc.dart';
import 'package:moderno/data/models/product.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:moderno/ui/shared_widgets/product_info_tile.dart';
import 'package:moderno/ui/shared_widgets/top_bar.dart';

class SearchScreen extends StatefulWidget {
  final String searchText;

  const SearchScreen({super.key, required this.searchText});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _loadedAllResults = false;
  bool _loadingMoreResults = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: AppBottomNavigationBar.outsideMainScreen(),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 85,
            child: TopBar(currentText: widget.searchText, isInSearchPage: true),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => SearchBloc(widget.searchText),
              child: BlocConsumer<SearchBloc, SearchState>(
                listener: (context, state) {
                  if (state is SearchNotificationState) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  if (state is SearchLoadMoreInProgress) {
                    setState(() {
                      _loadingMoreResults = true;
                    });
                  } else {
                    setState(() {
                      _loadingMoreResults = false;
                    });
                  }

                  if (state is SearchNoMoreResults ||
                      state is SearchLoadMoreFail) {
                    setState(() {
                      _loadedAllResults = true;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is SearchLoadFail) {
                    return Center(
                      child: Text("Error occured: ${state.message}"),
                    );
                  } else if (state is SearchResultsState) {
                    if (state.searchResults.isEmpty) {
                      return const Center(
                        child: Text("No Results"),
                      );
                    }
                    print(state.searchResults.length);
                    return SearchResultsList(
                      loadMoreCondition: !(_loadedAllResults ||
                          _loadingMoreResults ||
                          state.searchResults.length < 3),
                      searchResults: state.searchResults,
                      onApproachingListEnd: () {
                        BlocProvider.of<SearchBloc>(context)
                            .add(SearchResultsListScrollApproachedEnd());
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResultsList extends StatefulWidget {
  final List<ProductInfo> searchResults;
  final void Function() onApproachingListEnd;
  final bool loadMoreCondition;
  const SearchResultsList({
    Key? key,
    required this.searchResults,
    required this.onApproachingListEnd,
    required this.loadMoreCondition,
  }) : super(key: key);

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 5,
        bottom: 60,
      ),
      itemCount: widget.searchResults.length,
      itemBuilder: (context, index) {
        if (index > widget.searchResults.length - 3 &&
            widget.loadMoreCondition) {
          widget.onApproachingListEnd();
        }
        final product = widget.searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ProductInfoTile(
            product: product,
            onFavIconPressed: (isWishlisted) {
              if (isWishlisted) {
                BlocProvider.of<SearchBloc>(context).add(
                  SearchProductAddedToWishlist(product.id),
                );
              } else {
                BlocProvider.of<SearchBloc>(context).add(
                  SearchProductRemovedFromWishlist(product.id),
                );
              }
            },
          ),
        );
      },
    );
  }
}
