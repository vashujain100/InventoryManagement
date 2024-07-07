import 'package:hive_flutter/hive_flutter.dart';

import '../models/order.dart';

class OrdersService {
  static const String _boxName = 'orders';

  Future<void> addOrder(Order order) async {
    final box = await Hive.openBox<Order>(_boxName);
    await box.add(order);
  }

  Future<List<Order>> getAllOrders() async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values.toList();
  }

  Future<List<Order>> getOrdersByCustomerName(String customerName) async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values
        .where((order) =>
            order.customerName.toLowerCase() == customerName.toLowerCase())
        .toList();
  }

  Future<int> getNumberOfOrders() async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.values.length;
  }

  Future<Order?> getOrder(int index) async {
    final box = await Hive.openBox<Order>(_boxName);
    return box.getAt(index);
  }

  Future<void> updateOrder(int index, Order updatedOrder) async {
    final box = await Hive.openBox<Order>(_boxName);
    await box.putAt(index, updatedOrder);
  }

  Future<void> deleteOrder(int index) async {
    final box = await Hive.openBox<Order>(_boxName);
    await box.deleteAt(index);
  }
}
