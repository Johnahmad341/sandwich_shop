# Feature Request: Cart Item Modification in Flutter Sandwich Shop

Context:

-   App has two pages:
    -   Order Screen: users select sandwiches and add them to cart.
    -   Cart Screen: users view cart items and total price.
-   Models:
    -   Sandwich: type (enum or id), size (footlong or six-inch), bread type (white, wheat, wholemeal).
    -   Cart: add/remove/clear methods, total price calculation.
-   Repository:
    -   Pricing: calculates prices based on quantity and size only (independent of sandwich type or bread).
-   Platform: Flutter (Material), Windows dev, VS Code.

Goal:Implement cart item modification features on the Cart Screen.

Requirements (implement each as a user-facing interaction with clear behaviors):

1.  Change Quantity
    
    -   Description: Allow users to increase or decrease the quantity of a specific cart item.
    -   Actions:
        -   Tap "+" increases the item’s quantity by 1 (up to a reasonable max, e.g., 99).
        -   Tap "−" decreases the item’s quantity by 1; if quantity reaches 0, confirm removal or auto-remove.
        -   Direct edit: optional numeric input (with validation: min 0, max 99).
    -   Effects:
        -   Cart model updates quantity immediately.
        -   Total price recalculates via Pricing repository based on size and quantity.
        -   UI reflects new quantity and updated line total and cart total.
        -   Persist notes or configuration (size, bread) unchanged.
2.  Remove Item
    
    -   Description: Allow users to remove a specific item from the cart.
    -   Actions:
        -   Tap a trash/delete icon on the cart item.
        -   Show a confirm dialog (“Remove this item?”).
        -   On confirm, remove the item from the cart.
    -   Effects:
        -   Cart model removes the item.
        -   Total price recalculates.
        -   UI updates: item disappears; if cart empty, show “Your cart is empty”.
3.  Clear Cart
    
    -   Description: Allow users to remove all items at once.
    -   Actions:
        -   Tap a “Clear Cart” button.
        -   Show a confirm dialog (“Remove all items?”).
        -   On confirm, call `cart.clear()`.
    -   Effects:
        -   Cart model clears.
        -   Total price resets to 0.
        -   UI updates to empty state message.
4.  Modify Size per Item (optional but supported)
    
    -   Description: Let users toggle a cart item between footlong and six-inch.
    -   Actions:
        -   A size toggle (Switch or segmented control) per item.
        -   Changing size updates the item’s size.
    -   Effects:
        -   Recalculate line price via Pricing.
        -   Update any image/preview if shown.
        -   Keep quantity and bread unchanged.
5.  Modify Bread Type per Item (optional but supported)
    
    -   Description: Let users change bread type for a cart item.
    -   Actions:
        -   Dropdown with BreadType values (white, wheat, wholemeal).
        -   Selecting a value updates the item.
    -   Effects:
        -   Price remains unchanged (Pricing depends only on size and quantity).
        -   UI reflects new bread type.
6.  Edit Notes (optional)
    
    -   Description: Allow editing a per-item note (special instructions).
    -   Actions:
        -   Tap an edit icon or inline TextField to update note.
    -   Effects:
        -   Persist note with item; price unaffected.
        -   Validate length (e.g., max 200 chars).

Technical Guidance:

-   Cart API:
    -   Ensure methods exist or are added:
        -   `setQuantity(Sandwich sandwich, int quantity)`
        -   `remove(Sandwich sandwich)`
        -   `clear()`
        -   `getQuantity(Sandwich sandwich)`
        -   If items include notes/variants, use a key that uniquely identifies item config (type + size + bread + note).
-   Pricing:
    -   Use existing repository to compute price per item:
        -   `Pricing.getLinePrice({required bool isFootlong, required int quantity})`
    -   Cart total: sum of all line prices.

UI/State:

-   Cart Screen:
    -   Each item row: name, size, bread, quantity controls (+/−), delete icon, optional note edit.
    -   Line total shown per item; cart total shown at the bottom.
    -   Disable actions while a dialog is open; show snackbars for confirmation (“Item removed”, “Quantity updated”).
-   State updates:
    -   Wrap mutations in `setState()` (or use a state management solution if present).
    -   Ensure asset paths for images use id + size (e.g., `assets/images/<id>_<size>.jpg`), and that pubspec includes `assets/images/`.

Validation:

-   Quantity bounds: 0–99.
-   Dialog confirmations for destructive actions (remove, clear).
-   Ensure cart recomputes totals after every modification.

Deliverables:

-   Updated Cart methods to support quantity changes and removal.
-   Cart Screen UI with controls and dialogs.
-   Tests:
    -   Unit tests for Cart: setQuantity, remove, clear, total recalculation with Pricing.
    -   Widget tests: tapping +/− updates quantity and totals; delete removes item; clear empties cart.

Please provide:

-   Dart code changes (Cart, Pricing usage, Cart Screen UI).
-   Any needed updates to models to uniquely identify items (size/bread/note).
-   Unit and widget tests examples.
-   Notes on edge cases and accessibility (button semantics, focus order).