import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';

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
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  // Add this: store loaded sandwich data
  Map<SandwichType, Sandwich> _sandwichData = {};
  bool _isLoadingSandwiches = true;

  @override
  void initState() {
    super.initState();
    _loadSandwiches(); // Load JSON data on startup
    _notesController.addListener(() {
      setState(() {});
    });
  }

  // Add this method to load sandwiches from JSON
  Future<void> _loadSandwiches() async {
    final data = await loadSandwichData();
    Map<SandwichType, Sandwich> sandwiches = {};
    
    for (var json in data) {
      final sandwich = Sandwich.fromJson(json);
      sandwiches[sandwich.type] = sandwich;
    }
    
    setState(() {
      _sandwichData = sandwiches;
      _isLoadingSandwiches = false;
    });
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      setState(() {
        _cart.add(sandwich,
        quantity: _quantity,
        note: _notesController.text.trim());
      });

      String sizeText;
      if (_isFootlong) {
        sizeText = 'footlong';
      } else {
        sizeText = 'six-inch';
      }
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      debugPrint(confirmationMessage);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  // Update this method to use loaded data
  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    // If data not loaded yet, return empty list
    if (_sandwichData.isEmpty) {
      return [];
    }

    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      // Use the loaded sandwich data instead of creating a new one
      Sandwich sandwich = _sandwichData[type]!;
      
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
        leadingIcon: sandwich.available
          ? const Icon(Icons.check_circle, color: Colors.green, size: 15)
          : const Icon(Icons.cancel, color: Colors.red, size: 15),
        enabled: sandwich.available, // Now this actually uses JSON data!
      );
      entries.add(entry);
    }
    return entries;
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> entry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(entry);
    }
    return entries;
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) {
      setState(() {
        _selectedSandwichType = value;
      });
    }
  }

  void _onSizeChanged(bool value) {
    setState(() {
      _isFootlong = value;
    });
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) {
      setState(() {
        _selectedBreadType = value;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  VoidCallback? _getDecreaseCallback() {
    if (_quantity > 0) {
      return _decreaseQuantity;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: _isLoadingSandwiches
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 300,
                      child: Image.asset(
                        _getCurrentImagePath(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Image not found',
                              style: normalText,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Optional: Show sandwich description
                    if (_sandwichData[_selectedSandwichType] != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              _sandwichData[_selectedSandwichType]!.description,
                              style: normalText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    DropdownMenu<SandwichType>(
                      width: double.infinity,
                      label: const Text('Sandwich Type'),
                      textStyle: normalText,
                      initialSelection: _selectedSandwichType,
                      onSelected: _onSandwichTypeChanged,
                      dropdownMenuEntries: _buildSandwichTypeEntries(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Six-inch', style: normalText),
                        Switch(
                          value: _isFootlong,
                          onChanged: _onSizeChanged,
                        ),
                        const Text('Footlong', style: normalText),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DropdownMenu<BreadType>(
                      width: double.infinity,
                      label: const Text('Bread Type'),
                      textStyle: normalText,
                      initialSelection: _selectedBreadType,
                      onSelected: _onBreadTypeChanged,
                      dropdownMenuEntries: _buildBreadTypeEntries(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Quantity: ', style: normalText),
                        IconButton(
                          onPressed: _getDecreaseCallback(),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$_quantity', style: heading2),
                        IconButton(
                          onPressed: _increaseQuantity,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StyledButton(
                      onPressed: _getAddToCartCallback(),
                      icon: Icons.add_shopping_cart,
                      label: 'Add to Cart',
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    _cart.getSummary()
                  ],
                ),
              ),
            ),
    );
  }
}


class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

