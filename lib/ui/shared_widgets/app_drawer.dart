import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
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
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  if (currentScreen == "Home") return;
                  Future.delayed(const Duration(milliseconds: 150)).then((_) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(
                      FadeInPageRoute(
                        const MainScreen(),
                      ),
                    );
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
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
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              GestureDetector(
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
                    vertical: 15,
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
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 35,
                ),
                child: const Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 35,
                  ),
                  child: const Text(
                    "By Mohammad Eid",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
