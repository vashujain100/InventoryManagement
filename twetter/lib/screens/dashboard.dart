import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:twetter/screens/customer_screen.dart';
import 'package:twetter/screens/stock_screen.dart';

import '../services/orders_services.dart';
import '../services/pieces_services.dart';
import '../widgets/dashboard_tile.dart';
import 'order_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final OrdersService _ordersService = OrdersService();
  final PiecesService _piecesService = PiecesService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              _controller.reset();
              _controller.forward();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Text(
                      'Welcome back!',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildAnimatedTile(
                          DashboardTile(
                            title: 'Customers',
                            icon: Icons.people,
                            color: Theme.of(context).colorScheme.tertiary,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerScreen())),
                          ),
                        ),
                        _buildAnimatedTile(
                          DashboardTile(
                            title: 'Stock',
                            icon: Icons.inventory,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StockScreen())),
                          ),
                        ),
                        _buildAnimatedTile(
                          DashboardTile(
                            title: 'Orders',
                            icon: Icons.shopping_cart,
                            color: Theme.of(context).colorScheme.secondary,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreen())),
                          ),
                        ),
                        _buildAnimatedTile(
                          DashboardTile(
                              title: 'Reports',
                              icon: Icons.bar_chart,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () {
                                // Navigator.pushNamed(context, '/reports'),
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildQuickStats(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTile(Widget child) {
    return ScaleTransition(
      scale: _animation,
      child: child,
    );
  }

  Widget _buildQuickStats() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadDashboardData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data!;
          return Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Stats',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildQuickStat(context, 'Total Orders',
                      data['totalOrders'].toString(), Icons.shopping_basket),
                  _buildQuickStat(
                      context,
                      'Pending Payment',
                      '₹${data['pendingPayment'].toStringAsFixed(2)}',
                      Icons.payment),
                  _buildQuickStat(context, 'Low Stock Items',
                      data['lowStockItems'].toString(), Icons.warning),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildQuickStat(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.subtitle2),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final orders = await _ordersService.getAllOrders();
    final pieces = await _piecesService.getAllPieces();

    int totalOrders = orders.length;
    double pendingPayment =
        orders.fold(0, (sum, order) => sum + order.paymentDue);
    int lowStockItems = pieces
        .where((piece) =>
            piece.sizesQuantityMap.values.any((quantity) => quantity < 5))
        .length;

    return {
      'totalOrders': totalOrders,
      'pendingPayment': pendingPayment,
      'lowStockItems': lowStockItems,
    };
  }
}
