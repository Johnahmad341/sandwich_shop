enum BreadType { white, wheat, wholemeal }

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
  final String? notes;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
    this.notes,
  });

  String get name {
    switch (type) {
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
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Sandwich &&
        other.type == type &&
        other.isFootlong == isFootlong &&
        other.breadType == breadType &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      isFootlong,
      breadType,
      notes,
    );
  }

  Sandwich copyWith({
    SandwichType? type,
    bool? isFootlong,
    BreadType? breadType,
    String? notes,
  }) {
    return Sandwich(
      type: type ?? this.type,
      isFootlong: isFootlong ?? this.isFootlong,
      breadType: breadType ?? this.breadType,
      notes: notes ?? this.notes,
    );
  }
}
