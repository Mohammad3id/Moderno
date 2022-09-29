import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/bloc/home_bloc.dart';
import 'package:moderno/ui/screens/main_screen/pages/home_page/widgets/bundle_of_the_week_section.dart';
import 'package:moderno/ui/screens/main_screen/pages/home_page/widgets/news_swiper.dart';
import 'package:moderno/ui/shared_widgets/products_crads_list.dart';

class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () async {
              BlocProvider.of<HomeBloc>(context).add(HomeReloaded());
            },
            displacement: 50,
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeDataLoadFail) {
                  return Center(
                    child: Text(
                      "Error when loading home page data: ${state.errorMessage}",
                    ),
                  );
                } else if (state is HomeDataLoadSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 75,
                        ),
                        NewsSwiper(
                          news: state.news,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ProductsCradsList(
                          label: "Today's Deals",
                          productBriefs: state.deals,
                        ),
                        if (state.bundleOfTheWeek != null) ...[
                          const SizedBox(
                            height: 15,
                          ),
                          BundleOfTheWeekSection(state.bundleOfTheWeek!),
                        ],
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Featured",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...state.featured.entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: ProductsCradsList(
                                  productBriefs: entry.value,
                                  label: entry.key,
                                  labelListGap: 10,
                                  labelSize: 18,
                                ),
                              ),
                            )
                            .toList(),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
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
          );
        },
      ),
    );
  }
}
