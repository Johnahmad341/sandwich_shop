class PricingRepository {

int _quantity = 0;
String _sandwichType = "";

Map<String, int> pricing = {
  "footlong" : 7,
  "six-inch" : 5
};
  
  PricingRepository(this._quantity, this._sandwichType);

  int calculate_oneSandwich() {
    return (pricing[_sandwichType]!);
  }

  int calculate_totalSandwich() {
    return (_quantity * pricing[_sandwichType]!);
  }

}
