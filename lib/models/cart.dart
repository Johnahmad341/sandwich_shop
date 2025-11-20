import 'dart:collection';

import 'package:sandwich_shop/models/sandwich.dart';

/// Represents a single line item in the cart.
class CartItem {
	final Sandwich sandwich;
	int quantity;
	String note;

	CartItem({
		required this.sandwich,
		this.quantity = 1,
		this.note = '',
	}) : assert(quantity > 0, 'Quantity must be at least 1');

	CartItem copyWith({
		Sandwich? sandwich,
		int? quantity,
		String? note,
	}) {
		final int newQty = quantity ?? this.quantity;
		if (newQty <= 0) {
			throw ArgumentError('Quantity must be greater than 0');
		}
		return CartItem(
			sandwich: sandwich ?? this.sandwich,
			quantity: newQty,
			note: note ?? this.note,
		);
	}

	// Identity of a line is the sandwich config + note (not quantity).
	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		return other is CartItem &&
				other.note == note &&
				other.sandwich.type == sandwich.type &&
				other.sandwich.isFootlong == sandwich.isFootlong &&
				other.sandwich.breadType == sandwich.breadType;
	}

	@override
	int get hashCode => Object.hash(
				note,
				sandwich.type,
				sandwich.isFootlong,
				sandwich.breadType,
			);
}

/// A simple in-memory shopping cart with basic operations.
class Cart {
	final List<CartItem> _items = <CartItem>[];

	UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

	bool get isEmpty => _items.isEmpty;
	int get totalDistinctItems => _items.length;
	int get totalQuantity => _items.fold(0, (sum, i) => sum + i.quantity);

	void clear() => _items.clear();

	/// Add [quantity] of [sandwich] with optional [note].
	/// If an identical line exists (same sandwich config + note), it increments.
	void addToCart(Sandwich sandwich, {int quantity = 1, String note = ''}) {
		if (quantity <= 0) {
			throw ArgumentError('Quantity to add must be greater than 0');
		}
		final int index = _findIndex(sandwich, note);
		if (index >= 0) {
			_items[index].quantity += quantity;
		} else {
			_items.add(CartItem(sandwich: sandwich, quantity: quantity, note: note));
		}
	}

	/// Alias for addToCart - Add [quantity] of [sandwich] with optional [note].
	void add(Sandwich sandwich, {int quantity = 1, String note = ''}) {
		addToCart(sandwich, quantity: quantity, note: note);
	}

	/// Remove a single unit of the matching line. Removes the line if it reaches 0.
	void removeOne(Sandwich sandwich, {String note = ''}) {
		final int index = _findIndex(sandwich, note);
		if (index < 0) return; // No-op if not present
		final CartItem item = _items[index];
		if (item.quantity > 1) {
			item.quantity -= 1;
		} else {
			_items.removeAt(index);
		}
	}

	/// Remove the entire line that matches [sandwich] and [note].
	void removeAllOf(Sandwich sandwich, {String note = ''}) {
		final int index = _findIndex(sandwich, note);
		if (index >= 0) {
			_items.removeAt(index);
		}
	}

	/// Set the exact [quantity] for a line. Removes the line if [quantity] == 0.
	void setQuantity(Sandwich sandwich, {required int quantity, String note = ''}) {
		if (quantity < 0) {
			throw ArgumentError('Quantity must not be negative');
		}
		final int index = _findIndex(sandwich, note);
		if (index < 0) {
			if (quantity == 0) return; // nothing to do
			_items.add(CartItem(sandwich: sandwich, quantity: quantity, note: note));
			return;
		}
		if (quantity == 0) {
			_items.removeAt(index);
		} else {
			_items[index].quantity = quantity;
		}
	}

	/// Update the note for a line item. If another line with the new note exists,
	/// they are merged by summing quantities.
	void editNote(Sandwich sandwich, {required String oldNote, required String newNote}) {
		if (oldNote == newNote) return;
		final int fromIndex = _findIndex(sandwich, oldNote);
		if (fromIndex < 0) return;

		final int toIndex = _findIndex(sandwich, newNote);
		if (toIndex >= 0) {
			// Merge quantities
			_items[toIndex].quantity += _items[fromIndex].quantity;
			_items.removeAt(fromIndex);
		} else {
			_items[fromIndex].note = newNote;
		}
	}

	/// Replace the sandwich configuration for a line. If another line with the
	/// target configuration exists (same note), merge quantities.
	void editSandwich({
		required Sandwich from,
		required Sandwich to,
		String note = '',
	}) {
		final int fromIndex = _findIndex(from, note);
		if (fromIndex < 0) return;

		final int toIndex = _findIndex(to, note);
		if (toIndex >= 0) {
			_items[toIndex].quantity += _items[fromIndex].quantity;
			_items.removeAt(fromIndex);
		} else {
			_items[fromIndex] = _items[fromIndex].copyWith(sandwich: to);
		}
	}

	/// Compute total price using a provided calculator function.
	/// Example usage with PricingRepository:
	///   final total = cart.totalPrice((\{quantity, isFootlong\}) =>
	///       pricing.calculatePrice(quantity: quantity, isFootlong: isFootlong));
	double totalPrice(double Function({required int quantity, required bool isFootlong}) calculate) {
		double total = 0;
		for (final item in _items) {
			total += calculate(quantity: item.quantity, isFootlong: item.sandwich.isFootlong);
		}
		return total;
	}

	int _findIndex(Sandwich sandwich, String note) {
		return _items.indexWhere((CartItem i) =>
				i.note == note &&
				i.sandwich.type == sandwich.type &&
				i.sandwich.isFootlong == sandwich.isFootlong &&
				i.sandwich.breadType == sandwich.breadType);
	}
}

