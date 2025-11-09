import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      expect(
        find.text('0 UnToasted white footlong sandwich(es): '),
        findsOneWidget,
      );
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(
        find.text('1 UnToasted white footlong sandwich(es): 🥪'),
        findsOneWidget,
      );
    });

    testWidgets('decrements quantity when Remove is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(
        find.text('1 UnToasted white footlong sandwich(es): 🥪'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(
        find.text('0 UnToasted white footlong sandwich(es): '),
        findsOneWidget,
      );
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(
        find.text('0 UnToasted white footlong sandwich(es): '),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(
        find.text('0 UnToasted white footlong sandwich(es): '),
        findsOneWidget,
      );
    });

    testWidgets('does not increment above maxQuantity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }
      expect(
        find.text('5 UnToasted white footlong sandwich(es): 🥪🥪🥪🥪🥪'),
        findsOneWidget,
      );
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('wholemeal footlong sandwich'),
        findsOneWidget,
      );
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.enterText(
        find.byKey(const Key('notes_textfield')),
        'Extra mayo',
      );
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(home: Scaffold(body: testButton));
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('OrderScreen - Toasted Switch', () {
    testWidgets('toasted switch toggle and updates display', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      Switch test_switch = tester.widget<Switch>(
        find.byKey(Key('toasted_switch')),
      );

      //Checks if the initial state of the Switch is Untoasted via checking text
      expect(find.textContaining('UnToasted'), findsOneWidget);
      expect(test_switch.value, false);

      //Checks if the switch is 'tappable' and if text updates accordingly
      await tester.tap(find.byKey(Key('toasted_switch')));
      await tester.pump();

      test_switch = tester.widget<Switch>(find.byKey(Key('toasted_switch')));

      expect(test_switch.value, true);
      expect(find.textContaining('Toasted'), findsOneWidget);

      //Checks if switch and text will return it its original state if tapped again
      await tester.tap(find.byKey(Key('toasted_switch')));
      await tester.pump();

      test_switch = tester.widget<Switch>(find.byKey(Key('toasted_switch')));

      expect(test_switch.value, false);
      expect(find.textContaining('UnToasted'), findsOneWidget);
    });
  });

  group('SwitchButton', () {
    testWidgets('Test the switch widget for the different sandwiches', (
      WidgetTester tester,
    ) async {
      bool switchValue = false;

      MaterialApp testApp = MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Switch(
                key: Key('Switch 1'),
                value: switchValue,
                onChanged: (newValue) {
                  setState(() {
                    switchValue = newValue;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      //Checks if a switch actually exists in the testApp
      expect(find.byKey(Key('Switch 1')), findsOneWidget);

      //Checks if the initial value for the switch is off
      Switch sw = tester.widget<Switch>(find.byKey(Key('Switch 1')));
      expect(sw.value, false);

      //Checks if the switch it 'tappable'
      await tester.tap(find.byKey(Key('Switch 1')));
      await tester.pump();

      //Checks if the value of the switch is now on
      sw = tester.widget<Switch>(find.byKey(Key('Switch 1')));
      expect(sw.value, true);

      //Checks if the switch can be tapped again to turn off
      await tester.tap(find.byKey(Key('Switch 1')));
      await tester.pump();

      //Checks if the value has been changed accordingly back to off
      sw = tester.widget<Switch>(find.byKey(Key('Switch 1')));
      expect(sw.value, false);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
        isToasted: true,
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('0 Toasted white footlong sandwich(es): '),
        findsOneWidget,
      );
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
        isToasted: false,
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('3 UnToasted white footlong sandwich(es): 🥪🥪🥪'),
        findsOneWidget,
      );
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
        isToasted: true,
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('2 Toasted wheat six-inch sandwich(es): 🥪🥪'),
        findsOneWidget,
      );
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        orderNote: 'Lots of lettuce',
        isToasted: false,
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('1 UnToasted wholemeal footlong sandwich(es): 🥪'),
        findsOneWidget,
      );
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });
}
