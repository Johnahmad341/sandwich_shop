enum BreadType {white, wheat, wholemeal}

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  String get name {
    switch(type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    // Asset filenames in assets/images use display names with spaces
    // and the .jpg extension, e.g. "Veggie Delight_footlong.jpg".
    final String typeString = name; // e.g., "Veggie Delight"
    final String sizeString = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${typeString}_$sizeString.jpg';
  }
}
