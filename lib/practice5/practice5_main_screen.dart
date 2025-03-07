import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'reliability_and_losses.dart';

class Practice5MainScreen extends StatefulWidget {
  const Practice5MainScreen({super.key});

  @override
  State<Practice5MainScreen> createState() => _Practice5MainScreenState();
}

class _Practice5MainScreenState extends State<Practice5MainScreen> {
  final TextEditingController linesLengthController = TextEditingController();
  final TextEditingController connectionsController = TextEditingController();
  final TextEditingController emergencyOutagesLossesController = TextEditingController();
  final TextEditingController plannedOutagesLossesController = TextEditingController();

  List<double> failureRates = [0.0, 0.0];
  String moreReliableSystem = "";
  int losses = 0;
  bool isCalculated = false;

  @override
  void dispose() {
    linesLengthController.dispose();
    connectionsController.dispose();
    emergencyOutagesLossesController.dispose();
    plannedOutagesLossesController.dispose();
    super.dispose();
  }

  void calculate() {
    double linesLength = double.tryParse(linesLengthController.text) ?? 0.0;
    double connections = double.tryParse(connectionsController.text) ?? 0.0;
    double emergencyOutagesLosses = double.tryParse(emergencyOutagesLossesController.text) ?? 0.0;
    double plannedOutagesLosses = double.tryParse(plannedOutagesLossesController.text) ?? 0.0;

    setState(() {
      failureRates = calculateFailureRates(linesLength, connections);
      moreReliableSystem = checkMoreReliableSystem(failureRates);
      losses = getLosses(emergencyOutagesLosses, plannedOutagesLosses);
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
        title: const Text("ТВ-13 Руденко О.С. ПР 5"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(linesLengthController, "Length of power transmission lines (km)"),
              _buildTextField(connectionsController, "Number of connections"),
              _buildTextField(emergencyOutagesLossesController, "Emergency outages specific losses (UAH/kW·h)"),
              _buildTextField(plannedOutagesLossesController, "Planned outages specific losses (UAH/kW·h)"),
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
        const Text("Systems reliability", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("Failure rate of a single-circuit system: ${failureRates[0].toStringAsFixed(4)} year⁻¹"),
        const SizedBox(height: 8),
        Text("Failure rate of a double-circuit system (with breaker): ${failureRates[1].toStringAsFixed(4)} year⁻¹"),
        const SizedBox(height: 8),
        Text("System that is more reliable: $moreReliableSystem"),
        const SizedBox(height: 16),
        const Text("Losses estimation due to power supply interruptions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text("Losses: $losses UAH"),
      ],
    );
  }
}