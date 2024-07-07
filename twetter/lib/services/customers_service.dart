import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/customer.dart';

class CustomerService {
  static const String _boxName = 'customers';

  // Create
  Future<void> addCustomer(Customer customer) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.add(customer);
  }

  // Read
  Future<List<Customer>> getAllCustomers() async {
    final box = await Hive.openBox<Customer>(_boxName);
    return box.values.toList();
  }

  Future<int> getNumberOfCustomers() async {
    final box = await Hive.openBox<Customer>(_boxName);
    return box.values.length;
  }

  Future<Customer?> getCustomer(int index) async {
    final box = await Hive.openBox<Customer>(_boxName);
    return box.getAt(index);
  }

  // Update
  Future<void> updateCustomer(int index, Customer updatedCustomer) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.putAt(index, updatedCustomer);
  }

  // Delete
  Future<void> deleteCustomer(int index) async {
    final box = await Hive.openBox<Customer>(_boxName);
    await box.deleteAt(index);
  }
}
