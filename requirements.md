# Requirements Document: Cart Item Modification Feature

## 1. Feature Overview

### 1.1 Feature Description
This feature enables users to modify items in their shopping cart within the Flutter Sandwich Shop application. Users can change quantities, remove individual items, clear the entire cart, and optionally modify sandwich configurations (size, bread type, notes) directly from the Cart Screen without returning to the Order Screen.

### 1.2 Purpose
- Improve user experience by allowing in-cart modifications
- Reduce friction in the ordering process
- Provide flexibility to adjust orders before checkout
- Minimize navigation between Order and Cart screens

### 1.3 Scope
- **In Scope**: Quantity modification, item removal, cart clearing, size/bread type changes, notes editing
- **Out of Scope**: Payment processing, order submission, user authentication

---

## 2. User Stories

### 2.1 Change Quantity
**As a** customer  
**I want to** increase or decrease the quantity of a sandwich in my cart  
**So that** I can order the exact number I need without removing and re-adding items

**Acceptance Criteria:**
- User can tap "+" button to increase quantity by 1 (max 99)
- User can tap "−" button to decrease quantity by 1
- When quantity reaches 0, a confirmation dialog appears asking to remove the item
- Quantity changes update the line total and cart total immediately
- Changes persist when navigating between screens

### 2.2 Remove Individual Item
**As a** customer  
**I want to** remove a specific sandwich from my cart  
**So that** I can correct mistakes or change my mind about certain items

**Acceptance Criteria:**
- User can tap a delete/trash icon on any cart item
- A confirmation dialog appears: "Remove this item from cart?"
- On confirmation, the item is removed and totals recalculate
- UI updates to show remaining items or "Your cart is empty" message
- Action can be cancelled from the dialog

### 2.3 Clear Entire Cart
**As a** customer  
**I want to** remove all items from my cart at once  
**So that** I can start over quickly when changing my entire order

**Acceptance Criteria:**
- User can tap a "Clear Cart" button (visible when cart has items)
- A confirmation dialog appears: "Remove all items from cart?"
- On confirmation, all items are removed and total resets to $0.00
- UI displays empty cart state with appropriate messaging
- Action can be cancelled from the dialog

### 2.4 Modify Sandwich Size
**As a** customer  
**I want to** change a sandwich from 6-inch to footlong (or vice versa)  
**So that** I can adjust portion sizes without re-adding the item

**Acceptance Criteria:**
- User can toggle between "6-inch" and "Footlong" using a segmented control or switch
- Size change updates the line price immediately (via Pricing repository)
- Quantity, bread type, and notes remain unchanged
- Visual feedback indicates the current selection

### 2.5 Modify Bread Type
**As a** customer  
**I want to** change the bread type of a sandwich in my cart  
**So that** I can customize my order without removing and re-adding

**Acceptance Criteria:**
- User can select from dropdown: White, Wheat, Wholemeal
- Bread type change updates the item configuration
- Price remains unchanged (pricing is size/quantity-based only)
- Current selection is clearly indicated

### 2.6 Edit Item Notes
**As a** customer  
**I want to** add or edit special instructions for a sandwich  
**So that** I can communicate preparation preferences (e.g., "extra mayo", "no tomatoes")

**Acceptance Criteria:**
- User can tap an edit icon to open note input field
- Note field accepts up to 200 characters
- Changes save automatically or on "Done" action
- Notes display on cart item when present
- Price remains unchanged

---

## 3. Technical Requirements

### 3.1 Data Model Updates

#### 3.1.1 Sandwich Model
```dart
// filepath: lib/models/sandwich.dart
class Sandwich {
  final SandwichType type;
  final SandwichSize size; // enum: sixInch, footlong
  final BreadType breadType; // enum: white, wheat, wholemeal
  final String? notes;
  
  // Add equality operators for unique identification
  @override
  bool operator ==(Object other);
  
  @override
  int get hashCode;
  
  // Add copyWith for modifications
  Sandwich copyWith({
    SandwichType? type,
    SandwichSize? size,
    BreadType? breadType,
    String? notes,
  });
}
```

---

## 4. Newly Added Features

### 4.1 Profile Screen

- Add a new Profile screen where users can enter and view their details (name and email).
- No authentication or data persistence is required for now.
- Add a button at the bottom of the order screen to navigate to the Profile screen.
- The Profile screen should allow users to enter their name and email, and save (show a confirmation message).
- Write widget tests for the Profile screen to verify UI elements and save functionality.

### 4.2 Checkout Screen

- Added a checkout screen that displays an order summary, total price, and simulates payment processing.
- After payment, shows an order confirmation message and estimated time.
- Clears the cart and returns to the order screen after successful checkout.

### 4.3 About Screen

- Added an About screen with information about the Sandwich Shop.
- Accessible from the app for users to learn more about the business.