import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'gross_emissions.dart';

class Practice2MainScreen extends StatefulWidget {
  const Practice2MainScreen({super.key});

  @override
  State<Practice2MainScreen> createState() => _Practice2MainScreenState();
}

class _Practice2MainScreenState extends State<Practice2MainScreen> {
  final TextEditingController coalController = TextEditingController();
  final TextEditingController mazutController = TextEditingController();
  List<double> grossCalculated = List.filled(4, 0.0);
  bool isCalculated = false;

  @override
  void dispose() {
    coalController.dispose();
    mazutController.dispose();
    super.dispose();
  }

  void calculate() {
    double coalSpent = double.tryParse(coalController.text) ?? 0.0;
    double mazutSpent = double.tryParse(mazutController.text) ?? 0.0;

    setState(() {
      grossCalculated = grossCalculations(coalSpent, mazutSpent);
      isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("ТВ-13 Руденко О.С. ПР 2"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: coalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Coal mass spent (tonne)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: mazutController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Mazut mass spent (tonne)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate"),
              ),
              const SizedBox(height: 16),
              if (isCalculated) ...[
                Text("1.1. Coal emission factor: ${grossCalculated[0]} g/GJ"),
                Text("1.2. Total coal emission: ${grossCalculated[1]} tons"),
                Text("1.3. Mazut emission factor: ${grossCalculated[2]} g/GJ"),
                Text("1.4. Total Mazut emission: ${grossCalculated[3]} tons"),
                const Text("1.5. Gas emission factor: 0 g/GJ"),
                const Text("1.6. Total gas emission: 0 tons"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
