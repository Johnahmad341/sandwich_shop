import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('CheckoutScreen', () {
    setUpAll(() {
      initializeTestDatabase();
    });
    testWidgets('displays order summary with empty cart',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: emptyCart);

      await tester.pumpWidget(app);

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsOneWidget);
    });

    testWidgets('displays order summary with single item',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('displays order summary with multiple items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
    });

    testWidgets('shows confirm payment button initially',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('Confirm Payment'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Processing payment...'), findsNothing);
    });

    testWidgets('shows processing state when payment is initiated',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      final Finder confirmButtonFinder = find.text('Confirm Payment');
      await tester.tap(confirmButtonFinder);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsNothing);

      // Wait for the payment processing to complete (2 seconds + some buffer)
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('calculates item prices correctly for footlong sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich footlongSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(footlongSandwich, quantity: 1);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.textContaining('£11.00'), findsWidgets);
    });

    testWidgets('calculates item prices correctly for six-inch sandwiches',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sixInchSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
      cart.add(sixInchSandwich, quantity: 1);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.textContaining('£7.00'), findsWidgets);
    });

    testWidgets('displays correct total for mixed sandwich sizes',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich footlongSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sixInchSandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(footlongSandwich, quantity: 1);
      cart.add(sixInchSandwich, quantity: 2);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('1x Veggie Delight'), findsOneWidget);
      expect(find.text('2x Chicken Teriyaki'), findsOneWidget);
      expect(find.textContaining('£25.00'), findsWidgets);
    });

    testWidgets('payment method text is displayed correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      final Finder paymentMethodFinder =
          find.text('Payment Method: Card ending in 1234');
      expect(paymentMethodFinder, findsOneWidget);

      final Text paymentMethodText = tester.widget<Text>(paymentMethodFinder);
      expect(paymentMethodText.textAlign, equals(TextAlign.center));
    });

    testWidgets('shows correct quantity and name format',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 3);

      const CheckoutScreen checkoutScreen = CheckoutScreen();
      final MaterialApp app = createTestApp(checkoutScreen, cart: cart);

      await tester.pumpWidget(app);

      expect(find.text('3x Chicken Teriyaki'), findsOneWidget);
    });
  });
}
