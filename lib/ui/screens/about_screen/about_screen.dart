import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moderno/ui/shared_widgets/app_bottom_navigation_bar.dart';
import 'package:moderno/ui/shared_widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentScreen: "Contact"),
      bottomNavigationBar: AppBottomNavigationBar.outsideMainScreen(
        elevated: false,
      ),
      extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 85,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        iconSize: 30,
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 160,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Moderno",
                      style: GoogleFonts.montserrat(
                        fontSize: 50,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "By Mohammad Eid",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        height: 0.5,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Hi folks, developer of Moderno speaking. I made this app to showcase my skills as a developer. I hope you liked it :)",
                  // style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Contacts",
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "LinkedIn",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () async {
                            launchUrl(
                              Uri.parse(
                                "https://www.linkedin.com/in/mohammad-eid-65043021a/",
                              ),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.open_in_new),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Facebook",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () async {
                            launchUrl(
                              Uri.parse(
                                "https://www.facebook.com/mohammad.eid.7355",
                              ),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.open_in_new),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "eid115599@gmail.com",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () async {
                            launchUrl(
                              Uri.parse(
                                "mailto:eid115599@gmail.com",
                              ),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.open_in_new),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
