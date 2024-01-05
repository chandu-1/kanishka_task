import 'package:flutter_hooks/flutter_hooks.dart';
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:kanishka_task/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Eats For Me',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Homepage(),
      ),
    );
  }
}
