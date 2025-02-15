import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'practice1/practice1_main_screen.dart';
import 'practice1/calculator1_screen.dart';
import 'practice1/calculator2_screen.dart';
import 'practice2/practice2_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// Налаштування маршрутизації
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/practice1',
      builder: (context, state) => const Practice1MainScreen(),
    ),
    GoRoute(
      path: '/calculator1',
      builder: (context, state) => const Calculator1Screen(),
    ),
    GoRoute(
      path: '/calculator2',
      builder: (context, state) => const Calculator2Screen(),
    ),
    GoRoute(
      path: '/practice2',
      builder: (context, state) => const Practice2MainScreen(),
    ),
  ],
);


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Ensures horizontal centering
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Keeps content aligned to the top
            crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
            children: [
              const Text(
                'ТВ-13 Руденко Олександр',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Ensures text is centered
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Practice',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Ensures text is centered
              ),
              const SizedBox(height: 16),
              ...List.generate(6, (index) => PracticeButton(index: index + 1)),
            ],
          ),
        ),
      ),
    );
  }
}


class PracticeButton extends StatelessWidget {
  final int index;

  const PracticeButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          if (index <= 2) { // Відкриває Practice 1-2
            context.push('/practice$index');
          }
        },
        child: Text('Go to Practice $index'),
      ),
    );
  }
}
