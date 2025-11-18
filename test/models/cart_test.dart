import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

Sandwich _sandwich({
	SandwichType type = SandwichType.tunaMelt,
	bool isFootlong = true,
	BreadType bread = BreadType.white,
}) => Sandwich(type: type, isFootlong: isFootlong, breadType: bread);

void main() {
	group('Cart basic operations', () {
		test('add creates new line and increments totals', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 2, note: 'no onions');
			expect(cart.totalDistinctItems, 1);
			expect(cart.totalQuantity, 2);
			expect(cart.items.first.note, 'no onions');
		});

		test('add merges identical line items (same sandwich + note)', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 1, note: 'x');
			cart.add(s, quantity: 3, note: 'x');
			expect(cart.totalDistinctItems, 1);
			expect(cart.totalQuantity, 4);
		});

		test('removeOne decrements then removes line at quantity 1', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 2);
			cart.removeOne(s);
			expect(cart.totalDistinctItems, 1);
			expect(cart.totalQuantity, 1);
			cart.removeOne(s);
			expect(cart.totalDistinctItems, 0);
			expect(cart.totalQuantity, 0);
		});

		test('removeAllOf removes entire line', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 5);
			cart.removeAllOf(s);
			expect(cart.isEmpty, isTrue);
		});

		test('setQuantity creates new line if absent', () {
			final cart = Cart();
			final s = _sandwich();
			cart.setQuantity(s, quantity: 4);
			expect(cart.totalDistinctItems, 1);
			expect(cart.totalQuantity, 4);
		});

		test('setQuantity updates existing line and removes when set to 0', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 3);
			cart.setQuantity(s, quantity: 7);
			expect(cart.totalQuantity, 7);
			cart.setQuantity(s, quantity: 0);
			expect(cart.isEmpty, isTrue);
		});

		test('editNote changes note and merges if new note exists', () {
			final cart = Cart();
			final s = _sandwich();
			cart.add(s, quantity: 2, note: 'A');
			cart.add(s, quantity: 1, note: 'B');
			cart.editNote(s, oldNote: 'A', newNote: 'B');
			expect(cart.totalDistinctItems, 1); // merged
			expect(cart.totalQuantity, 3); // 2 + 1 merged
			expect(cart.items.first.note, 'B');
		});

		test('editSandwich replaces config and merges if target exists', () {
			final cart = Cart();
			final from = _sandwich(type: SandwichType.veggieDelight, isFootlong: true);
			final to = _sandwich(type: SandwichType.veggieDelight, isFootlong: false); // different size
			cart.add(from, quantity: 2, note: 'same');
			cart.add(to, quantity: 3, note: 'same');
			cart.editSandwich(from: from, to: to, note: 'same');
			expect(cart.totalDistinctItems, 1);
			expect(cart.totalQuantity, 5);
			final item = cart.items.first;
			expect(item.sandwich.isFootlong, isFalse);
		});

		test('totalPrice sums with provided calculator', () {
			final cart = Cart();
			final footlong = _sandwich(isFootlong: true, type: SandwichType.tunaMelt);
			final sixInch = _sandwich(isFootlong: false, type: SandwichType.chickenTeriyaki);
			cart.add(footlong, quantity: 2);
			cart.add(sixInch, quantity: 3);
			double total = cart.totalPrice(({required int quantity, required bool isFootlong}) {
				final pricePerItem = isFootlong ? 11.0 : 7.0;
				return quantity * pricePerItem;
			});
			// 2 * 11 + 3 * 7 = 22 + 21 = 43
			expect(total, 43.0);
		});

		test('clear empties the cart', () {
			final cart = Cart();
			cart.add(_sandwich(), quantity: 1);
			cart.clear();
			expect(cart.isEmpty, isTrue);
		});
	});

	group('Cart error cases', () {
		test('add with non-positive quantity throws', () {
			final cart = Cart();
			expect(() => cart.add(_sandwich(), quantity: 0), throwsArgumentError);
			expect(() => cart.add(_sandwich(), quantity: -2), throwsArgumentError);
		});

		test('setQuantity negative throws', () {
			final cart = Cart();
			expect(() => cart.setQuantity(_sandwich(), quantity: -1), throwsArgumentError);
		});

		test('CartItem copyWith with non-positive quantity throws', () {
			final item = CartItem(sandwich: _sandwich(), quantity: 2);
			expect(() => item.copyWith(quantity: 0), throwsArgumentError);
			expect(() => item.copyWith(quantity: -5), throwsArgumentError);
		});
	});
}

