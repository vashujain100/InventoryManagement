import 'package:flutter/material.dart';

import '../data.dart';
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
  List<Order> customerOrders = [];

  @override
  void initState() {
    customerOrders = Data.orders
        .where((order) => order.customerName == widget.customer.name)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${widget.customer.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Total Payment Pending: \$${widget.customer.totalPaymentPending.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Orders:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16.0,
                  columns: [
                    DataColumn(label: Text('Piece')),
                    DataColumn(label: Text('Sizes')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Total Payment')),
                    DataColumn(label: Text('Payment Done')),
                    DataColumn(label: Text('Payment Due')),
                  ],
                  rows: customerOrders
                      .map((order) => DataRow(cells: [
                            DataCell(Text(order.piece)),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: order.sizesQuantityMap.entries
                                    .map((entry) => Text(
                                        'Size: ${entry.key}, Quantity: ${entry.value}'))
                                    .toList(),
                              ),
                            ),
                            DataCell(Text(
                                order.date.toIso8601String().split('T')[0])),
                            DataCell(Text(order.totalPayment.toString())),
                            DataCell(Text(order.paymentDone.toString())),
                            DataCell(Text(order.paymentDue.toString())),
                          ]))
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showAddOrderDialog(context);
              },
              child: Text('Add New Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDialog(customer: widget.customer);
      },
    );
  }
}
