import 'package:flutter/material.dart';

class SizeQuantityEntryWidget extends StatefulWidget {
  final String size;
  final int availableQuantity;
  final void Function(int) onQuantityChanged;

  const SizeQuantityEntryWidget({
    required this.size,
    required this.availableQuantity,
    required this.onQuantityChanged,
  });

  @override
  State<SizeQuantityEntryWidget> createState() =>
      _SizeQuantityEntryWidgetState();
}

class _SizeQuantityEntryWidgetState extends State<SizeQuantityEntryWidget> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.15,
              child: Center(
                child: Text(
                  widget.size,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.04,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Max. Quantity: ${widget.availableQuantity}',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _quantity = int.parse(value);
                });
                widget.onQuantityChanged(_quantity);
              },
            ),
          ),
        ],
      ),
    );
  }
}
