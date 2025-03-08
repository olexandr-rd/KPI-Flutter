import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'electrical_loads.dart';

class Practice6MainScreen extends StatefulWidget {
  const Practice6MainScreen({super.key});

  @override
  State<Practice6MainScreen> createState() => _Practice6MainScreenState();
}

class _Practice6MainScreenState extends State<Practice6MainScreen> {
  final TextEditingController nominalPowerController = TextEditingController();
  final TextEditingController utilizationFactorController = TextEditingController();
  final TextEditingController reactivePowerFactorController = TextEditingController();

  List<PowerLoad> powerLoads = [];
  bool isCalculated = false;

  @override
  void dispose() {
    nominalPowerController.dispose();
    utilizationFactorController.dispose();
    reactivePowerFactorController.dispose();
    super.dispose();
  }

  void calculate() {
    double nominalPower = double.tryParse(nominalPowerController.text) ?? 0.0;
    double utilizationFactor = double.tryParse(utilizationFactorController.text) ?? 0.0;
    double reactivePowerFactor = double.tryParse(reactivePowerFactorController.text) ?? 0.0;

    setState(() {
      powerLoads = calculateElectricalLoad(nominalPower, utilizationFactor, reactivePowerFactor);
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
        title: const Text("ТВ-13 Руденко О.С. ПР 6"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nominalPowerController, "Rated Power of Electric Motor (Pₙ, kW)"),
              _buildTextField(utilizationFactorController, "Utilization Factor (Kᵤ)"),
              _buildTextField(reactivePowerFactorController, "Reactive Power Factor (tgφ)"),
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
      padding: const EdgeInsets.only(bottom: 8.0),
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
        const Text("Power Load Calculation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        for (int i = 0; i < powerLoads.length; i++) _buildPowerLoadResults(i, powerLoads[i]),
      ],
    );
  }

  Widget _buildPowerLoadResults(int index, PowerLoad load) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(index == 0 ? "Workshop Network Load:" : "Workshop as a Whole:", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text("Utilization Factor: ${load.utilizationFactor.toStringAsFixed(4)}"),
        Text("Effective Device Count: ${load.effectiveDeviceCount.toStringAsFixed(2)}"),
        Text("Active Power Factor: ${load.activePowerCoefficient.toStringAsFixed(2)}"),
        Text("Active Load: ${load.activeLoad.toStringAsFixed(2)} kW"),
        Text("Reactive Load: ${load.reactiveLoad.toStringAsFixed(2)} kvar"),
        Text("Total Power: ${load.totalPower.toStringAsFixed(2)} kVA"),
        Text("Group Current: ${load.groupCurrent.toStringAsFixed(2)} A"),
      ],
    );
  }
}