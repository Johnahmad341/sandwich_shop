import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen displays fields and saves', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    expect(find.text('Your Details'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextField).at(1), 'john@example.com');

    await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.save));
    await tester.pump();

    expect(find.text('Profile saved!'), findsOneWidget);
  });
}
