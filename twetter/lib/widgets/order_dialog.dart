// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:twetter/services/customers_service.dart';
// import 'package:twetter/services/orders_services.dart';
//
// import '../models/customer.dart';
// import '../models/order.dart';
// import '../models/piece.dart';
// import '../services/pieces_services.dart';
// import '../widgets/size_quantity_entry_widget.dart';
//
// class OrderDialog extends StatefulWidget {
//   final Customer? customer;
//   final void Function(Order)? onOrderPlaced;
//
//   const OrderDialog({
//     Key? key,
//     required this.customer,
//     required this.onOrderPlaced,
//   }) : super(key: key);
//
//   @override
//   _OrderDialogState createState() => _OrderDialogState();
// }
//
// class _OrderDialogState extends State<OrderDialog> {
//   final _formKey = GlobalKey<FormState>();
//   var _selectedPiece;
//   Map<String, int> _availableSizeQuantityMap = {};
//   Map<String, int> _selectedSizeQuantityMap = {};
//   final _customerService = CustomerService();
//   List<Customer> _customers = [];
//   final _orderService = OrdersService();
//   List<Order> _customerOrders = [];
//   final _pieceService = PiecesService();
//   List<Piece> _pieces = [];
//
//   Future<void> _loadPieces() async {
//     final pieces = await _pieceService.getAllPieces();
//     setState(() {
//       _pieces = pieces;
//     });
//   }
//
//   double _totalPayment = 0.0;
//   double _paymentDone = 0.0;
//   String _customerName = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomers();
//     _loadOrders();
//     _loadPieces();
//     _customerName = widget.customer?.name ?? '';
//
//     // _updateSelectedSizeQuantityMap();
//   }
//
//   Future<void> _loadCustomers() async {
//     final customers = await _customerService.getAllCustomers();
//     setState(() {
//       _customers = customers;
//     });
//   }
//
//   Future<void> _loadOrders() async {
//     final orders = await _orderService.getAllOrders();
//     setState(() {
//       _customerOrders = orders;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_pieces.isNotEmpty) {
//       _selectedPiece = _pieces[1];
//     }
//
//     return (_selectedPiece == null)
//         ? const AlertDialog(
//             content: Text("Please add piece"),
//           )
//         : AlertDialog(
//             title: const Text('Add Order'),
//             content: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     if (widget.customer != null)
//                       Text(
//                         'Customer Name: ${widget.customer!.name}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       )
//                     else
//                       TextFormField(
//                         initialValue: _customerName,
//                         decoration: const InputDecoration(
//                           labelText: 'Customer Name',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter customer name';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => _customerName = value!,
//                       ),
//                     const SizedBox(height: 16),
//                     DropdownButtonFormField<String>(
//                       value: _selectedPiece.id,
//                       items: _pieces
//                           .map((piece) => DropdownMenuItem<String>(
//                                 value: piece.id,
//                                 child: Text(piece.pieceNumber),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedPiece = _findPieceById(value);
//                           _updateSelectedSizeQuantityMap();
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Select Piece',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ..._availableSizeQuantityMap.entries
//                         .map((entry) => SizeQuantityEntryWidget(
//                               size: entry.key,
//                               availableQuantity: entry.value,
//                               onQuantityChanged: (value) {
//                                 setState(() {
//                                   _selectedSizeQuantityMap[entry.key] = value;
//                                 });
//                               },
//                             ))
//                         .toList(),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue: _totalPayment != 0.0
//                           ? _totalPayment.toString()
//                           : null,
//                       decoration: const InputDecoration(
//                         labelText: 'Total Payment',
//                       ),
//                       keyboardType:
//                           const TextInputType.numberWithOptions(decimal: true),
//                       validator: (value) {
//                         if (value == null ||
//                             double.tryParse(value) == null ||
//                             double.parse(value) <= 0) {
//                           return 'Please enter a valid total payment';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) => _totalPayment = double.parse(value!),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue:
//                           _paymentDone != 0.0 ? _paymentDone.toString() : null,
//                       decoration: const InputDecoration(
//                         labelText: 'Payment Done',
//                       ),
//                       keyboardType:
//                           const TextInputType.numberWithOptions(decimal: true),
//                       validator: (value) {
//                         if (value == null ||
//                             double.tryParse(value) == null ||
//                             double.parse(value) < 0) {
//                           return 'Please enter a valid payment done';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) => _paymentDone = double.parse(value!),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     double paymentDue = _totalPayment - _paymentDone;
//                     if (paymentDue < 0) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                               'Payment done cannot be greater than total payment'),
//                         ),
//                       );
//                       return;
//                     }
//
//                     bool isOrderPlaced = _placeOrder(
//                       context,
//                       _selectedPiece.pieceNumber,
//                       _customerName,
//                       widget.customer?.id,
//                       _selectedSizeQuantityMap,
//                       _totalPayment,
//                       _paymentDone,
//                       paymentDue,
//                     );
//                     if (isOrderPlaced) {
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 },
//                 child: const Text('Place Order'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancel'),
//               ),
//             ],
//           );
//   }
//
//   void _updateSelectedSizeQuantityMap() {
//     setState(() {
//       _availableSizeQuantityMap = Map.from(_selectedPiece.sizesQuantityMap);
//     });
//   }
//
//   bool _placeOrder(
//     BuildContext context,
//     String pieceNumber,
//     String customerName,
//     String? customerId,
//     Map<String, int> sizeQuantityMap,
//     double totalPayment,
//     double paymentDone,
//     double paymentDue,
//   ) {
//     Piece? piece =
//         _pieces.firstWhereOrNull((p) => p.pieceNumber == pieceNumber);
//     if (piece == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Piece not found in stock')),
//       );
//       return false;
//     }
//
//     bool hasInsufficientStock = false;
//
//     for (MapEntry<String, int> entry in sizeQuantityMap.entries) {
//       String size = entry.key;
//       int quantity = entry.value;
//
//       if (piece.sizesQuantityMap.containsKey(size)) {
//         int currentQuantity = piece.sizesQuantityMap[size]!;
//         if (currentQuantity >= quantity) {
//           piece.sizesQuantityMap[size] = currentQuantity - quantity;
//         } else {
//           hasInsufficientStock = true;
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Size $size not found in stock')),
//         );
//         return false;
//       }
//     }
//
//     if (hasInsufficientStock) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Insufficient stock for some sizes'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return false;
//     }
//
//     Customer? customer =
//         _customers.firstWhereOrNull((c) => c.name == customerName);
//     if (customer == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Customer not found')),
//       );
//       return false;
//     }
//
//     Order newOrder = Order(
//       piece: pieceNumber,
//       sizesQuantityMap: sizeQuantityMap,
//       date: DateTime.now(),
//       customerName: customerName,
//       customerId: customerId,
//       totalPayment: totalPayment,
//       paymentDone: paymentDone,
//       paymentDue: paymentDue,
//     );
//     _customerOrders.add(newOrder);
//     _loadOrders();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Order placed successfully')),
//     );
//     widget.onOrderPlaced!(newOrder);
//     return true;
//   }
//
//   Piece _findPieceById(String? value) {
//     return _pieces.firstWhere((element) => element.id == value);
//   }
// }

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
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
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
      Navigator.of(context).pop();
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
          return const AlertDialog(content: Text("Please add pieces first"));
        }

        return AlertDialog(
          title: const Text('Add Order'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCustomerField(),
                  const SizedBox(height: 16),
                  _buildPieceDropdown(),
                  const SizedBox(height: 16),
                  ..._buildSizeQuantityFields(),
                  const SizedBox(height: 16),
                  _buildPaymentFields(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_placeOrder()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Place Order'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerField() {
    return widget.customer != null
        ? Text(
            'Customer Name: ${widget.customer!.name}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        : TextFormField(
            initialValue: _customerName,
            decoration: const InputDecoration(labelText: 'Customer Name'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter customer name' : null,
            onSaved: (value) => _customerName = value!,
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
      decoration: const InputDecoration(
        labelText: 'Select Piece',
        border: OutlineInputBorder(),
      ),
    );
  }

  List<Widget> _buildSizeQuantityFields() {
    return _selectedPiece?.sizesQuantityMap.entries
            .map((entry) => SizeQuantityEntryWidget(
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
                ))
            .toList() ??
        [];
  }

  Widget _buildPaymentFields() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Total Payment'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => value == null ||
                  double.tryParse(value) == null ||
                  double.parse(value) <= 0
              ? 'Please enter a valid total payment'
              : null,
          onSaved: (value) => _totalPayment = double.parse(value!),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Payment Done'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
}
