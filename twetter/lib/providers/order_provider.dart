// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../models/order.dart';
//
// class OrderProvider {
//   final SharedPreferences _prefs;
//
//   OrderProvider(this._prefs);
//
//   List<Order> get orders {
//     final ordersJson = _prefs.getString('orders');
//     if (ordersJson != null) {
//       final List<dynamic> parsedJson = jsonDecode(ordersJson);
//       return parsedJson.map((json) => Order.fromJson(json)).toList();
//     }
//     return [];
//   }
//
//   void addOrder(Order newOrder) {
//     final List<Order> updatedOrders = [...orders, newOrder];
//     _prefs.setString('orders', jsonEncode(updatedOrders));
//   }
//
//   // void updateOrder(Order updatedOrder) {
//   //   final List<Order> updatedOrders = orders.map((order) {
//   //     return order.id == updatedOrder.id ? updatedOrder : order;
//   //   }).toList();
//   //   _prefs.setString('orders', jsonEncode(updatedOrders));
//   // }
//   //
//   // void removeOrder(String orderId) {
//   //   final List<Order> updatedOrders =
//   //   orders.where((order) => order.id != orderId).toList();
//   //   _prefs.setString('orders', jsonEncode(updatedOrders));
//   // }
// }
