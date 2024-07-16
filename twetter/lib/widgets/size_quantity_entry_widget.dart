import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SizeQuantityEntryWidget extends StatefulWidget {
  final String size;
  final int availableQuantity;
  final void Function(int) onQuantityChanged;

  const SizeQuantityEntryWidget({
    Key? key,
    required this.size,
    required this.availableQuantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<SizeQuantityEntryWidget> createState() =>
      _SizeQuantityEntryWidgetState();
}

class _SizeQuantityEntryWidgetState extends State<SizeQuantityEntryWidget> {
  final TextEditingController _controller = TextEditingController();
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateQuantity);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateQuantity);
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity() {
    final newQuantity = int.tryParse(_controller.text) ?? 0;
    if (newQuantity != _quantity) {
      setState(() {
        _quantity = newQuantity;
      });
      widget.onQuantityChanged(_quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.size,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Max: ${widget.availableQuantity}',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _MaxValueFormatter(widget.availableQuantity),
              ],
              validator: (value) {
                final quantity = int.tryParse(value ?? '') ?? 0;
                if (quantity <= 0) {
                  return 'Enter a quantity';
                }
                if (quantity > widget.availableQuantity) {
                  return 'Max ${widget.availableQuantity}';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MaxValueFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final intValue = int.tryParse(newValue.text) ?? 0;
    if (intValue > maxValue) {
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }
    return newValue;
  }
}
