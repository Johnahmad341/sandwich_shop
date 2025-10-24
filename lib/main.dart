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
  List<int> quantities = [0, 0];
  String _orderNote = '';
  sandwich_types _selectedType = sandwich_types.footlong;

  void _increaseQuantity(position) {
    if ((quantities[0] + quantities[1]) < widget.maxQuantity) {
      setState(() {
        quantities[position]++;
        _quantity++;
      });
    }
  }

  void _decreaseQuantity(position) {
    if (quantities[position] > 0) {
      setState(() {
        quantities[position]--;
        _quantity--;
      });
    }
  }

  String _getSandwichName(sandwich_types type) {
    switch (type) {
      case sandwich_types.footlong:
        return 'Footlong';
      case sandwich_types.sixInch:
        return 'Six-Inch';
    }
  }

  int _getposition_sandwich(sandwich_types type) {
    switch (type) {
      case sandwich_types.footlong:
        return 0;
      case sandwich_types.sixInch:
        return 1;
    }
    throw ArgumentError('Invalid sandwich type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(quantities[0], 'Footlong'),
            OrderItemDisplay(quantities[1], 'Six-Inch'),
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

            SizedBox(height: 20),

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
                  _quantity >= widget.maxQuantity
                      ? null
                      : ()  {
                        _increaseQuantity(_getposition_sandwich(_selectedType));
                        },
                       // _increaseQuantity,
                  'Add',
                ),

                SizedBox(width: 20),

                StyleButton(
                  'remove_button',
                  Colors.black,
                  Colors.redAccent,
                  FontWeight.bold,
                  _quantity <= 0
                      ? null
                      : () {
                          _decreaseQuantity(_getposition_sandwich(_selectedType));
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

            SizedBox(height: 20),

            SegmentedButton<sandwich_types>(
              segments: const <ButtonSegment<sandwich_types>>[
                ButtonSegment<sandwich_types>(
                  value: sandwich_types.footlong,
                  label: Text('Footlong'),
                ),
                ButtonSegment<sandwich_types>(
                  value: sandwich_types.sixInch,
                  label: Text('Six-Inch'),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<sandwich_types> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum sandwich_types { footlong, sixInch }

class StyleButton extends StatelessWidget {
  final String button_name;
  final Color foreground_color;
  final Color background_color;
  final FontWeight font_weight;
  final VoidCallback? onPressed;
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
