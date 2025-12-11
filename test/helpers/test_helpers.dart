import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initializeTestDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

MaterialApp createTestApp(Widget child, {Cart? cart}) {
  Cart cartValue;
  if (cart != null) {
    cartValue = cart;
  } else {
    cartValue = Cart();
  }
  return MaterialApp(
    home: ChangeNotifierProvider<Cart>.value(
      value: cartValue,
      child: child,
    ),
  );
}

void testCommonAppBarLogo(WidgetTester tester) {
  final appBarFinder = find.byType(AppBar);
  expect(appBarFinder, findsOneWidget);

  final appBarImagesFinder = find.descendant(
    of: appBarFinder,
    matching: find.byType(Image),
  );
  expect(appBarImagesFinder, findsOneWidget);

  final Image logoImage = tester.widget(appBarImagesFinder);
  expect((logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
}

void testCartIndicator(WidgetTester tester, int expectedCount) {
  final appBarFinder = find.byType(AppBar);
  final cartIconFinder = find.descendant(
    of: appBarFinder,
    matching: find.byIcon(Icons.shopping_cart),
  );
  expect(cartIconFinder, findsOneWidget);

  final cartCountFinder = find.descendant(
    of: appBarFinder,
    matching: find.text(expectedCount.toString()),
  );
  expect(cartCountFinder, findsOneWidget);
}

void testStyledButtonProperties(
  WidgetTester tester,
  String buttonText, {
  IconData? expectedIcon,
  Color? expectedBackgroundColor,
  bool shouldBeEnabled = true,
}) {
  final Finder buttonFinder = find.widgetWithText(StyledButton, buttonText);
  expect(buttonFinder, findsOneWidget);

  final StyledButton button = tester.widget<StyledButton>(buttonFinder);

  if (shouldBeEnabled) {
    expect(button.onPressed, isNotNull);
  } else {
    expect(button.onPressed, isNull);
  }

  if (expectedIcon != null) {
    expect(button.icon, equals(expectedIcon));
  }

  if (expectedBackgroundColor != null) {
    expect(button.backgroundColor, equals(expectedBackgroundColor));
  }
}

void testBasicScaffoldStructure(WidgetTester tester) {
  expect(find.byType(Scaffold), findsOneWidget);
  expect(find.byType(AppBar), findsOneWidget);
}
