import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Practice1MainScreen extends StatelessWidget {
  const Practice1MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ТВ-13 Руденко О.С. ПР 1"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push('/calculator1'),
                child: const Text("Calculator 1"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/calculator2'),
                child: const Text("Calculator 2"),
              ),
            ],
          )
        ),
      ),
    );
  }
}
