import 'package:flutter/material.dart';
import 'package:twetter/services/orders_services.dart';

import '../models/customer.dart';
import '../models/order.dart';
import '../widgets/order_dialog.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailsScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _orderService = OrdersService();
  List<Order> _customerOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders =
        await _orderService.getOrdersByCustomerName(widget.customer.name);
    setState(() {
      _customerOrders = orders;
    });
  }

  void _onOrderPlaced(Order newOrder) {
    setState(() {
      _customerOrders.add(newOrder);
      _loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPaymentPending = _customerOrders
        .map((order) => order.paymentDue)
        .fold(0, (prev, amount) => prev + amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${widget.customer.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact No: ${widget.customer.contactNo}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Payment Pending: \$${totalPaymentPending.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Orders:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _customerOrders.length,
                itemBuilder: (context, index) {
                  final order = _customerOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Piece: ${order.piece}'),
                          Text(
                              'Date: ${order.date.toIso8601String().split('T')[0]}'),
                          Text('Total Payment: ${order.totalPayment}'),
                          Text('Payment Done: ${order.paymentDone}'),
                          Text('Payment Due: ${order.paymentDue}'),
                          Text('Sizes and Quantities:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: order.sizesQuantityMap.entries
                                .map((entry) =>
                                    Text('${entry.key}: ${entry.value}'))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => OrderDialog(
              customer: widget.customer,
              onOrderPlaced: _onOrderPlaced,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
