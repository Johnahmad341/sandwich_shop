import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich.name', () {
    final expectedNames = {
      SandwichType.veggieDelight: 'Veggie Delight',
      SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
      SandwichType.tunaMelt: 'Tuna Melt',
      SandwichType.meatballMarinara: 'Meatball Marinara',
    };

    expectedNames.forEach((type, expected) {
      test('returns "$expected" for $type', () {
        final sandwich = Sandwich(
          type: type,
          isFootlong: false,
          breadType: BreadType.white,
        );
        expect(sandwich.name, expected);
      });
    });
  });

  group('Sandwich.image', () {
    test('uses enum name and size for footlong', () {
      for (final type in SandwichType.values) {
        final sandwich = Sandwich(
          type: type,
          isFootlong: true,
          breadType: BreadType.wheat,
        );
        final expected = 'assets/images/${type.name}_footlong.png';
        expect(sandwich.image, expected,
            reason: 'Image path should include enum name and "footlong" size');
      }
    });

    test('uses enum name and size for six inch', () {
      for (final type in SandwichType.values) {
        final sandwich = Sandwich(
          type: type,
          isFootlong: false,
          breadType: BreadType.wholemeal,
        );
        final expected = 'assets/images/${type.name}_six_inch.png';
        expect(sandwich.image, expected,
            reason: 'Image path should include enum name and "six_inch" size');
      }
    });

    test('breadType does not affect image path', () {
      final type = SandwichType.tunaMelt;
      final footlongWhite = Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      final footlongWholemeal = Sandwich(type: type, isFootlong: true, breadType: BreadType.wholemeal);
      final sixInchWheat = Sandwich(type: type, isFootlong: false, breadType: BreadType.wheat);

      expect(footlongWhite.image, footlongWholemeal.image);
      expect(footlongWhite.image, 'assets/images/${type.name}_footlong.png');
      expect(sixInchWheat.image, 'assets/images/${type.name}_six_inch.png');
    });
  });
}