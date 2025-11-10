import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('price for a single footlong should be £7', () {
      PricingRepository pricing_repository = PricingRepository(10, "footlong");
      expect(pricing_repository.calculate_oneSandwich(), 7);
    });

    test('price for a single six-inch should be £5', () {
      PricingRepository pricingRepository = PricingRepository(10, "six-inch");
      expect(pricingRepository.calculate_oneSandwich(), 5);
    });

    test('price for 5 footlong sandwiches', () {
      PricingRepository pricingRepository = PricingRepository(5, "footlong");
      expect(pricingRepository.calculate_totalSandwich(), 35);
    });

    test('price for 3 six-inch sandwiches', () {
      PricingRepository pricingRepository = PricingRepository(3, "six-inch");
      expect(pricingRepository.calculate_totalSandwich(), 15);
    });

    test('price for one six-inch sandwich via totalprice calculate_totalSandwich method', () {
      PricingRepository pricingRepository = PricingRepository(1, "six-inch");
      expect(pricingRepository.calculate_totalSandwich(), 5);
    });
  });
}
