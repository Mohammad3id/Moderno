import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
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
              Future.delayed(const Duration(milliseconds: 150)).then((value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WishlistScreen(),
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
              "Support",
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 35,
            ),
            child: const Text(
              "Settings",
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
    );
  }
}
