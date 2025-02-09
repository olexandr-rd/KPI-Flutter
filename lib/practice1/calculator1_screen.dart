import 'package:flutter/material.dart';
import 'lower_heating_value.dart';

class Calculator1Screen extends StatefulWidget {
  const Calculator1Screen({super.key});

  @override
  Calculator1ScreenState createState() => Calculator1ScreenState();
}

class Calculator1ScreenState extends State<Calculator1Screen> {
  final List<String> inputLabels = [
    "Hydrogen (H)", "Carbon (C)", "Sulfur (S)", "Nitrogen (N)",
    "Oxygen (O)", "Water (W)", "Ash (A)"
  ];

  final List<TextEditingController> controllers =
  List.generate(7, (index) => TextEditingController());

  double massFactorDry = 0.0;
  double massFactorDAF = 0.0;
  double lowerHeatingValue = 0.0;
  double lowerHeatingValueDry = 0.0;
  double lowerHeatingValueDAF = 0.0;

  void calculate() {
    // Отримання значень
    double h = double.tryParse(controllers[0].text) ?? 0.0;
    double c = double.tryParse(controllers[1].text) ?? 0.0;
    double s = double.tryParse(controllers[2].text) ?? 0.0;
    double n = double.tryParse(controllers[3].text) ?? 0.0;
    double o = double.tryParse(controllers[4].text) ?? 0.0;
    double w = double.tryParse(controllers[5].text) ?? 0.0;
    double a = double.tryParse(controllers[6].text) ?? 0.0;

    // Створюємо об'єкт палива
    WorkingFuel fuel = WorkingFuel(h: h, c: c, s: s, n: n, o: o, w: w, a: a);

    // Обчислення
    setState(() {
      massFactorDry = getMassFactor(w);
      massFactorDAF = getMassFactor(w, a);
      lowerHeatingValue = getLowerHeatingValue(fuel);
      lowerHeatingValueDry = getAdjustedLowerHeatingValue(fuel, lowerHeatingValue, massFactorDry);
      lowerHeatingValueDAF = getAdjustedLowerHeatingValue(fuel, lowerHeatingValue, massFactorDAF);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Calculator 1"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < inputLabels.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: TextField(
                    controller: controllers[i],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: inputLabels[i],
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: i == inputLabels.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate"),
              ),
              const SizedBox(height: 16),
              Text("Mass Factor Dry: ${round(massFactorDry, decimals: 2)}"),
              Text("Mass Factor DAF: ${round(massFactorDAF, decimals: 2)}"),
              const SizedBox(height: 16),
              Text("Lower Heating Value: ${round(lowerHeatingValue, decimals: 2)} MJ/kg"),
              Text("LHV Dry: ${round(lowerHeatingValueDry, decimals: 2)} MJ/kg"),
              Text("LHV Dry Ash-Free: ${round(lowerHeatingValueDAF, decimals: 2)} MJ/kg"),
            ],
          ),
        ),
      ),
    );
  }
}
