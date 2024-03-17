import 'package:flutter/material.dart';
import 'package:twetter/screens/order_screen.dart';
import 'package:twetter/screens/stock_screen.dart';

import 'customer_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildTile(
                      context: context,
                      icon: Icons.person,
                      label: 'Customers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerScreen(),
                          ),
                        );
                      },
                    ),
                    _buildTile(
                      context: context,
                      icon: Icons.ac_unit_outlined,
                      label: 'Stock',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StockScreen(),
                          ),
                        );
                      },
                    ),
                    _buildTile(
                      context: context,
                      icon: Icons.person,
                      label: 'Order \n History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMetricCard(
                      context: context,
                      icon: Icons.shopping_cart,
                      label: 'Total Orders',
                      value: '1,245',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                    _buildMetricCard(
                      context: context,
                      icon: Icons.pending,
                      label: 'Pending Orders',
                      value: '32',
                      iconColor: Theme.of(context).splashColor,
                    ),
                    _buildMetricCard(
                      context: context,
                      icon: Icons.warning,
                      label: 'Low Stock Items',
                      value: '8',
                      iconColor: Colors.orange,
                    ),
                    _buildMetricCard(
                      context: context,
                      icon: Icons.star,
                      label: 'Top Selling Product',
                      value: 'Product XYZ',
                      iconColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
