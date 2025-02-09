import 'dart:math';

double round(double value, {int decimals = 2}) {
  double multiplier = pow(10, decimals).toDouble();
  return (value * multiplier).round() / multiplier;
}

double getMassFactor(double wp, [double ap = 0.0]) {
  return 100.0 / (100.0 - wp - ap);
}

double getMassFactorFromDAFOrDry(double wp, [double ap = 0.0]) {
  return (100.0 - wp - ap) / 100.0;
}

class WorkingFuel {
  double h, c, s, n, o, w, a;

  WorkingFuel({
    required this.h,
    required this.c,
    required this.s,
    required this.n,
    required this.o,
    required this.w,
    required this.a,
  });

  WorkingFuel getMass(bool includeAsh) {
    double massFactor = getMassFactor(w, includeAsh ? 0.0 : a);
    return WorkingFuel(
      h: h * massFactor,
      c: c * massFactor,
      s: s * massFactor,
      n: n * massFactor,
      o: o * massFactor,
      w: 0.0,
      a: includeAsh ? a * massFactor : 0.0,
    );
  }
}

class CombustibleFuel {
  double c, h, o, s, w, a, v;

  CombustibleFuel({
    required this.c,
    required this.h,
    required this.o,
    required this.s,
    required this.w,
    required this.a,
    required this.v,
  });

  CombustibleFuel getMassFromDAF() {
    double massFactorFromDAF = getMassFactorFromDAFOrDry(w, a);
    double massFactorFromDry = getMassFactorFromDAFOrDry(w);
    return CombustibleFuel(
      c: c * massFactorFromDAF,
      h: h * massFactorFromDAF,
      o: o * massFactorFromDAF,
      s: s * massFactorFromDAF,
      w: w,
      a: a * massFactorFromDry,
      v: v * massFactorFromDry,
    );
  }
}

// Функція для розрахунку базового нижчого теплотворного значення (LHV)
double getLowerHeatingValue(WorkingFuel fuel) {
  return (339 * fuel.c + 1030 * fuel.h - 108.8 * (fuel.o - fuel.s) - 25 * fuel.w) / 1000;
}

// Функція для розрахунку скоригованого LHV для сухої або DAF маси
double getAdjustedLowerHeatingValue(WorkingFuel fuel, double lhv, double massFactor) {
  return (lhv + 0.025 * fuel.w) * massFactor;
}

// Функція для розрахунку LHV на основі DAF
double getLowerHeatingValueFromDAF(CombustibleFuel fuel, double daf) {
  return daf * getMassFactorFromDAFOrDry(fuel.w, fuel.a) - 0.025 * fuel.w;
}
