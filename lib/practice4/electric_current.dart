import 'dart:math';

// Constants
const double thermalCoefficient = 92.0;
const double nominalVoltage = 10.5;
const double averageVoltage = 10.5;
const double nominalPower = 6.3;
const double lowVoltage = 11.0;
const double highVoltage = 115.0;
const double maxFaultVoltage = 11.1;
const double reactance = (maxFaultVoltage * highVoltage * highVoltage) / (100 * nominalPower);
const double conversionFactor = (lowVoltage * lowVoltage) / (highVoltage * highVoltage);
const double cableLength = 12.37;
final List<double> cableResistance = [cableLength * 0.64, cableLength * 0.363];
final double rootOf3 = sqrt(3);

// Utility function for rounding
double round(double value, {int decimals = 2}) {
  double multiplier = pow(10, decimals).toDouble();
  return (value * multiplier).round() / multiplier;
}

// Function to calculate minimum conductor size
double getMinConductorSize(double shortCircuitCurrent, double fictionTimeOff) {
  return round((shortCircuitCurrent * sqrt(fictionTimeOff)) / thermalCoefficient);
}

// Function to calculate resistance
double getResistance(double power) {
  double x1 = round(pow(nominalVoltage, 2) / power);
  double x2 = round((averageVoltage / 100) * pow(nominalVoltage, 2) / nominalPower);
  return x1 + x2;
}

// Function to calculate initial current
double getInitialCurrent(double power) {
  return round(nominalVoltage / rootOf3 / getResistance(power));
}

// Function to calculate resistance sum
List<double> getResistanceSum(List<double> resistances) {
  return List.generate(resistances.length ~/ 2, (i) {
    return round(sqrt(pow(resistances[i * 2], 2) + pow(resistances[i * 2 + 1], 2)));
  });
}

// Function to calculate I(3) and I(2) currents
List<double> getCurrent3and2(double voltage, List<double> resistanceSum) {
  return resistanceSum.expand((sum) {
    double current3 = round(voltage * 1000.0 / rootOf3 / sum);
    double current2 = round(current3 * rootOf3 / 2);
    return [current3, current2];
  }).toList();
}

// Function to calculate all short-circuit currents
List<List<double>> calculateCurrent(List<double> initResistances) {
  // Add reactance to alternate indices
  List<double> resistances = List.generate(initResistances.length, (index) {
    return initResistances[index] + (index % 2 != 0 ? reactance : 0.0);
  });

  List<double> resistanceSum = getResistanceSum(resistances);
  List<double> current3and2 = getCurrent3and2(highVoltage, resistanceSum);

  // Update resistances using conversion factor
  List<double> updatedResistances = resistances.map((r) => r * conversionFactor).toList();
  List<double> updatedResistanceSum = getResistanceSum(updatedResistances);
  List<double> updatedCurrent3and2 = getCurrent3and2(lowVoltage, updatedResistanceSum);

  // Adjust resistances with cable resistance
  List<double> lastResistances = List.generate(updatedResistances.length, (index) {
    return updatedResistances[index] + (index % 2 == 0 ? cableResistance[0] : cableResistance[1]);
  });

  List<double> lastResistanceSum = getResistanceSum(lastResistances);
  List<double> lastCurrent3and2 = getCurrent3and2(lowVoltage, lastResistanceSum);

  return [current3and2, updatedCurrent3and2, lastCurrent3and2];
}
