import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('CartScreen', () {
    late Cart testCart;
    late Sandwich sandwich1;
    late Sandwich sandwich2;

    setUp(() {
      testCart = Cart();
      sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
    });

    Widget createWidgetUnderTest(Cart cart) {
      return MaterialApp(
        home: CartScreen(cart: cart),
      );
    }

    testWidgets('displays empty cart message when cart is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add some delicious sandwiches!'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items', (tester) async {
      testCart.add(sandwich1, quantity: 2);
      testCart.add(sandwich2, quantity: 1);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('displays correct total price', (tester) async {
      testCart.add(sandwich1, quantity: 2); // 2 * £11.00 = £22.00
      testCart.add(sandwich2, quantity: 1); // 1 * £7.00 = £7.00
      // Total: £29.00

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.text('£29.00'), findsOneWidget);
    });

    testWidgets('does not show clear cart button when cart is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.byIcon(Icons.delete_sweep), findsNothing);
    });

    testWidgets('shows clear cart button when cart has items', (tester) async {
      testCart.add(sandwich1, quantity: 1);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.byIcon(Icons.delete_sweep), findsOneWidget);
    });

    testWidgets('clear cart button shows confirmation dialog', (tester) async {
      testCart.add(sandwich1, quantity: 1);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      expect(find.text('Clear Cart'), findsOneWidget);
      expect(find.text('Remove all items from cart?'), findsOneWidget);
    });

    testWidgets('confirming clear cart removes all items', (tester) async {
      testCart.add(sandwich1, quantity: 2);
      testCart.add(sandwich2, quantity: 1);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(testCart.isEmpty, false);

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(testCart.isEmpty, true);
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('canceling clear cart keeps items', (tester) async {
      testCart.add(sandwich1, quantity: 2);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(testCart.isEmpty, false);
      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    testWidgets('clearing cart shows snackbar confirmation', (tester) async {
      testCart.add(sandwich1, quantity: 1);

      await tester.pumpWidget(createWidgetUnderTest(testCart));

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(find.text('Cart cleared'), findsOneWidget);
    });

    testWidgets('back button navigates away', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testCart));

      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Verify navigation occurred (widget should be disposed)
      expect(find.byType(CartScreen), findsNothing);
    });

    testWidgets('total updates when item quantity changes', (tester) async {
      testCart.add(sandwich1, quantity: 2); // £22.00

      await tester.pumpWidget(createWidgetUnderTest(testCart));
      await tester.pumpAndSettle();

      expect(find.text('£22.00'), findsOneWidget);

      // Change quantity to 3
      testCart.setQuantity(sandwich1, 3);
      await tester.pumpWidget(createWidgetUnderTest(testCart));
      await tester.pumpAndSettle();

      expect(find.text('£33.00'), findsOneWidget);
    });

    testWidgets('displays AppBar with logo and title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testCart));

      expect(find.text('Cart View'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
