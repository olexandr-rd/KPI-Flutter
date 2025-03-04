import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'electric_current.dart';

class Practice4MainScreen extends StatefulWidget {
  const Practice4MainScreen({super.key});

  @override
  State<Practice4MainScreen> createState() => _Practice4MainScreenState();
}

class _Practice4MainScreenState extends State<Practice4MainScreen> {
  final TextEditingController shortCircuitCurrentController = TextEditingController();
  final TextEditingController fictionTimeOffController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController rController = TextEditingController();
  final TextEditingController rMinController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController xMinController = TextEditingController();

  double minConductorSize = 0.0;
  double initialCurrent = 0.0;
  List<List<double>> current = List.generate(3, (_) => [0.0, 0.0]);
  bool isCalculated = false;

  @override
  void dispose() {
    shortCircuitCurrentController.dispose();
    fictionTimeOffController.dispose();
    powerController.dispose();
    rController.dispose();
    rMinController.dispose();
    xController.dispose();
    xMinController.dispose();
    super.dispose();
  }

  void calculate() {
    double shortCircuitCurrent = double.tryParse(shortCircuitCurrentController.text) ?? 0.0;
    double fictionTimeOff = double.tryParse(fictionTimeOffController.text) ?? 0.0;
    double power = double.tryParse(powerController.text) ?? 0.0;
    double r = double.tryParse(rController.text) ?? 0.0;
    double rMin = double.tryParse(rMinController.text) ?? 0.0;
    double x = double.tryParse(xController.text) ?? 0.0;
    double xMin = double.tryParse(xMinController.text) ?? 0.0;

    setState(() {
      minConductorSize = getMinConductorSize(shortCircuitCurrent, fictionTimeOff);
      initialCurrent = getInitialCurrent(power);
      current = calculateCurrent([r, rMin, x, xMin]);
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
        title: const Text("ТВ-13 Руденко О.С. ПР 4"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(shortCircuitCurrentController, "Short Circuit Current (A)"),
              _buildTextField(fictionTimeOffController, "Fiction Time Off (seconds)"),
              _buildTextField(powerController, "Power (MVA)"),
              _buildTextField(rController, "R (Ohm)"),
              _buildTextField(xController, "X (Ohm)"),
              _buildTextField(rMinController, "R min (Ohm)"),
              _buildTextField(xMinController, "X min (Ohm)"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculate,
                child: const Text("Calculate"),
              ),
              const SizedBox(height: 16),
              if (isCalculated) _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Minimal Conductor Size for thermal stability:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("${minConductorSize.toStringAsFixed(2)} mm"),
        const SizedBox(height: 16),
        const Text("Short-circuit current calculation in 10 (6) kV networks:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("Short-circuit currents at the 10 kV bus bars of the substation: ${initialCurrent.toStringAsFixed(2)} kA"),
        const SizedBox(height: 16),
        const Text("Short-circuit currents for the substation of KhnEM:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        _printList("Short-circuit currents on 10 kV bus bars referred to 110 kV voltage", current[0]),
        _printList("Actual short-circuit currents on 10 kV bus bars", current[1]),
        _printList("Short-circuit currents of outgoing 10 kV lines", current[2]),
      ],
    );
  }

  Widget _printList(String title, List<double> values) {
    const labels = ["I(3)", "I(2)", "I(3)min", "I(2)min"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        for (int i = 0; i < values.length; i++) Text("${labels[i]} = ${values[i].toStringAsFixed(2)}"),
        const Text("The emergency mode is not envisaged"),
      ],
    );
  }
}
