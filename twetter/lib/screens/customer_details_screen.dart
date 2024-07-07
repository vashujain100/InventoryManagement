import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    double totalPaymentPending =
        _customerOrders.fold(0, (prev, order) => prev + order.paymentDue);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCustomerInfo(totalPaymentPending),
          Expanded(child: _buildOrdersList()),
        ],
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildCustomerInfo(double totalPaymentPending) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.customer.name,
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contact: ${widget.customer.contactNo ?? 'N/A'}',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Pending: ₹${totalPaymentPending.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return _customerOrders.isEmpty
        ? Center(
            child: Text(
              'No orders yet',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: _customerOrders.length,
            itemBuilder: (context, index) {
              final order = _customerOrders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  title: Text(
                    'Order: ${order.piece}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(order.date)}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderDetail('Total Payment',
                              '₹${order.totalPayment.toStringAsFixed(2)}'),
                          _buildOrderDetail('Payment Done',
                              '₹${order.paymentDone.toStringAsFixed(2)}'),
                          _buildOrderDetail('Payment Due',
                              '₹${order.paymentDue.toStringAsFixed(2)}',
                              isHighlighted: true),
                          const SizedBox(height: 8),
                          Text('Sizes and Quantities:',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          ...order.sizesQuantityMap.entries.map((entry) =>
                              _buildOrderDetail(
                                  entry.key, entry.value.toString())),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildOrderDetail(String label, String value,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyText2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isHighlighted
                      ? Theme.of(context).colorScheme.secondary
                      : null,
                ),
          ),
        ],
      ),
    );
  }
}
