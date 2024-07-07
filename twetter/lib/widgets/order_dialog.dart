import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../models/order.dart';
import '../models/piece.dart';
import '../services/customers_service.dart';
import '../services/orders_services.dart';
import '../services/pieces_services.dart';
import '../widgets/size_quantity_entry_widget.dart';

class OrderDialog extends StatefulWidget {
  final Customer? customer;
  final void Function(Order) onOrderPlaced;

  const OrderDialog({
    Key? key,
    this.customer,
    required this.onOrderPlaced,
  }) : super(key: key);

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerService = CustomerService();
  final _orderService = OrdersService();
  final _pieceService = PiecesService();

  late Future<void> _initFuture;
  List<Customer> _customers = [];
  List<Piece> _pieces = [];

  Piece? _selectedPiece;
  Map<String, int> _selectedSizeQuantityMap = {};
  String _customerName = '';
  double _totalPayment = 0.0;
  double _paymentDone = 0.0;

  @override
  void initState() {
    super.initState();
    _customerName = widget.customer?.name ?? '';
    _initFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final customersF = _customerService.getAllCustomers();
    final piecesF = _pieceService.getAllPieces();

    final results = await Future.wait([customersF, piecesF]);

    setState(() {
      _customers = results[0] as List<Customer>;
      _pieces = results[1] as List<Piece>;
      _selectedPiece = _pieces.isNotEmpty ? _pieces[0] : null;
    });
  }

  void _updateSelectedPiece(String? pieceId) {
    setState(() {
      _selectedPiece = _pieces.firstWhere((p) => p.id == pieceId);
      _selectedSizeQuantityMap.clear();
    });
  }

  bool _validateSizesAndQuantities() {
    if (_selectedSizeQuantityMap.isEmpty) {
      _showSnackBar('Please select at least one size and quantity');
      return false;
    }

    for (var entry in _selectedSizeQuantityMap.entries) {
      final availableQuantity =
          _selectedPiece!.sizesQuantityMap[entry.key] ?? 0;
      if (entry.value <= 0 || entry.value > availableQuantity) {
        _showSnackBar('Invalid quantity for size ${entry.key}');
        return false;
      }
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  bool _placeOrder() {
    if (!_formKey.currentState!.validate() || !_validateSizesAndQuantities()) {
      return false;
    }

    _formKey.currentState!.save();

    final customer = _customers.firstWhereOrNull(
      (c) => c.name.toLowerCase() == _customerName.toLowerCase(),
    );

    if (customer == null) {
      _showSnackBar('Customer not found');
      return false;
    }

    if (_selectedPiece == null) {
      _showSnackBar('Please select a piece');
      return false;
    }

    final paymentDue = _totalPayment - _paymentDone;
    if (paymentDue < 0) {
      _showSnackBar('Payment done cannot be greater than total payment');
      return false;
    }

    final newOrder = Order(
      piece: _selectedPiece!.pieceNumber,
      sizesQuantityMap: Map.from(_selectedSizeQuantityMap),
      date: DateTime.now(),
      customerName: _customerName,
      customerId: customer.id,
      totalPayment: _totalPayment,
      paymentDone: _paymentDone,
      paymentDue: paymentDue,
    );

    final updatedPiece = Piece(
      id: _selectedPiece!.id,
      pieceNumber: _selectedPiece!.pieceNumber,
      sizesQuantityMap: Map.from(_selectedPiece!.sizesQuantityMap),
    );

    for (var entry in _selectedSizeQuantityMap.entries) {
      updatedPiece.sizesQuantityMap[entry.key] =
          (updatedPiece.sizesQuantityMap[entry.key] ?? 0) - entry.value;
    }

    _pieceService.updatePiece(updatedPiece);
    _orderService.addOrder(newOrder);
    widget.onOrderPlaced(newOrder);

    _showSnackBar('Order placed successfully');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AlertDialog(content: CircularProgressIndicator());
        }

        if (_pieces.isEmpty) {
          return AlertDialog(
            title: Text('Error',
                style: TextStyle(color: Theme.of(context).errorColor)),
            content: Text("Please add pieces first"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        }

        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Add New Order',
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    _buildCustomerField(),
                    SizedBox(height: 16),
                    _buildPieceDropdown(),
                    SizedBox(height: 16),
                    Text('Sizes and Quantities',
                        style: Theme.of(context).textTheme.subtitle1),
                    ..._buildSizeQuantityFields(),
                    SizedBox(height: 16),
                    _buildPaymentFields(),
                    SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerField() {
    return widget.customer != null
        ? Text(
            'Customer: ${widget.customer!.name}',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        : Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return _customers
                  .where((customer) => customer.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()))
                  .map((customer) => customer.name);
            },
            onSelected: (String selection) {
              setState(() {
                _customerName = selection;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  if (!_customers.any((customer) =>
                      customer.name.toLowerCase() == value.toLowerCase())) {
                    return 'Customer not found';
                  }
                  return null;
                },
                onSaved: (value) => _customerName = value!,
              );
            },
          );
  }

  Widget _buildPieceDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPiece?.id,
      items: _pieces
          .map((piece) => DropdownMenuItem<String>(
                value: piece.id,
                child: Text(piece.pieceNumber),
              ))
          .toList(),
      onChanged: _updateSelectedPiece,
      decoration: InputDecoration(
        labelText: 'Select Piece',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value == null ? 'Please select a piece' : null,
    );
  }

  List<Widget> _buildSizeQuantityFields() {
    return _selectedPiece?.sizesQuantityMap.entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizeQuantityEntryWidget(
                    size: entry.key,
                    availableQuantity: entry.value,
                    onQuantityChanged: (value) {
                      setState(() {
                        if (value > 0) {
                          _selectedSizeQuantityMap[entry.key] = value;
                        } else {
                          _selectedSizeQuantityMap.remove(entry.key);
                        }
                      });
                    },
                  ),
                ))
            .toList() ??
        [];
  }

  Widget _buildPaymentFields() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Total Payment',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.currency_rupee_outlined),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) => value == null ||
                  double.tryParse(value) == null ||
                  double.parse(value) <= 0
              ? 'Please enter a valid total payment'
              : null,
          onSaved: (value) => _totalPayment = double.parse(value!),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Payment Done',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.payment),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) => value == null ||
                  double.tryParse(value) == null ||
                  double.parse(value) < 0
              ? 'Please enter a valid payment done'
              : null,
          onSaved: (value) => _paymentDone = double.parse(value!),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            if (_placeOrder()) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Place Order'),
        ),
      ],
    );
  }
}
