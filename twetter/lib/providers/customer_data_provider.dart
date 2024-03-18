import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';

class CustomerProvider {
  final SharedPreferences _prefs;

  CustomerProvider(this._prefs);

  List<Customer> get customers {
    final customersJson = _prefs.getString('customers');
    if (customersJson != null) {
      final List<dynamic> parsedJson = jsonDecode(customersJson);
      return parsedJson.map((json) => Customer.fromJson(json)).toList();
    }
    return [];
  }

  void addCustomer(Customer newCustomer) {
    final List<Customer> updatedCustomers = [...customers, newCustomer];
    _prefs.setString('customers', jsonEncode(updatedCustomers));
  }

  void updateCustomer(Customer updatedCustomer) {
    final List<Customer> updatedCustomers = customers.map((customer) {
      return customer.id == updatedCustomer.id ? updatedCustomer : customer;
    }).toList();
    _prefs.setString('customers', jsonEncode(updatedCustomers));
  }

  void removeCustomer(String customerId) {
    final List<Customer> updatedCustomers =
        customers.where((customer) => customer.id != customerId).toList();
    _prefs.setString('customers', jsonEncode(updatedCustomers));
  }
}
