import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/global_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';
import 'package:moderno/shared_functionality/curves_with_delay.dart';
import 'package:moderno/ui/screens/main_screen/pages/cart_page/cart_page.dart';
import 'package:moderno/ui/screens/main_screen/pages/home_page/home_page.dart';
import 'package:moderno/ui/screens/main_screen/pages/profile_page/profile_page.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:moderno/ui/shared_widgets/top_bar.dart';

class MainScreen extends StatefulWidget {
  final int initialPageIndex;
  const MainScreen({super.key}) : initialPageIndex = 0;
  const MainScreen.withInitialPageIndex(this.initialPageIndex, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  final FocusNode _focusNode = FocusNode();
  late final StreamSubscription _keyboardVisibilitySubscription;

  var _pageIndex = 0;

  @override
  void initState() {
    _pageIndex = widget.initialPageIndex;
    _pageController = PageController(initialPage: _pageIndex);
    final keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardVisibilitySubscription =
        keyboardVisibilityController.onChange.listen((isKeyboardVisible) {
      if (!isKeyboardVisible) {
        FocusScope.of(context).requestFocus(_focusNode);
        _focusNode.unfocus();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _keyboardVisibilitySubscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: BlocProvider(
        create: (context) => UserBloc(),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Scaffold(
              extendBody: true,
              bottomNavigationBar: AppBottomNavigationBar(
                elevated: !(state is! UserLoginSuccess && _pageIndex == 2),
                pageController: _pageController,
                pageIndex: _pageIndex,
              ),
              drawer: const AppDrawer(),
              body: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    BlocProvider.of<GlobalBloc>(context)
                        .add(GlobalPageReloaded());
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: BlocListener<GlobalBloc, GlobalState>(
                          listener: (context, state) {
                            if (state is GlobalGoToProfilePage) {
                              _pageController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              BlocProvider.of<UserBloc>(context)
                                  .add(UserReloaded());
                              setState(() {
                                _pageIndex = index;
                              });
                            },
                            children: [
                              HomePage(),
                              CartPage(),
                              ProfilePage(
                                userBloc: BlocProvider.of<UserBloc>(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        left: 0,
                        width: (state is! UserLoginSuccess && _pageIndex == 2)
                            ? 0
                            : MediaQuery.of(context).size.width,
                        top: 0,
                        height: 85,
                        duration: (state is UserLoginSuccess)
                            ? const Duration(milliseconds: 300)
                            : (state is! UserLoginSuccess && _pageIndex == 2)
                                ? const Duration(milliseconds: 200)
                                : Duration.zero,
                        curve: (state is! UserLoginSuccess && _pageIndex == 2)
                            ? const CurveWithDelay(
                                curve: Curves.ease, delayRatio: 1)
                            : Curves.ease,
                        child: AnimatedOpacity(
                          opacity:
                              ((state is! UserLoginSuccess) && _pageIndex == 2)
                                  ? 0
                                  : 1,
                          duration: (state is UserLoginSuccess)
                              ? Duration.zero
                              : const Duration(milliseconds: 200),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                width: MediaQuery.of(context).size.width,
                                child: const TopBar(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
