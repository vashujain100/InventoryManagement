import 'package:flutter/material.dart';

import '../data.dart';
import '../models/customer.dart';
import '../models/order.dart';

class OrderDialog extends StatefulWidget {
  final Customer customer;

  const OrderDialog({Key? key, required this.customer}) : super(key: key);

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  String piece = '';
  Map<String, int> sizesQuantityMap = {};
  double totalPayment = 0.0;
  double paymentDone = 0.0;
  double paymentDue = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Order'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Customer Name: ${widget.customer.name}'),
            TextField(
              decoration: InputDecoration(labelText: 'Piece'),
              onChanged: (value) {
                piece = value;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Size:Quantity'),
              onChanged: (value) {
                List<String> parts = value.split(':');
                if (parts.length == 2) {
                  sizesQuantityMap[parts[0]] = int.tryParse(parts[1]) ?? 0;
                }
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Total Payment'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                totalPayment = double.tryParse(value) ?? 0.0;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Payment Done'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                paymentDone = double.tryParse(value) ?? 0.0;
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Payment Due'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                paymentDue = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (piece.isNotEmpty &&
                    sizesQuantityMap.isNotEmpty &&
                    totalPayment > 0 &&
                    paymentDone >= 0 &&
                    paymentDue >= 0) {
                  // Check if the piece is in stock
                  bool pieceExists = Data.pieces
                      .any((piece) => piece.pieceNumber == this.piece);
                  if (!pieceExists) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Piece not found in stock.'),
                    ));
                    return;
                  }

                  Order newOrder = Order(
                    piece: piece,
                    sizesQuantityMap: sizesQuantityMap,
                    date: DateTime.now(),
                    customerName: widget.customer.name,
                    totalPayment: totalPayment,
                    paymentDone: paymentDone,
                    paymentDue: paymentDue,
                  );
                  Data.orders.add(newOrder);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill all the fields correctly.'),
                  ));
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
