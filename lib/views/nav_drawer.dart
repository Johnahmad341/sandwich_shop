import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const NavDrawer({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/logo.png', height: 60),
                const SizedBox(height: 8),
                const Text('Sandwich Shop', style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Order'),
            onTap: () {
              Navigator.of(parentContext).pushNamedAndRemoveUntil('/', (r) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.of(parentContext).pushNamed('/cart');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(parentContext).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Checkout'),
            onTap: () {
              Navigator.of(parentContext).pushNamed('/checkout');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.of(parentContext).pushNamed('/about');
            },
          ),
        ],
      ),
    );
  }
}
