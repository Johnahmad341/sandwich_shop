import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/saved_order.dart';

void main() {
  group('SavedOrder', () {
    testWidgets('creates SavedOrder with all required fields', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      expect(order.id, equals(1));
      expect(order.orderId, equals('ORD123456'));
      expect(order.totalAmount, equals(25.50));
      expect(order.itemCount, equals(3));
      expect(order.orderDate, equals(testDate));
    });

    testWidgets('toMap converts SavedOrder to Map correctly', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder order = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      final Map<String, Object?> map = order.toMap();

      expect(map['orderId'], equals('ORD123456'));
      expect(map['totalAmount'], equals(25.50));
      expect(map['itemCount'], equals(3));
      expect(map['orderDate'], equals(testDate.millisecondsSinceEpoch));
      expect(map.containsKey('id'), isFalse);
    });

    testWidgets('fromMap creates SavedOrder from Map correctly',
        (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final Map<String, Object?> map = {
        'id': 1,
        'orderId': 'ORD123456',
        'totalAmount': 25.50,
        'itemCount': 3,
        'orderDate': testDate.millisecondsSinceEpoch,
      };

      final SavedOrder order = SavedOrder.fromMap(map);

      expect(order.id, equals(1));
      expect(order.orderId, equals('ORD123456'));
      expect(order.totalAmount, equals(25.50));
      expect(order.itemCount, equals(3));
      expect(order.orderDate, equals(testDate));
    });

    testWidgets('toMap and fromMap are inverse operations', (tester) async {
      final DateTime testDate = DateTime(2023, 12, 25, 14, 30);
      final SavedOrder originalOrder = SavedOrder(
        id: 1,
        orderId: 'ORD123456',
        totalAmount: 25.50,
        itemCount: 3,
        orderDate: testDate,
      );

      final Map<String, Object?> map = originalOrder.toMap();
      map['id'] = originalOrder.id;
      final SavedOrder reconstructedOrder = SavedOrder.fromMap(map);

      expect(reconstructedOrder.id, equals(originalOrder.id));
      expect(reconstructedOrder.orderId, equals(originalOrder.orderId));
      expect(reconstructedOrder.totalAmount, equals(originalOrder.totalAmount));
      expect(reconstructedOrder.itemCount, equals(originalOrder.itemCount));
      expect(reconstructedOrder.orderDate, equals(originalOrder.orderDate));
    });

    testWidgets('handles different data types correctly', (tester) async {
      final DateTime testDate = DateTime(2023, 1, 1, 0, 0);
      final SavedOrder order = SavedOrder(
        id: 999,
        orderId: 'ORD999999999',
        totalAmount: 0.01,
        itemCount: 1,
        orderDate: testDate,
      );

      final Map<String, Object?> map = order.toMap();
      map['id'] = order.id;
      final SavedOrder reconstructedOrder = SavedOrder.fromMap(map);

      expect(reconstructedOrder.id, equals(999));
      expect(reconstructedOrder.orderId, equals('ORD999999999'));
      expect(reconstructedOrder.totalAmount, equals(0.01));
      expect(reconstructedOrder.itemCount, equals(1));
      expect(reconstructedOrder.orderDate, equals(testDate));
    });
  });
}
