import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/piece.dart';

final _sizeQuantityList = <_SizeQuantityEntry>[];
List<String> _availableSizes = [];

class OrderDialog extends StatefulWidget {
  final Customer? customer;

  const OrderDialog({Key? key, required this.customer}) : super(key: key);

  @override
  _OrderDialogState createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final _formKey = GlobalKey<FormState>();
  String _pieceNumber = '';
  double _totalPayment = 0.0;
  double _paymentDone = 0.0;
  String _customerName = '';
  List<String> _filteredPieceNumbers = [];
  Map<String, int> _availableQuantities = {};

  @override
  void initState() {
    super.initState();
    _customerName = widget.customer?.name ?? '';
    _sizeQuantityList.add(_SizeQuantityEntry());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Order'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.customer != null)
                Text(
                  'Customer Name: ${widget.customer!.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              else
                TextFormField(
                  initialValue: _customerName,
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                  onSaved: (value) => _customerName = value!,
                ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _pieceNumber,
                decoration: InputDecoration(
                  labelText: 'Piece Number',
                  suffixIcon: _filteredPieceNumbers.isNotEmpty
                      ? PopupMenuButton<String>(
                          itemBuilder: (context) => _filteredPieceNumbers
                              .map((piece) => PopupMenuItem(
                                    value: piece,
                                    child: Text(piece),
                                  ))
                              .toList(),
                          onSelected: (value) {
                            setState(() {
                              _pieceNumber = value;
                              _updateAvailableSizes();
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _pieceNumber = value;
                    _filteredPieceNumbers = Data.pieces
                        .map((piece) => piece.pieceNumber)
                        .where((piece) => piece.startsWith(value))
                        .toList();
                    _updateAvailableSizes();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter piece number';
                  }
                  return null;
                },
                onSaved: (value) => _pieceNumber = value!,
              ),
              const SizedBox(height: 16),
              ..._sizeQuantityList
                  .map((entry) => _SizeQuantityEntryWidget(
                      entry: entry,
                      availableSizes: _availableSizes,
                      availableQuantities: _availableQuantities))
                  .toList(),
              const SizedBox(height: 16),
              if (_availableSizes.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _sizeQuantityList.add(_SizeQuantityEntry());
                    });
                  },
                  child: const Text('Add Size'),
                ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue:
                    _totalPayment != 0.0 ? _totalPayment.toString() : null,
                decoration: const InputDecoration(
                  labelText: 'Total Payment',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid total payment';
                  }
                  return null;
                },
                onSaved: (value) => _totalPayment = double.parse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue:
                    _paymentDone != 0.0 ? _paymentDone.toString() : null,
                decoration: const InputDecoration(
                  labelText: 'Payment Done',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null ||
                      double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'Please enter a valid payment done';
                  }
                  return null;
                },
                onSaved: (value) => _paymentDone = double.parse(value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              double paymentDue = _totalPayment - _paymentDone;
              if (paymentDue < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Payment done cannot be greater than total payment'),
                  ),
                );
                return;
              }

              bool isOrderPlaced = _placeOrder(
                context,
                _pieceNumber,
                _customerName,
                widget.customer?.id,
                _sizeQuantityList
                    .map((entry) => MapEntry(entry.size, entry.quantity))
                    .toList(),
                _totalPayment,
                _paymentDone,
                paymentDue,
              );
              if (isOrderPlaced) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Place Order'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _updateAvailableSizes() {
    Piece? piece =
        Data.pieces.firstWhereOrNull((p) => p.pieceNumber == _pieceNumber);
    if (piece != null) {
      setState(() {
        _availableSizes = piece.sizesQuantityMap.keys.toList();
        _availableQuantities = Map.from(piece.sizesQuantityMap);
        _sizeQuantityList
            .removeWhere((entry) => !_availableSizes.contains(entry.size));
        _availableSizes.removeWhere(
            (size) => _sizeQuantityList.any((entry) => entry.size == size));
      });
    } else {
      setState(() {
        _availableSizes.clear();
        _availableQuantities.clear();
        _sizeQuantityList.clear();
        _sizeQuantityList.add(_SizeQuantityEntry());
      });
    }
  }

  bool _placeOrder(
    BuildContext context,
    String pieceNumber,
    String customerName,
    String? customerId,
    List<MapEntry<String, int>> sizesQuantityList,
    double totalPayment,
    double paymentDone,
    double paymentDue,
  ) {
    Piece? piece =
        Data.pieces.firstWhereOrNull((p) => p.pieceNumber == pieceNumber);
    if (piece == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Piece not found in stock')),
      );
      return false;
    }

    bool hasInsufficientStock = false;

    for (MapEntry<String, int> entry in sizesQuantityList) {
      String size = entry.key;
      int quantity = entry.value;

      if (piece.sizesQuantityMap.containsKey(size)) {
        int currentQuantity = piece.sizesQuantityMap[size]!;
        if (currentQuantity >= quantity) {
          piece.sizesQuantityMap[size] = currentQuantity - quantity;
        } else {
          hasInsufficientStock = true;
          _availableQuantities[size] = currentQuantity;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Size $size not found in stock')),
        );
        return false;
      }
    }

    if (hasInsufficientStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient stock for some sizes'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    Customer? customer =
        Data.customers.firstWhereOrNull((c) => c.name == customerName);
    if (customer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer not found')),
      );
      return false;
    }

    Order newOrder = Order(
      piece: pieceNumber,
      sizesQuantityMap: Map.fromEntries(sizesQuantityList),
      date: DateTime.now(),
      customerName: customerName,
      customerId: customerId,
      totalPayment: totalPayment,
      paymentDone: paymentDone,
      paymentDue: paymentDue,
    );
    Data.orders.add(newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully')),
    );
    return true;
  }
}

class _SizeQuantityEntry {
  String size;
  int quantity;

  _SizeQuantityEntry({this.size = '', this.quantity = 0});
}

class _SizeQuantityEntryWidget extends StatefulWidget {
  final _SizeQuantityEntry entry;
  final List<String> availableSizes;
  final Map<String, int> availableQuantities;

  const _SizeQuantityEntryWidget(
      {Key? key,
      required this.entry,
      required this.availableSizes,
      required this.availableQuantities})
      : super(key: key);

  @override
  _SizeQuantityEntryWidgetState createState() =>
      _SizeQuantityEntryWidgetState();
}

class _SizeQuantityEntryWidgetState extends State<_SizeQuantityEntryWidget> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: widget.entry.quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? dropdownValue;
    if (widget.availableSizes.contains(widget.entry.size)) {
      dropdownValue = widget.entry.size;
    } else {
      dropdownValue = null;
    }

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: dropdownValue,
            decoration: const InputDecoration(
              labelText: 'Size',
            ),
            items: widget.availableSizes
                .map(
                  (size) => DropdownMenuItem(
                    value: size,
                    child: Text(size),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                widget.entry.size = value ?? '';
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a size';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity',
              errorText: widget.entry.quantity >
                      (widget.availableQuantities[widget.entry.size] ?? 0)
                  ? 'Insufficient stock'
                  : null,
              errorStyle: const TextStyle(color: Colors.red),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null ||
                  int.tryParse(value) == null ||
                  int.parse(value) <= 0) {
                return 'Please enter a valid quantity';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                widget.entry.quantity = int.tryParse(value) ?? 0;
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _sizeQuantityList.remove(widget.entry);
              _availableSizes.add(widget.entry.size);
              _availableSizes.sort();
            });
          },
          icon: const Icon(Icons.remove_circle),
        ),
      ],
    );
  }
}
