import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../data.dart';
import '../models/customer.dart';
import 'customer_details_screen.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: ListView.builder(
        itemCount: Data.customers.length,
        itemBuilder: (context, index) {
          final customer = Data.customers[index];
          final totalPaymentPending = _calculateTotalPaymentPending(customer);
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(customer.name),
              subtitle: Text(
                  'Total Payment Pending: \$${totalPaymentPending.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerDetailsScreen(customer: customer),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCustomerDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  double _calculateTotalPaymentPending(Customer customer) {
    double totalPaymentPending = 0.0;
    for (var order in Data.orders) {
      if (order.customerName == customer.name) {
        totalPaymentPending += order.paymentDue;
      }
    }
    return totalPaymentPending;
  }

  void _addCustomerDialog(BuildContext context) {
    String name = '';
    String contactNo = '';

    final nameController = TextEditingController();
    final contactNoController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => name = newValue!,
                ),
                TextFormField(
                  controller: contactNoController,
                  decoration: InputDecoration(labelText: 'Contact No.'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length != 10) {
                      return 'Contact number must be 10 digits';
                    }
                    return null;
                  },
                  onSaved: (newValue) => contactNo = newValue!,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newCustomer = Customer(
                    id: const Uuid().v4(),
                    name: name,
                    contactNo: contactNo.isEmpty ? null : contactNo,
                  );
                  setState(() {
                    Data.customers.add(newCustomer);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
