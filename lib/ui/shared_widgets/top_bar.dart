import 'package:flutter/material.dart';
import 'package:moderno/shared_functionality/fade_in_page_route.dart';
import 'package:moderno/ui/screens/search_screen/search_screen.dart';

class TopBar extends StatefulWidget {
  final String? currentText;
  final bool isInSearchPage;
  const TopBar({
    Key? key,
    this.currentText,
    this.isInSearchPage = false,
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final _focusNode = FocusNode();
  late final TextEditingController _searchBarController;

  @override
  void initState() {
    _searchBarController = TextEditingController(text: widget.currentText);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                iconSize: 30,
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchBarController,
                          focusNode: _focusNode,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          onSubmitted: (searchText) {
                            if (searchText.trim().isEmpty) return;

                            if (widget.isInSearchPage) {
                              Navigator.of(context).pushReplacement(
                                FadeInPageRoute(
                                  SearchScreen(searchText: searchText.trim()),
                                ),
                              );
                            } else {
                              Navigator.of(context)
                                  .push(
                                FadeInPageRoute(
                                  SearchScreen(searchText: searchText.trim()),
                                ),
                              )
                                  .then((value) {
                                _searchBarController.clear();
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: "Search Moderno",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(127, 255, 255, 255),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: _focusNode.hasFocus
                            ? Colors.white
                            : const Color.fromARGB(127, 255, 255, 255),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
