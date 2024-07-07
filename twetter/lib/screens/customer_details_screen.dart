import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  bool _isLoading = true;
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders =
        await _orderService.getOrdersByCustomerName(widget.customer.name);
    setState(() {
      _customerOrders = orders;
      _customerOrders.sort((a, b) =>
          b.date.compareTo(a.date)); // Sort orders by date, most recent first
      _isLoading = false;
    });
  }

  void _onOrderPlaced(Order newOrder) {
    setState(() {
      _customerOrders.add(newOrder);
      _customerOrders.sort((a, b) =>
          b.date.compareTo(a.date)); // Sort orders by date, most recent first
    });
    // Rebuild the SliverAnimatedList
    _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(child: _buildCustomerInfo()),
              _buildOrdersList(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrderDialog(context),
        icon: Icon(Icons.add),
        label: Text('New Order'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      title: Text(widget.customer.name),
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
    );
  }

  Widget _buildCustomerInfo() {
    double totalPaymentPending =
        _customerOrders.fold(0, (prev, order) => prev + order.paymentDue);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
              'Contact', widget.customer.contactNo ?? 'N/A', Icons.phone),
          SizedBox(height: 16),
          _buildInfoCard(
              'Total Orders', '${_customerOrders.length}', Icons.shopping_cart),
          SizedBox(height: 16),
          _buildInfoCard('Pending Payment',
              '₹${totalPaymentPending.toStringAsFixed(2)}', Icons.payment,
              isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon,
      {bool isHighlighted = false}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isHighlighted ? Theme.of(context).colorScheme.secondary : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon,
                size: 30,
                color: isHighlighted
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).primaryColor),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: isHighlighted
                              ? Theme.of(context).colorScheme.onSecondary
                              : null,
                        )),
                SizedBox(height: 4),
                Text(value,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isHighlighted
                              ? Theme.of(context).colorScheme.onSecondary
                              : null,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_isLoading) {
      return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()));
    }
    if (_customerOrders.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text('No orders yet',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.grey)),
        ),
      );
    }
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: _customerOrders.length,
      itemBuilder: (context, index, animation) {
        final order = _customerOrders[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _buildOrderCard(order),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text('Order: ${order.piece}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text('Date: ${DateFormat('MMM dd, yyyy').format(order.date)}',
            style: Theme.of(context).textTheme.caption),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderDetail('Total Payment',
                    '₹${order.totalPayment.toStringAsFixed(2)}'),
                _buildOrderDetail(
                    'Payment Done', '₹${order.paymentDone.toStringAsFixed(2)}'),
                _buildOrderDetail(
                    'Payment Due', '₹${order.paymentDue.toStringAsFixed(2)}',
                    isHighlighted: true),
                SizedBox(height: 8),
                Text('Sizes and Quantities:',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ...order.sizesQuantityMap.entries.map((entry) =>
                    _buildOrderDetail(entry.key, entry.value.toString())),
              ],
            ),
          ),
        ],
      ),
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

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OrderDialog(
        customer: widget.customer,
        onOrderPlaced: _onOrderPlaced,
      ),
    );
  }
}
