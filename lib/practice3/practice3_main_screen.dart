import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'profit_calculations.dart';

class Practice3MainScreen extends StatefulWidget {
  const Practice3MainScreen({super.key});

  @override
  State<Practice3MainScreen> createState() => _Practice3MainScreenState();
}

class _Practice3MainScreenState extends State<Practice3MainScreen> {
  final TextEditingController meanPowerController = TextEditingController();
  final TextEditingController initialStdDevController = TextEditingController();
  final TextEditingController improvedStdDevController = TextEditingController();
  final TextEditingController energyPriceController = TextEditingController();

  List<double> netProfit = List.filled(2, 0.0);
  bool isCalculated = false;

  @override
  void dispose() {
    meanPowerController.dispose();
    initialStdDevController.dispose();
    improvedStdDevController.dispose();
    energyPriceController.dispose();
    super.dispose();
  }

  void calculate() {
    double meanPower = double.tryParse(meanPowerController.text) ?? 0.0;
    double initialStdDev = double.tryParse(initialStdDevController.text) ?? 0.0;
    double improvedStdDev = double.tryParse(improvedStdDevController.text) ?? 0.0;
    double energyPrice = double.tryParse(energyPriceController.text) ?? 0.0;

    setState(() {
      netProfit = calculateProfit(meanPower, initialStdDev, improvedStdDev, energyPrice);
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
        title: const Text("ТВ-13 Руденко О.С. ПР 3"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: meanPowerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Mean Power (MW)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: initialStdDevController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Initial Standard Deviation",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: improvedStdDevController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Improved Standard Deviation",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: energyPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Energy Price (UAH/kWh)",
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
                Text("Profit before improvement: ${netProfit[0].toStringAsFixed(2)} thousand UAH"),
                Text("Profit after improvement: ${netProfit[1].toStringAsFixed(2)} thousand UAH"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
