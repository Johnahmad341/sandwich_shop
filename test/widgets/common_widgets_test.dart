import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void dummyFunction() {}

void main() {
  group('CommonAppBar', () {
    testWidgets('displays title and logo correctly',
        (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(title: 'Test Title');
      const MaterialApp app = MaterialApp(
        home: Scaffold(appBar: appBar),
      );

      await tester.pumpWidget(app);

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final Image logoImage = tester.widget(find.byType(Image));
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('displays actions when provided', (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(
        title: 'Test Title',
        actions: [
          Icon(Icons.shopping_cart),
          Text('Cart'),
        ],
      );
      const MaterialApp app = MaterialApp(
        home: Scaffold(appBar: appBar),
      );

      await tester.pumpWidget(app);

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('has correct preferred size', (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(title: 'Test Title');

      expect(
          appBar.preferredSize, equals(const Size.fromHeight(kToolbarHeight)));
    });
  });

  group('StyledButton', () {
    testWidgets('renders correctly with icon and label when enabled',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isTrue);
    });

    testWidgets('renders correctly and is disabled when onPressed is null',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isFalse);
    });

    testWidgets('displays different icons correctly',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.settings,
        label: 'Settings',
        backgroundColor: Colors.grey,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('has row layout structure', (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.star,
        label: 'Star Button',
        backgroundColor: Colors.blue,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star Button'), findsOneWidget);
    });
  });
}
