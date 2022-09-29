import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:moderno/bloc/global_bloc.dart';
import 'package:moderno/bloc/user_bloc.dart';
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
                elevated: !(state is UserGuest && _pageIndex == 2),
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
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        height: 85,
                        child: AnimatedOpacity(
                          opacity:
                              (state is UserGuest && _pageIndex == 2) ? 0 : 1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                          child: const TopBar(),
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
