import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

final Cart _globalCart = Cart();

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      initialRoute: '/',
      routes: {
        '/': (context) => OrderScreen(maxQuantity: 5, cart: _globalCart),
        '/about': (context) => const AboutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/cart': (context) => CartScreen(cart: _globalCart),
        '/checkout': (context) => CheckoutScreen(cart: _globalCart),
      },
    );
  }
}
