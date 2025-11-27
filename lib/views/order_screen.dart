import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/nav_drawer.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  final Cart cart;

  const OrderScreen({super.key, this.maxQuantity = 10, required this.cart});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final String? notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
        notes: notes,
      );

      setState(() {
        widget.cart.add(sandwich, quantity: _quantity);
      });

      String sizeText;
      if (_isFootlong) {
        sizeText = 'footlong';
      } else {
        sizeText = 'six-inch';
      }
      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      if (notes != null) {
        confirmationMessage += ' (with notes)';
      }

      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
      SnackBar snackBar = SnackBar(
        content: Text(confirmationMessage),
        duration: const Duration(seconds: 2),
      );
      scaffoldMessenger.showSnackBar(snackBar);

      // Clear notes field after adding to cart
      _notesController.clear();
    }
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    }
    return null;
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CartScreen(cart: widget.cart),
      ),
    );
  }

  void _navigateToProfileScreen() {
    Navigator.pushNamed(context, '/profile');
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    List<DropdownMenuEntry<SandwichType>> entries = [];
    for (SandwichType type in SandwichType.values) {
      Sandwich sandwich =
          Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
      DropdownMenuEntry<SandwichType> entry = DropdownMenuEntry<SandwichType>(
        value: type,
        label: sandwich.name,
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

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;
    final Widget drawer = NavDrawer(parentContext: context);

    return Scaffold(
      appBar: AppBar(
        leading: isWideScreen ? null : Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      drawer: isWideScreen ? null : drawer,
      body: Row(
        children: [
          if (isWideScreen) SizedBox(width: 220, child: drawer),
          Expanded(
            child: Center(
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
                    DropdownMenu<SandwichType>(
                      width: double.infinity,
                      label: const Text('Sandwich Type'),
                      textStyle: normalText,
                      initialSelection: _selectedSandwichType,
                      onSelected: (SandwichType? value) {
                        if (value != null) {
                          setState(() => _selectedSandwichType = value);
                        }
                      },
                      dropdownMenuEntries: _buildSandwichTypeEntries(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Six-inch', style: normalText),
                        Switch(
                          value: _isFootlong,
                          onChanged: (value) => setState(() => _isFootlong = value),
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
                      onSelected: (BreadType? value) {
                        if (value != null) {
                          setState(() => _selectedBreadType = value);
                        }
                      },
                      dropdownMenuEntries: _buildBreadTypeEntries(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _notesController,
                        maxLength: 200,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Special Instructions (optional)',
                          hintText: 'e.g., extra mayo, no tomatoes',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Quantity: ', style: normalText),
                        IconButton(
                          onPressed: _quantity > 0
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$_quantity', style: heading2),
                        IconButton(
                          onPressed: () => setState(() => _quantity++),
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
                    StyledButton(
                      onPressed: _navigateToCartView,
                      icon: Icons.shopping_cart,
                      label: 'View Cart',
                      backgroundColor: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Cart: ${widget.cart.countOfItems} items - £${widget.cart.totalPrice.toStringAsFixed(2)}',
                      style: normalText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    StyledButton(
                      onPressed: _navigateToProfileScreen,
                      icon: Icons.person,
                      label: 'Profile',
                      backgroundColor: Colors.purple,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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
