import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  void _goBack() {
    Navigator.pop(context);
  }

  void _handleQuantityChange(Sandwich sandwich, int newQuantity) {
    setState(() {
      widget.cart.setQuantity(sandwich, newQuantity);
    });
  }

  void _handleItemDelete(Sandwich sandwich) {
    setState(() {
      widget.cart.removeItem(sandwich);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removed from cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleItemUpdate(Sandwich oldSandwich, Sandwich newSandwich) {
    setState(() {
      widget.cart.updateItem(oldSandwich, newSandwich);
    });
  }

  void _showClearCartConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cart'),
          content: const Text('Remove all items from cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  widget.cart.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: const Text(
          'Cart View',
          style: heading1,
        ),
        actions: widget.cart.isEmpty
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: _showClearCartConfirmation,
                  tooltip: 'Clear cart',
                ),
              ],
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: heading2,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add some delicious sandwiches!',
                    style: normalText,
                  ),
                  const SizedBox(height: 24),
                  StyledButton(
                    onPressed: _goBack,
                    icon: Icons.arrow_back,
                    label: 'Back to Order',
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      for (MapEntry<Sandwich, int> entry
                          in widget.cart.items.entries)
                        CartItemWidget(
                          sandwich: entry.key,
                          quantity: entry.value,
                          onDelete: () => _handleItemDelete(entry.key),
                          onQuantityChanged: (newQty) =>
                              _handleQuantityChange(entry.key, newQty),
                          onItemUpdated: (newSandwich) =>
                              _handleItemUpdate(entry.key, newSandwich),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: heading2),
                          Text(
                            '£${widget.cart.totalPrice.toStringAsFixed(2)}',
                            style: heading2.copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      StyledButton(
                        onPressed: _goBack,
                        icon: Icons.arrow_back,
                        label: 'Back to Order',
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
