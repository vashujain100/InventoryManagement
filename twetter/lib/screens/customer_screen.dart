import 'package:flutter/material.dart';
import 'package:twetter/services/customers_service.dart';
import 'package:twetter/services/orders_services.dart';
import 'package:uuid/uuid.dart';

import '../models/customer.dart';
import '../models/order.dart';
import 'customer_details_screen.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _customerService = CustomerService();
  final _orderService = OrdersService();
  List<Customer> _customers = [];
  List<Order> _customerOrders = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final customersF = _customerService.getAllCustomers();
    final ordersF = _orderService.getAllOrders();

    final results = await Future.wait([customersF, ordersF]);

    setState(() {
      _customers = results[0] as List<Customer>;
      _customerOrders = results[1] as List<Order>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        elevation: 0,
      ),
      body: _customers.isEmpty ? _buildEmptyState() : _buildCustomerList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCustomerDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline,
              size: 80, color: Theme.of(context).colorScheme.secondary),
          SizedBox(height: 16),
          Text(
            'No customers yet',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          Text(
            'Add your first customer to get started',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList() {
    return ListView.builder(
      itemCount: _customers.length,
      itemBuilder: (context, index) {
        final customer = _customers[index];
        final totalPaymentPending = _calculateTotalPaymentPending(customer);
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                customer.name[0].toUpperCase(),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            title: Text(
              customer.name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Payment Pending: ₹${totalPaymentPending.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color:
                            totalPaymentPending > 0 ? Colors.red : Colors.green,
                      ),
                ),
                if (customer.contactNo != null &&
                    customer.contactNo!.isNotEmpty)
                  Text(
                    'Contact: ${customer.contactNo}',
                    style: Theme.of(context).textTheme.caption,
                  ),
              ],
            ),
            trailing: Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary),
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
    );
  }

  double _calculateTotalPaymentPending(Customer customer) {
    return _customerOrders
        .where((order) => order.customerName == customer.name)
        .fold(0.0, (sum, order) => sum + order.paymentDue);
  }

  void _addCustomerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final contactNoController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer',
              style: Theme.of(context).textTheme.headline6),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: contactNoController,
                  decoration: InputDecoration(
                    labelText: 'Contact No.',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value != null && value.isNotEmpty && value.length != 10
                          ? 'Contact number must be 10 digits'
                          : null,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newCustomer = Customer(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    contactNo: contactNoController.text.isEmpty
                        ? null
                        : contactNoController.text,
                  );
                  _customerService.addCustomer(newCustomer);
                  _loadData();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
