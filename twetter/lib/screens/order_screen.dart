import 'package:flutter/material.dart';

import '../data.dart';
import '../models/order.dart';
import '../widgets/order_details_dialog.dart';
import '../widgets/order_dialog.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.grey[300]!,
          ),
          columns: const [
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Piece')),
            DataColumn(label: Text('Size')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Total Payment')),
            DataColumn(label: Text('Payment Done')),
            DataColumn(label: Text('Payment Due')),
          ],
          rows: Data.orders.map((order) {
            return DataRow(
              cells: [
                DataCell(Text(order.customerName)),
                DataCell(Text(order.piece)),
                DataCell(
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order.sizesQuantityMap.entries
                          .map((entry) => Text(entry.key))
                          .toList(),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: order.sizesQuantityMap.entries
                          .map((entry) => Text(entry.value.toString()))
                          .toList(),
                    ),
                  ),
                ),
                DataCell(Text(order.date.toIso8601String().split('T')[0])),
                DataCell(Text('\$${order.totalPayment.toStringAsFixed(2)}')),
                DataCell(Text('\$${order.paymentDone.toStringAsFixed(2)}')),
                DataCell(Text('\$${order.paymentDue.toStringAsFixed(2)}')),
              ],
              onSelectChanged: (selected) {
                _showOrderDetailsDialog(context, order);
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrderDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDetailsDialog(order: order);
      },
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDialog(
          customer: null,
        );
      },
    );
  }
}
