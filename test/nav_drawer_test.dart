import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Drawer navigation works on mobile', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap About
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About Us'), findsOneWidget);

    // Open Drawer again
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Drawer is persistent on wide screens', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Drawer should be visible as a side panel
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Order'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);

    // Tap About
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About Us'), findsOneWidget);

    // Clean up
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
  });
}
