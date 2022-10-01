import 'package:flutter/material.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/ui/screens/main_screen/main_screen.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final bool isInMainScreen;
  final bool elevated;
  const AppBottomNavigationBar({
    super.key,
    required this.pageIndex,
    required this.pageController,
    this.elevated = true,
  }) : isInMainScreen = true;

  AppBottomNavigationBar.outsideMainScreen({super.key, this.elevated = true})
      : pageIndex = 0,
        pageController = PageController(),
        isInMainScreen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          if (elevated)
            const BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              offset: Offset(0, -4),
              blurRadius: 4,
            ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_sharp), label: ""),
        ],
        onTap: (index) {
          if (isInMainScreen) {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          } else {
            if (ModalRoute.of(context) != null &&
                !ModalRoute.of(context)!.isFirst) {
              Navigator.of(context).removeRouteBelow(ModalRoute.of(context)!);
              Navigator.pushReplacement(
                context,
                FadeInPageRoute(
                  MainScreen.withInitialPageIndex(index),
                ),
              );
            }
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: isInMainScreen
            ? const IconThemeData(color: Colors.white, opacity: 1, size: 27)
            : const IconThemeData(color: Colors.white, opacity: 0.5, size: 27),
        unselectedIconTheme:
            const IconThemeData(color: Colors.white, opacity: 0.5, size: 27),
      ),
    );
  }
}
