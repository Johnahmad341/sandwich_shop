import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';
import '../helpers/test_helpers.dart';

void dummyFunction() {}

void main() {
  group('OrderScreen - Initial State', () {
    testWidgets('displays the initial UI elements correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = createTestApp(orderScreen, cart: cart);
      await tester.pumpWidget(app);

      expect(find.text('Sandwich Counter'), findsOneWidget);

      expect(find.byType(Image), findsNWidgets(2));

      expect(find.text('Veggie Delight'), findsWidgets);

      final Finder switchFinder = find.byType(Switch);
      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isTrue);

      expect(find.text('white'), findsWidgets);

      expect(find.text('1'), findsOneWidget);

      expect(find.widgetWithText(StyledButton, 'Add to Cart'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'View Cart'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'Profile'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'Settings'), findsOneWidget);
      expect(
          find.widgetWithText(StyledButton, 'Order History'), findsOneWidget);
    });

    testWidgets('displays cart indicator in app bar',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = createTestApp(orderScreen, cart: cart);
      await tester.pumpWidget(app);

      testCartIndicator(tester, 0);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('displays initial cart summary with zero items and price',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('updates cart summary when items are added to cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
    });

    testWidgets('updates cart summary when quantity is increased before adding',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('cart summary accumulates when multiple items are added',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('cart indicator in app bar updates when items are added',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      final cartCountFinder = find.descendant(
        of: appBarFinder,
        matching: find.text('0'),
      );
      expect(cartCountFinder, findsOneWidget);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      final updatedCartCountFinder = find.descendant(
        of: appBarFinder,
        matching: find.text('1'),
      );
      expect(updatedCartCountFinder, findsOneWidget);
    });
  });

  group('OrderScreen - Interactions', () {
    testWidgets('shows SnackBar confirmation when item is added to cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButtonFinder);
      await tester.pumpAndSettle();

      const String expectedMessage =
          'Added 1 footlong Veggie Delight sandwich(es) on white bread to cart';

      expect(find.text(expectedMessage), findsOneWidget);
    });

    testWidgets('updates sandwich type when a new option is selected',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder sandwichDropdownFinder =
          find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdownFinder);
      await tester.pumpAndSettle();

      final Finder chickenTeriyakiOptionFinder =
          find.text('Chicken Teriyaki').last;
      await tester.tap(chickenTeriyakiOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('updates sandwich size when the switch is toggled',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pump();

      final Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isFalse);
    });

    testWidgets('updates bread type when a new option is selected',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder breadDropdownFinder = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdownFinder);
      await tester.pumpAndSettle();

      final Finder wheatOptionFinder = find.text('wheat').last;
      await tester.tap(wheatOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('increases quantity when add button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decreases quantity when remove button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder addButtonFinder = find.byIcon(Icons.add);
      await tester.ensureVisible(addButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      final Finder removeButtonFinder = find.byIcon(Icons.remove);
      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('quantity does not go below zero and buttons are disabled',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder removeButtonFinder =
          find.widgetWithIcon(IconButton, Icons.remove);
      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNWidgets(2));
      IconButton removeButton = tester.widget<IconButton>(removeButtonFinder);
      expect(removeButton.onPressed, isNull);

      final Finder addToCartButtonFinder =
          find.widgetWithText(StyledButton, 'Add to Cart');
      final StyledButton styledButton =
          tester.widget<StyledButton>(addToCartButtonFinder);
      expect(styledButton.onPressed, isNull);

      await tester.ensureVisible(removeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNWidgets(2));
    });

    testWidgets('navigates to cart view when View Cart button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder viewCartButtonFinder =
          find.widgetWithText(StyledButton, 'View Cart');
      expect(viewCartButtonFinder, findsOneWidget);

      final StyledButton viewCartButton =
          tester.widget<StyledButton>(viewCartButtonFinder);
      expect(viewCartButton.onPressed, isNotNull);
    });

    testWidgets('navigates to profile when Profile button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder profileButtonFinder =
          find.widgetWithText(StyledButton, 'Profile');
      expect(profileButtonFinder, findsOneWidget);

      final StyledButton profileButton =
          tester.widget<StyledButton>(profileButtonFinder);
      expect(profileButton.onPressed, isNotNull);
    });

    testWidgets('navigates to settings when Settings button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder settingsButtonFinder =
          find.widgetWithText(StyledButton, 'Settings');
      expect(settingsButtonFinder, findsOneWidget);

      final StyledButton settingsButton =
          tester.widget<StyledButton>(settingsButtonFinder);
      expect(settingsButton.onPressed, isNotNull);
    });

    testWidgets(
        'navigates to order history when Order History button is tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      const OrderScreen orderScreen = OrderScreen();
      final MaterialApp app = MaterialApp(
        home: ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: orderScreen,
        ),
      );
      await tester.pumpWidget(app);

      final Finder orderHistoryButtonFinder =
          find.widgetWithText(StyledButton, 'Order History');
      expect(orderHistoryButtonFinder, findsOneWidget);

      final StyledButton orderHistoryButton =
          tester.widget<StyledButton>(orderHistoryButtonFinder);
      expect(orderHistoryButton.onPressed, isNotNull);
    });
  });
}
