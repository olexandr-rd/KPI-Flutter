import 'dart:math';

// Constants
const double voltage = 0.38;

// Utility function for rounding
double round(double value, {int decimals = 4}) {
  double multiplier = pow(10, decimals).toDouble();
  return (value * multiplier).round() / multiplier;
}

// Function to calculate electrical load
List<PowerLoad> calculateElectricalLoad(double nominalPower, double utilizationFactor, double reactivePowerFactor) {
  List<ElectricReceiver> electricReceivers = getElectricReceivers(nominalPower, utilizationFactor, reactivePowerFactor);

  List<double> sums = List.generate(5, (index) {
    switch (index) {
      case 0:
        return electricReceivers.fold(0.0, (sum, e) => sum + e.quantity);
      case 1:
        return electricReceivers.fold(0.0, (sum, e) => sum + e.totalNominalPower);
      case 2:
        return electricReceivers.fold(0.0, (sum, e) => sum + e.totalUtilizedPower);
      case 3:
        return electricReceivers.fold(0.0, (sum, e) => sum + e.totalReactivePower);
      case 4:
        return electricReceivers.fold(0.0, (sum, e) => sum + e.totalNominalPowerSquared);
      default:
        return 0.0;
    }
  });

  PowerLoad busbar = PowerLoad(
    quantity: sums[0],
    totalNominalPower: sums[1],
    utilizationFactor: round(sums[2] / sums[1]),
    totalUtilizedPower: sums[2],
    totalReactivePower: round(sums[3], decimals: 3),
    totalNominalPowerSquared: sums[4],
    effectiveDeviceCount: getEffectiveER(sums[1], sums[4]),
    activePowerCoefficient: 1.25,
    activeLoad: getLoad(1.25, sums[2]),
    reactiveLoad: getLoad(1.0, sums[3]),
    totalPower: 0.0,
    groupCurrent: 0.0,
  );
  busbar.totalPower = getTotalPower(busbar.activeLoad, busbar.reactiveLoad);
  busbar.groupCurrent = getGroupCurrent(busbar.activeLoad);

  PowerLoad workshop = PowerLoad(
    quantity: 81.0,
    totalNominalPower: 2330.0,
    utilizationFactor: getGroupUtilizationFactor(752.0, 2330.0),
    totalUtilizedPower: 752.0,
    totalReactivePower: 657.0,
    totalNominalPowerSquared: 96399.0,
    effectiveDeviceCount: getEffectiveER(2330.0, 96399.0),
    activePowerCoefficient: 0.7,
    activeLoad: getLoad(0.7, 752.0),
    reactiveLoad: getLoad(0.7, 657.0),
    totalPower: 0.0,
    groupCurrent: 0.0,
  );
  workshop.totalPower = getTotalPower(workshop.activeLoad, workshop.reactiveLoad);
  workshop.groupCurrent = getGroupCurrent(workshop.activeLoad);

  return [busbar, workshop];
}

// Generate list of electric receivers
List<ElectricReceiver> getElectricReceivers(double nominalPower, double utilizationFactor, double reactivePowerFactor) {
  return [
    ElectricReceiver(
      name: "Grinding Machine (1-4)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 4.0,
      nominalPower: nominalPower,
      utilizationFactor: 0.15,
      reactivePowerFactor: 1.33,
    ),
    ElectricReceiver(
      name: "Drilling Machine (5-6)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 2.0,
      nominalPower: 14.0,
      utilizationFactor: 0.12,
      reactivePowerFactor: 1.0,
    ),
    ElectricReceiver(
      name: "Planer (9-12)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 4.0,
      nominalPower: 42.0,
      utilizationFactor: 0.15,
      reactivePowerFactor: 1.33,
    ),
    ElectricReceiver(
      name: "Circular Saw (13)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 1.0,
      nominalPower: 36.0,
      utilizationFactor: 0.3,
      reactivePowerFactor: reactivePowerFactor,
    ),
    ElectricReceiver(
      name: "Press (16)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 1.0,
      nominalPower: 20.0,
      utilizationFactor: 0.5,
      reactivePowerFactor: 0.75,
    ),
    ElectricReceiver(
      name: "Polishing Machine (24)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 1.0,
      nominalPower: 40.0,
      utilizationFactor: utilizationFactor,
      reactivePowerFactor: 1.0,
    ),
    ElectricReceiver(
      name: "Milling Machine (26-27)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 2.0,
      nominalPower: 32.0,
      utilizationFactor: 0.2,
      reactivePowerFactor: 1.0,
    ),
    ElectricReceiver(
      name: "Ventilator (36)",
      efficiencyCoefficient: 0.92,
      powerFactor: 0.9,
      loadVoltage: voltage,
      quantity: 1.0,
      nominalPower: 20.0,
      utilizationFactor: 0.65,
      reactivePowerFactor: 0.75,
    ),
  ];
}

// Utility functions
double getGroupUtilizationFactor(double totalUtilizedPower, double totalNominalPower) {
  return round(totalUtilizedPower / totalNominalPower);
}

double getEffectiveER(double totalNominalPower, double totalNominalPowerSquared) {
  return (totalNominalPower * totalNominalPower / totalNominalPowerSquared).ceilToDouble();
}

double getLoad(double multiplier1, double multiplier2) {
  return round(multiplier1 * multiplier2);
}

double getTotalPower(double activeLoad, double reactiveLoad) {
  return round(sqrt(activeLoad * activeLoad + reactiveLoad * reactiveLoad), decimals: 1);
}

double getGroupCurrent(double activeLoad) {
  return round(activeLoad / voltage, decimals: 2);
}

// Electric Receiver class
class ElectricReceiver {
  final String name;
  final double efficiencyCoefficient;
  final double powerFactor;
  final double loadVoltage;
  final double quantity;
  final double nominalPower;
  final double utilizationFactor;
  final double reactivePowerFactor;
  final double totalNominalPower;
  final double totalUtilizedPower;
  final double totalReactivePower;
  final double totalNominalPowerSquared;
  final double calculatedGroupCurrent;

  ElectricReceiver({
    required this.name,
    required this.efficiencyCoefficient,
    required this.powerFactor,
    required this.loadVoltage,
    required this.quantity,
    required this.nominalPower,
    required this.utilizationFactor,
    required this.reactivePowerFactor,
  })  : totalNominalPower = round(quantity * nominalPower),
        totalUtilizedPower = round(quantity * nominalPower * utilizationFactor),
        totalReactivePower = round(quantity * nominalPower * utilizationFactor * reactivePowerFactor),
        totalNominalPowerSquared = round(quantity * nominalPower * nominalPower),
        calculatedGroupCurrent = round((quantity * nominalPower) / (sqrt(3) * loadVoltage * powerFactor * efficiencyCoefficient));
}

// Power Load class
class PowerLoad {
  final double quantity;
  final double totalNominalPower;
  final double utilizationFactor;
  final double totalUtilizedPower;
  final double totalReactivePower;
  final double totalNominalPowerSquared;
  final double effectiveDeviceCount;
  final double activePowerCoefficient;
  final double activeLoad;
  final double reactiveLoad;
  double totalPower;
  double groupCurrent;

  PowerLoad({
    required this.quantity,
    required this.totalNominalPower,
    required this.utilizationFactor,
    required this.totalUtilizedPower,
    required this.totalReactivePower,
    required this.totalNominalPowerSquared,
    required this.effectiveDeviceCount,
    required this.activePowerCoefficient,
    required this.activeLoad,
    required this.reactiveLoad,
    required this.totalPower,
    required this.groupCurrent,
  });
}