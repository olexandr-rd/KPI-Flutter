import 'dart:math';
import '../practice1/lower_heating_value.dart';
import 'solid_particles.dart';

List<double> grossCalculations(double coalSpent, double mazutSpent) {
  const double coalLHV = 20.47;
  const double mazutDAF = 40.40;
  final CombustibleFuel mazutFuel =
  CombustibleFuel(c: 85.5, h: 11.2, o: 0.8, s: 2.5, w: 2.0, a: 0.15, v: 333.3);
  final double mazutLHV = getLowerHeatingValueFromDAF(mazutFuel, mazutDAF);

  final SolidParticles coalSolidParticles =
  SolidParticles(lhv: 20.47, vol: 0.8, ash: 25.2, mass: 1.5, ashCapture: 0.985, emissions: 0.0);
  final SolidParticles mazutSolidParticles =
  SolidParticles(lhv: mazutLHV, vol: 1.0, ash: 0.15, mass: 0.0, ashCapture: 0.985, emissions: 0.0);

  final double coalEmissions = getEmissions(coalSolidParticles);
  final double mazutEmissions = getEmissions(mazutSolidParticles);

  final double coalGross = getGross(coalEmissions, coalLHV, coalSpent);
  final double mazutGross = getGross(mazutEmissions, mazutLHV, mazutSpent);

  return [
    round(coalEmissions, decimals: 2),
    round(coalGross, decimals: 2),
    round(mazutEmissions, decimals: 2),
    round(mazutGross, decimals: 2)
  ];
}

double getEmissions(SolidParticles sp) {
  return pow(10, 6) / sp.lhv * sp.vol * sp.ash / (100 - sp.mass) * (1 - sp.ashCapture) + sp.emissions;
}

double getGross(double emissions, double lhv, double fuelSpent) {
  return pow(10, -6) * emissions * lhv * fuelSpent;
}
