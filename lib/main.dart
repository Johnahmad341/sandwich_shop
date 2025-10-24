import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _orderScreenState();
  }
}

class _orderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _orderNote = '';

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(_quantity, 'Footlong'),

            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Order Notes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _orderNote = value;
                  });
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     _increaseQuantity();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.greenAccent,
                //     foregroundColor: Colors.black,
                //     textStyle: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   child: const Text('Add'),
                // ),
                StyleButton(
                  'add_button',
                  Colors.black,
                  Colors.greenAccent,
                  FontWeight.bold,
                  () {
                    _increaseQuantity();
                  },
                  'Add',
                ),

                SizedBox(width: 20),

                StyleButton(
                  'remove_button',
                  Colors.black,
                  Colors.redAccent,
                  FontWeight.bold,
                  () {
                    _decreaseQuantity();
                  },
                  'Remove',
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     _decreaseQuantity();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.redAccent,
                //     foregroundColor: Colors.black,
                //     textStyle: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   child: const Text('Remove'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StyleButton extends StatelessWidget {
  final String button_name;
  final Color foreground_color;
  final Color background_color;
  final FontWeight font_weight;
  final VoidCallback onPressed;
  final String text;

  const StyleButton(
    this.button_name,
    this.foreground_color,
    this.background_color,
    this.font_weight,
    this.onPressed,
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: this.background_color,
        foregroundColor: this.foreground_color,
        textStyle: TextStyle(fontWeight: this.font_weight),
      ),
      child: Text(this.text),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}
