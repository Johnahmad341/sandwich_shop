import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('OrderHistoryScreen', () {
    setUpAll(() {
      initializeTestDatabase();
    });

    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);

      expect(find.text('Order History'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      testCommonAppBarLogo(tester);
      testBasicScaffoldStructure(tester);
    });
  });
}
