import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final _focusNode = FocusNode();

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
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              iconSize: 30,
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).primaryColor,
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
                          focusNode: _focusNode,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
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
