import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadSandwichData() async {
  final String jsonString = await rootBundle.loadString('assets/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['sandwiches']);
}

enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final String id;
  final String description;
  final bool available;

  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  Sandwich({
    this.id = '',
    this.description = '',
    this.available = true, // Default to true
    required this.type,
    required this.isFootlong,
    required this.breadType,
  });

  factory Sandwich.fromJson(Map<String, dynamic> json) {
    final String? jsonId = json['id'] as String?;

    SandwichType mapType(String id) {
      switch (id) {
        case 'veggie delight':
          return SandwichType.veggieDelight;
        case 'chicken_teriyaki':
          return SandwichType.chickenTeriyaki;
        case 'tuna_melt':
          return SandwichType.tunaMelt;
        case 'meatball_marinara':
          return SandwichType.meatballMarinara;
        default:
          return SandwichType.veggieDelight;
      }
    }

    return Sandwich(
      id: jsonId ?? '',
      description: json['description'] as String? ?? '',
      available: json['available'] as bool? ?? true,
      type: mapType(jsonId ?? ''),
      isFootlong: true,
      breadType: BreadType.white,
    );
  }

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
    final String typeString = name;
    final String sizeString = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${typeString}_$sizeString.jpg';
  }
}
