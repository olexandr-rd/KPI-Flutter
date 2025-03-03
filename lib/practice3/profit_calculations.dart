import 'dart:math';

// Normal Distribution function
double normalDistribution(double p, double meanPower, double standardDeviation) {
  return (1 / (standardDeviation * sqrt(2 * pi))) *
      exp(-pow(p - meanPower, 2) / (2 * pow(standardDeviation, 2)));
}

// Function to calculate profit before and after improvement
List<double> calculateProfit(double meanPower, double initialStdDev, double improvedStdDev, double energyPrice) {
  var initialValues = calculateEnergyWithoutImbalance(meanPower, initialStdDev, energyPrice);
  double netLossBeforeImprovement = round(initialValues[1] - initialValues[2]);

  var improvedValues = calculateEnergyWithoutImbalance(meanPower, improvedStdDev, energyPrice);
  double netProfitAfterImprovement = round(improvedValues[1] - improvedValues[2]);

  return [netLossBeforeImprovement, netProfitAfterImprovement];
}

// Function to calculate energy distribution and penalties
List<double> calculateEnergyWithoutImbalance(double meanPower, double stdDev, double energyPrice) {
  const double imbalanceThreshold = 0.05; // 5% imbalance
  double lowerBound = round(meanPower - meanPower * imbalanceThreshold);
  double upperBound = round(meanPower + meanPower * imbalanceThreshold);

  double energyShareWithoutImbalance = round(
      integrate((p) => normalDistribution(p, meanPower, stdDev), lowerBound, upperBound));
  double totalEnergy = round(meanPower * 24 * energyShareWithoutImbalance);
  double penalty = round(meanPower * 24 * (1 - energyShareWithoutImbalance) * energyPrice);

  return [energyShareWithoutImbalance, totalEnergy * energyPrice, penalty];
}

// Trapezoidal integration method
double integrate(double Function(double) f, double a, double b, {int n = 1000}) {
  double stepSize = (b - a) / n;
  double sum = 0.0;
  for (int i = 0; i < n; i++) {
    double x1 = a + i * stepSize;
    double x2 = a + (i + 1) * stepSize;
    sum += (f(x1) + f(x2)) * stepSize / 2;
  }
  return sum;
}

// Round function
double round(double value, {int decimals = 2}) {
  double multiplier = pow(10, decimals).toDouble();
  return (value * multiplier).round() / multiplier;
}
