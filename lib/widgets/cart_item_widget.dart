import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CartItemWidget extends StatefulWidget {
  final Sandwich sandwich;
  final int quantity;
  final VoidCallback onDelete;
  final void Function(int newQuantity) onQuantityChanged;
  final void Function(Sandwich updatedSandwich) onItemUpdated;

  const CartItemWidget({
    super.key,
    required this.sandwich,
    required this.quantity,
    required this.onDelete,
    required this.onQuantityChanged,
    required this.onItemUpdated,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  final PricingRepository _pricingRepository = PricingRepository();
  final TextEditingController _notesController = TextEditingController();
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.sandwich.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _lineTotal {
    return _pricingRepository.calculatePrice(
      quantity: widget.quantity,
      isFootlong: widget.sandwich.isFootlong,
    );
  }

  void _incrementQuantity() {
    if (widget.quantity < 99) {
      widget.onQuantityChanged(widget.quantity + 1);
    }
  }

  void _decrementQuantity() {
    if (widget.quantity > 1) {
      widget.onQuantityChanged(widget.quantity - 1);
    } else {
      _showRemoveConfirmation();
    }
  }

  void _showRemoveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Item'),
          content: const Text('Remove this item from cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete();
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSize(bool isFootlong) {
    final updatedSandwich = widget.sandwich.copyWith(isFootlong: isFootlong);
    widget.onItemUpdated(updatedSandwich);
  }

  void _changeBreadType(BreadType? breadType) {
    if (breadType != null) {
      final updatedSandwich = widget.sandwich.copyWith(breadType: breadType);
      widget.onItemUpdated(updatedSandwich);
    }
  }

  void _saveNotes() {
    final notes = _notesController.text.trim();
    final updatedSandwich = widget.sandwich.copyWith(
      notes: notes.isEmpty ? null : notes,
    );
    widget.onItemUpdated(updatedSandwich);
    setState(() => _isEditingNotes = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.sandwich.name,
                    style: heading2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _showRemoveConfirmation,
                  tooltip: 'Remove item',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Size Toggle
            Row(
              children: [
                const Text('Size: ', style: normalText),
                const Text('6-inch', style: normalText),
                Switch(
                  value: widget.sandwich.isFootlong,
                  onChanged: _toggleSize,
                ),
                const Text('Footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 8),

            // Bread Type Dropdown
            Row(
              children: [
                const Text('Bread: ', style: normalText),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<BreadType>(
                    value: widget.sandwich.breadType,
                    isExpanded: true,
                    items: BreadType.values.map((BreadType bread) {
                      return DropdownMenuItem<BreadType>(
                        value: bread,
                        child: Text(
                          bread.name[0].toUpperCase() + bread.name.substring(1),
                          style: normalText,
                        ),
                      );
                    }).toList(),
                    onChanged: _changeBreadType,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Notes Section
            if (!_isEditingNotes && (widget.sandwich.notes?.isNotEmpty ?? false))
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notes: ${widget.sandwich.notes}',
                      style: normalText.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => setState(() => _isEditingNotes = true),
                    tooltip: 'Edit notes',
                  ),
                ],
              ),
            if (!_isEditingNotes && (widget.sandwich.notes?.isEmpty ?? true))
              TextButton.icon(
                onPressed: () => setState(() => _isEditingNotes = true),
                icon: const Icon(Icons.add),
                label: const Text('Add notes'),
              ),
            if (_isEditingNotes)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _notesController,
                    maxLength: 200,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Special instructions',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _notesController.text = widget.sandwich.notes ?? '';
                          setState(() => _isEditingNotes = false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _saveNotes,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 12),

            // Quantity Controls and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Qty: ', style: normalText),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _decrementQuantity,
                      tooltip: 'Decrease quantity',
                    ),
                    Text(
                      '${widget.quantity}',
                      style: heading2,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: widget.quantity < 99 ? _incrementQuantity : null,
                      tooltip: 'Increase quantity',
                    ),
                  ],
                ),
                Text(
                  '£${_lineTotal.toStringAsFixed(2)}',
                  style: heading2.copyWith(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
