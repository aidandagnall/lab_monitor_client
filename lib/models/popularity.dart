enum Popularity { empty, quiet, medium, busy, very_busy }

extension PopularityString on Popularity {
  Popularity? toEnum(String value) {
    switch (value) {
      case "empty":
        return Popularity.empty;
      case "quiet":
        return Popularity.quiet;
      case "medium":
        return Popularity.medium;
      case "busy":
        return Popularity.busy;
      case "very_busy":
        return Popularity.very_busy;
      default:
        return null;
    }
  }
}
