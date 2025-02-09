import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'lower_heating_value.dart'; // Імпортуємо функції обчислень

class Calculator2Screen extends StatefulWidget {
  const Calculator2Screen({super.key});

  @override
  Calculator2ScreenState createState() => Calculator2ScreenState();
}

class Calculator2ScreenState extends State<Calculator2Screen> {
  final List<String> inputLabels = [
    "Carbon (C, %)", "Hydrogen (H, %)", "Oxygen (O, %)",
    "Sulfur (S, %)", "Water (W, %)", "Ash (A, %)",
    "Vanadium (V, mg/kg)", "DAF Value (MJ/kg)"
  ];

  final List<TextEditingController> controllers =
  List.generate(8, (index) => TextEditingController());

  CombustibleFuel? fuelMass;
  double? lhvFromDAF;

  void calculate() {
    // Отримання значень
    double c = double.tryParse(controllers[0].text) ?? 0.0;
    double h = double.tryParse(controllers[1].text) ?? 0.0;
    double o = double.tryParse(controllers[2].text) ?? 0.0;
    double s = double.tryParse(controllers[3].text) ?? 0.0;
    double w = double.tryParse(controllers[4].text) ?? 0.0;
    double a = double.tryParse(controllers[5].text) ?? 0.0;
    double v = double.tryParse(controllers[6].text) ?? 0.0;
    double dafValue = double.tryParse(controllers[7].text) ?? 0.0;

    // Створюємо об'єкт палива
    CombustibleFuel fuel = CombustibleFuel(
      c: c, h: h, o: o, s: s, w: w, a: a, v: v,
    );

    // Обчислення
    setState(() {
      fuelMass = fuel.getMassFromDAF();
      lhvFromDAF = getLowerHeatingValueFromDAF(fuel, dafValue);
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
        title: const Text("Calculator 2"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < inputLabels.length; i++)
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
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate"),
              ),
              const SizedBox(height: 16.0),
              if (fuelMass != null) ...[
                const Text("Calculated Fuel Mass:"),
                Text("Carbon: ${round(fuelMass!.c, decimals: 2)}%"),
                Text("Hydrogen: ${round(fuelMass!.h, decimals: 2)}%"),
                Text("Oxygen: ${round(fuelMass!.o, decimals: 2)}%"),
                Text("Sulfur: ${round(fuelMass!.s, decimals: 2)}%"),
                Text("Water: ${round(fuelMass!.w, decimals: 2)}%"),
                Text("Ash: ${round(fuelMass!.a, decimals: 2)}%"),
                Text("Vanadium: ${round(fuelMass!.v, decimals: 2)} mg/kg"),
                const SizedBox(height: 16.0),
              ],
              if (lhvFromDAF != null)
                Text("LHV from DAF: ${round(lhvFromDAF!, decimals: 2)} MJ/kg"),
            ],
          ),
        ),
      ),
    );
  }
}
