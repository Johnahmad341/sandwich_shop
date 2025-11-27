import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/cart_item_widget.dart';

void main() {
  group('CartItemWidget', () {
    late Sandwich testSandwich;

    setUp(() {
      testSandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
        notes: 'Extra mayo',
      );
    });

    Widget createWidgetUnderTest({
      required Sandwich sandwich,
      required int quantity,
      VoidCallback? onDelete,
      void Function(int)? onQuantityChanged,
      void Function(Sandwich)? onItemUpdated,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CartItemWidget(
            sandwich: sandwich,
            quantity: quantity,
            onDelete: onDelete ?? () {},
            onQuantityChanged: onQuantityChanged ?? (_) {},
            onItemUpdated: onItemUpdated ?? (_) {},
          ),
        ),
      );
    }

    testWidgets('displays sandwich name and initial quantity', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
        ),
      );

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('displays price correctly for footlong', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
        ),
      );

      // 2 footlongs = 2 * £11.00 = £22.00
      expect(find.text('£22.00'), findsOneWidget);
    });

    testWidgets('displays price correctly for six-inch', (tester) async {
      final sixInchSandwich = testSandwich.copyWith(isFootlong: false);
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: sixInchSandwich,
          quantity: 3,
        ),
      );

      // 3 six-inch = 3 * £7.00 = £21.00
      expect(find.text('£21.00'), findsOneWidget);
    });

    testWidgets('increment button increases quantity', (tester) async {
      int updatedQuantity = 0;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 5,
          onQuantityChanged: (newQty) => updatedQuantity = newQty,
        ),
      );

      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();

      expect(updatedQuantity, 6);
    });

    testWidgets('decrement button decreases quantity', (tester) async {
      int updatedQuantity = 0;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 5,
          onQuantityChanged: (newQty) => updatedQuantity = newQty,
        ),
      );

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pump();

      expect(updatedQuantity, 4);
    });

    testWidgets('increment button disabled at max quantity (99)', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 99,
        ),
      );

      final incrementButton = tester.widget<IconButton>(
        find.byIcon(Icons.add_circle_outline),
      );

      expect(incrementButton.onPressed, isNull);
    });

    testWidgets('decrement at quantity 1 shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 1,
        ),
      );

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      await tester.pumpAndSettle();

      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Remove this item from cart?'), findsOneWidget);
    });

    testWidgets('delete button shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 5,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Remove Item'), findsOneWidget);
      expect(find.text('Remove this item from cart?'), findsOneWidget);
    });

    testWidgets('confirming deletion calls onDelete callback', (tester) async {
      bool deleteCalled = false;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 5,
          onDelete: () => deleteCalled = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(deleteCalled, true);
    });

    testWidgets('canceling deletion does not call onDelete', (tester) async {
      bool deleteCalled = false;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 5,
          onDelete: () => deleteCalled = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(deleteCalled, false);
    });

    testWidgets('size switch toggles between footlong and six-inch', (tester) async {
      Sandwich? updatedSandwich;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
          onItemUpdated: (sandwich) => updatedSandwich = sandwich,
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(updatedSandwich, isNotNull);
      expect(updatedSandwich!.isFootlong, false);
    });

    testWidgets('bread type dropdown shows all options', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
        ),
      );

      await tester.tap(find.byType(DropdownButton<BreadType>));
      await tester.pumpAndSettle();

      expect(find.text('White'), findsWidgets);
      expect(find.text('Wheat'), findsOneWidget);
      expect(find.text('Wholemeal'), findsOneWidget);
    });

    testWidgets('changing bread type calls onItemUpdated', (tester) async {
      Sandwich? updatedSandwich;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
          onItemUpdated: (sandwich) => updatedSandwich = sandwich,
        ),
      );

      await tester.tap(find.byType(DropdownButton<BreadType>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Wheat').last);
      await tester.pumpAndSettle();

      expect(updatedSandwich, isNotNull);
      expect(updatedSandwich!.breadType, BreadType.wheat);
    });

    testWidgets('displays notes when present', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
        ),
      );

      expect(find.text('Notes: Extra mayo'), findsOneWidget);
    });

    testWidgets('shows "Add notes" button when notes are empty', (tester) async {
      final sandwichWithoutNotes = testSandwich.copyWith(notes: null);
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: sandwichWithoutNotes,
          quantity: 2,
        ),
      );

      expect(find.text('Add notes'), findsOneWidget);
    });

    testWidgets('clicking "Add notes" shows text field', (tester) async {
      final sandwichWithoutNotes = testSandwich.copyWith(notes: null);
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: sandwichWithoutNotes,
          quantity: 2,
        ),
      );

      await tester.tap(find.text('Add notes'));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Special instructions'), findsOneWidget);
    });

    testWidgets('saving notes calls onItemUpdated with new notes', (tester) async {
      final sandwichWithoutNotes = testSandwich.copyWith(notes: null);
      Sandwich? updatedSandwich;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: sandwichWithoutNotes,
          quantity: 2,
          onItemUpdated: (sandwich) => updatedSandwich = sandwich,
        ),
      );

      await tester.tap(find.text('Add notes'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'No pickles');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(updatedSandwich, isNotNull);
      expect(updatedSandwich!.notes, 'No pickles');
    });

    testWidgets('canceling note edit restores original notes', (tester) async {
      Sandwich? updatedSandwich;
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: testSandwich,
          quantity: 2,
          onItemUpdated: (sandwich) => updatedSandwich = sandwich,
        ),
      );

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Changed text');
      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(updatedSandwich, isNull);
      expect(find.text('Notes: Extra mayo'), findsOneWidget);
    });

    testWidgets('notes field enforces 200 character limit', (tester) async {
      final sandwichWithoutNotes = testSandwich.copyWith(notes: null);
      
      await tester.pumpWidget(
        createWidgetUnderTest(
          sandwich: sandwichWithoutNotes,
          quantity: 2,
        ),
      );

      await tester.tap(find.text('Add notes'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 200);
    });
  });
}
