import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderno/ui/screens/main_screen/main_screen.dart';

import 'bloc/global_bloc.dart';

class ModernoApp extends StatelessWidget {
  const ModernoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalBloc(),
      child: Builder(builder: (context) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: const Color(0xFF7D98A1),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          home: const MainScreen(),
        );
      }),
    );
  }
}
