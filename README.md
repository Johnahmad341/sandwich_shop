# Sandwich Shop 🥪

A Flutter application for ordering sandwiches with customizable options including bread type, sandwich size, and special notes. Built as a learning project to demonstrate Flutter state management, widget composition, and testing.

## Features

- **Sandwich Selection**: Choose between Footlong and Six-Inch sandwiches using segmented buttons
- **Bread Type Selection**: Select from White, Wheat, or Wholemeal bread via dropdown menu
- **Quantity Management**: Add or remove sandwiches with intelligent button disabling at limits
- **Order Notes**: Add special instructions (e.g., "no onions", "extra pickles")
- **Real-time Display**: Visual feedback showing current order with emoji indicators
- **Quantity Limits**: Configurable maximum order quantity with automatic button disabling
- **Custom Styling**: Reusable styled button component with configurable colors

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher)
  - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)
- **IDE**: Visual Studio Code, Android Studio, or IntelliJ IDEA
- **Platform-specific requirements**:
  - Windows: Visual Studio 2022 with Desktop development with C++ workload
  - macOS: Xcode
  - Linux: Required development libraries

## Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Johnahmad341/sandwich_shop.git
cd sandwich_shop
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Installation

```bash
flutter doctor
```

This command checks your environment and displays a report of the status of your Flutter installation.

### 4. Run the Application

**For Windows:**
```powershell
flutter run -d windows
```

**For Web:**
```powershell
flutter run -d chrome
```

**For Mobile (with emulator/device connected):**
```powershell
flutter run
```

## Usage

### Main Features

#### 1. Selecting Sandwich Size
- Use the **Segmented Button** at the top to toggle between "Footlong" and "Six-Inch" options
- The selection updates in real-time in the order display

#### 2. Choosing Bread Type
- Click on the **Dropdown Menu** to see available bread types
- Select from White, Wheat, or Wholemeal
- Your selection appears in the order summary

#### 3. Adding/Removing Sandwiches
- Click **"Add"** button to increase quantity
- Click **"Remove"** button to decrease quantity
- Buttons automatically disable when limits are reached:
  - Remove button disabled at 0 sandwiches
  - Add button disabled at maximum quantity (default: 5)

#### 4. Adding Order Notes
- Type special instructions in the **text field**
- Notes appear in the order summary
- Examples: "no onions", "extra pickles", "toasted"

### Running Tests

Execute the widget test suite:

```powershell
flutter test
```

Run tests with coverage:

```powershell
flutter test --coverage
```

## Project Structure

```
sandwich_shop/
├── lib/
│   ├── main.dart                 # App entry point and main widgets
│   ├── repositories/
│   │   └── order_repository.dart # Business logic for order management
│   └── views/
│       └── app_styles.dart       # Centralized text styles
├── test/
│   └── widget_test.dart          # Comprehensive widget tests
├── pubspec.yaml                  # Project dependencies
└── README.md                     # This file
```

### Key Files

- **`main.dart`**: Contains all main widgets including `App`, `OrderScreen`, `StyledButton`, and `OrderItemDisplay`
- **`order_repository.dart`**: Manages order state with increment/decrement logic and quantity validation
- **`app_styles.dart`**: Defines reusable text styles (`normalText`, `heading1`)
- **`widget_test.dart`**: Full test suite covering UI interactions and state management

## Technologies Used

### Core Framework
- **Flutter 3.x**: UI framework
- **Dart**: Programming language

### Key Packages
- `flutter/material.dart`: Material Design components
- `flutter_test`: Testing framework

### Development Tools
- Flutter DevTools for debugging
- VS Code / Android Studio for development
- Git for version control

### Architecture Patterns
- **StatefulWidget**: For components with mutable state
- **StatelessWidget**: For presentational components
- **Repository Pattern**: Separating business logic from UI
- **Composition**: Building complex UIs from simple widgets

## Code Highlights

### Custom Styled Button

```dart
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  
  // Reusable button with consistent styling
}
```

### Conditional Button Disabling

```dart
StyledButton(
  onPressed: totalQuantity >= maxQuantity ? null : _increaseQuantity,
  // Button automatically grays out at limit
)
```

### Enum-based Type Safety

```dart
enum BreadType { white, wheat, wholemeal }
enum SandwichType { footlong, sixInch }
// Prevents typos and provides autocomplete
```

## Testing

The app includes comprehensive widget tests covering:

- ✅ Initial UI rendering
- ✅ Quantity increment/decrement
- ✅ Button disabling at limits
- ✅ Bread type selection via dropdown
- ✅ Sandwich size toggle with segmented button
- ✅ Order notes text input
- ✅ Custom button styling
- ✅ Order display formatting

**Test Coverage**: Full coverage of user interactions and state changes

## Known Issues and Limitations

### Current Limitations
- Single order at a time (no cart functionality)
- No order persistence (state resets on app restart)
- No price calculation
- Limited sandwich variety (only size and bread type)

### Future Improvements
- 🔄 Add multiple sandwich types (BLT, Club, Veggie, etc.)
- 💾 Persist orders using local storage
- 💰 Implement pricing and total calculation
- 🛒 Add shopping cart with multiple orders
- 🎨 Enhanced UI with images and animations
- 📱 Responsive design for tablets
- 🌐 Backend integration for order submission

## Contributing

This is a learning project, but suggestions and improvements are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Learning Outcomes

This project demonstrates:
- ✅ Flutter widget composition
- ✅ State management with StatefulWidget
- ✅ Custom widget creation
- ✅ Form handling and user input
- ✅ Conditional rendering and business logic
- ✅ Repository pattern for state management
- ✅ Comprehensive widget testing
- ✅ Material Design implementation

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)

## License

This project is created for educational purposes as part of coursework at the University of Portsmouth.

## Contact

**Ahmad**  
Computing Second Year Student  
University of Portsmouth

- 🔗 GitHub: [@Johnahmad341](https://github.com/Johnahmad341)
- 📂 Repository: [sandwich_shop](https://github.com/Johnahmad341/sandwich_shop)

---

**Course**: Programming Application, Languages and User Experience  
**Academic Year**: 2024-2025  
**Project**: Sandwich Shop Flutter Application
