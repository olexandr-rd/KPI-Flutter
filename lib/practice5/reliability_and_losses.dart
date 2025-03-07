import 'dart:math';

// Constants
const double maxDowntimeCoefficient = 43.0;
const double plannedDowntimeCoefficient = 1.2 * maxDowntimeCoefficient / 8760.0;
const double sectionalBreakerFailure = 0.02;

// Utility function for rounding
double round(double value, {int decimals = 4}) {
  double multiplier = pow(10, decimals).toDouble();
  return (value * multiplier).round() / multiplier;
}

// Function to calculate failure rates
List<double> calculateFailureRates(double linesLength, double connections) {
  double singleFR = getFailureRate(linesLength, connections);
  double recoverTime = getAverageRecoverTime(linesLength, connections, singleFR);
  double emergencyDowntimeCoefficient = getEmergencyDowntimeCoefficient(singleFR, recoverTime);
  double doubleFR = getDoubleFailureRate(singleFR, emergencyDowntimeCoefficient);
  double doubleFRWithBreaker = getDoubleFailureRateWithBreaker(doubleFR);

  return [singleFR, doubleFRWithBreaker];
}

// Function to determine the more reliable system
String checkMoreReliableSystem(List<double> systems) {
  return systems[0] > systems[1] ? "Double-circuit system" : "Single-circuit system";
}

// Failure rate calculations
double getFailureRate(double linesLength, double connections) {
  return 0.01 + (0.007 * linesLength) + 0.015 + 0.02 + (0.03 * connections);
}

double getAverageRecoverTime(double linesLength, double connections, double failureRate) {
  return (0.01 * 30 + (0.007 * linesLength * 10) + (0.015 * 100) + (0.02 * 15) + (0.03 * connections * 2)) / failureRate;
}

double getEmergencyDowntimeCoefficient(double failureRate, double recoverTime) {
  return failureRate * recoverTime / 8760;
}

double getDoubleFailureRate(double failureRate, double emergencyDowntimeCoefficient) {
  return 2.0 * failureRate * (emergencyDowntimeCoefficient + plannedDowntimeCoefficient);
}

double getDoubleFailureRateWithBreaker(double doubleFR) {
  return round(doubleFR + sectionalBreakerFailure);
}

// Loss calculation
int getLosses(double emergencyOutagesLosses, double plannedOutagesLosses) {
  double productPmTm = 5.12 * pow(10, 3) * 6451;
  double emergencyDowntimeME = 0.01 * 45 * pow(10, -3) * productPmTm;
  double plannedDowntimeME = 4 * pow(10, -3) * productPmTm;

  return (emergencyOutagesLosses * emergencyDowntimeME + plannedOutagesLosses * plannedDowntimeME).round();
}