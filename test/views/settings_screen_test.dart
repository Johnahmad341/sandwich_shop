import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('SettingsScreen', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays settings UI after loading',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('Current size: 16px'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
      expect(
          find.text(
              'Font size changes are saved automatically. Restart the app to see changes in all screens.'),
          findsOneWidget);
      expect(
          find.widgetWithText(ElevatedButton, 'Back to Order'), findsOneWidget);
    });

    testWidgets('displays common app bar elements correctly',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      testCommonAppBarLogo(tester);
      testBasicScaffoldStructure(tester);
    });

    testWidgets('slider changes font size', (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsOneWidget);

      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);
      expect(slider.value, equals(16.0));

      await tester.drag(sliderFinder, const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsNothing);
      expect(find.textContaining('Current size:'), findsOneWidget);
    });

    testWidgets('slider has correct range and divisions',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);

      expect(slider.min, equals(12.0));
      expect(slider.max, equals(24.0));
      expect(slider.divisions, equals(6));
    });

    testWidgets('preview text updates with font size',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder previewTextFinder =
          find.text('This is sample text to preview the font size.');
      expect(previewTextFinder, findsOneWidget);

      final Text previewText = tester.widget<Text>(previewTextFinder);
      expect(previewText.style?.fontSize, equals(16.0));

      final Finder sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pumpAndSettle();

      final Text updatedPreviewText = tester.widget<Text>(previewTextFinder);
      expect(updatedPreviewText.style?.fontSize, isNot(equals(16.0)));
    });

    testWidgets('current size text updates with font size',
        (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder currentSizeTextFinder = find.text('Current size: 16px');
      expect(currentSizeTextFinder, findsOneWidget);

      final Text currentSizeText = tester.widget<Text>(currentSizeTextFinder);
      expect(currentSizeText.style?.fontSize, equals(16.0));

      final Finder sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pumpAndSettle();

      final Finder updatedCurrentSizeTextFinder =
          find.textContaining('Current size:');
      expect(updatedCurrentSizeTextFinder, findsOneWidget);

      final Text updatedCurrentSizeText =
          tester.widget<Text>(updatedCurrentSizeTextFinder);
      expect(updatedCurrentSizeText.style?.fontSize, isNot(equals(16.0)));
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final Finder backButtonFinder =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);

      final ElevatedButton backButton =
          tester.widget<ElevatedButton>(backButtonFinder);
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('loads saved font size from preferences',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'fontSize': 20.0});

      const SettingsScreen settingsScreen = SettingsScreen();
      const MaterialApp app = MaterialApp(home: settingsScreen);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.text('Current size: 20px'), findsOneWidget);

      final Finder sliderFinder = find.byType(Slider);
      final Slider slider = tester.widget<Slider>(sliderFinder);
      expect(slider.value, equals(20.0));
    });
  });
}
