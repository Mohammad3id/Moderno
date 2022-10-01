import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/ui/screens/about_screen/about_screen.dart';
import 'package:moderno/ui/screens/main_screen/main_screen.dart';
import 'package:moderno/ui/screens/wishlist_screen/wishlist_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentScreen;
  const AppDrawer({
    Key? key,
    this.currentScreen = "Home",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "Moderno",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(
                height: 0,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  if (currentScreen == "Home") return;
                  Future.delayed(const Duration(milliseconds: 150)).then((_) {
                    if (ModalRoute.of(context) != null &&
                        !ModalRoute.of(context)!.isFirst) {
                      Navigator.of(context)
                          .removeRouteBelow(ModalRoute.of(context)!);
                      Navigator.pushReplacement(
                        context,
                        FadeInPageRoute(
                          const MainScreen(),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 35,
                  ),
                  child: const Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  if (currentScreen == "Wishlist") return;
                  Future.delayed(const Duration(milliseconds: 150))
                      .then((value) {
                    Navigator.of(context).push(
                      FadeInPageRoute(
                        const WishlistScreen(),
                      ),
                    );
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 35,
                  ),
                  child: const Text(
                    "Wishlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    if (currentScreen == "Contact") return;
                    Future.delayed(const Duration(milliseconds: 150))
                        .then((value) {
                      Navigator.of(context).push(
                        FadeInPageRoute(
                          const AboutScreen(),
                        ),
                      );
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 25,
                    ),
                    child: const Text(
                      "About",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
