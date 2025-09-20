double? calcAccuracy(double userScore, double openScore) {
  if (userScore <= 0 || openScore <= 0) {
    return null;
  }

  const double coe = 3;
  const double minScore = 2;
  const double maxScore = 10;
  if (userScore > openScore) {
    return 100 - (userScore - openScore) / (openScore - minScore - coe) * 100;
  } else if (openScore > userScore) {
    return 100 - (openScore - userScore) / (maxScore + coe - openScore) * 100;
  } else {
    return 100;
  }
}
