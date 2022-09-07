enum RemovalChance {
  low,
  medium,
  high,
  definite,
}

extension RemovalChanceFromString on RemovalChance {
  RemovalChance? toEnum(String value) {
    switch (value) {
      case "low":
        return RemovalChance.low;
      case "medium":
        return RemovalChance.medium;
      case "high":
        return RemovalChance.high;
      case "definite":
        return RemovalChance.definite;
      default:
        return null;
    }
  }
}
