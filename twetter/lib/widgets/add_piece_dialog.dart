import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/piece.dart';
import '../services/pieces_services.dart';

class AddPieceDialog extends StatefulWidget {
  final Function() onPieceAdded;

  AddPieceDialog({required this.onPieceAdded});

  @override
  _AddPieceDialogState createState() => _AddPieceDialogState();
}

class _AddPieceDialogState extends State<AddPieceDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, int> newSizesQuantityMap = {};
  final TextEditingController pieceNameController = TextEditingController();
  final TextEditingController newSizeController = TextEditingController();
  final TextEditingController newQuantityController = TextEditingController();
  final _pieceService = PiecesService();
  List<Piece> _pieces = [];

  @override
  void initState() {
    super.initState();
    _loadPieces();
  }

  Future<void> _loadPieces() async {
    final pieces = await _pieceService.getAllPieces();
    setState(() {
      _pieces = pieces;
    });
  }

  @override
  void dispose() {
    pieceNameController.dispose();
    newSizeController.dispose();
    newQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Text('Add New Piece',
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 16),
                _buildPieceNameField(),
                SizedBox(height: 24),
                Text('Sizes and Quantities',
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: 8),
                _buildSizeQuantityList(),
                SizedBox(height: 16),
                _buildAddSizeQuantitySection(),
                SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieceNameField() {
    return TextFormField(
      controller: pieceNameController,
      decoration: InputDecoration(
        labelText: 'Piece Name',
        prefixIcon: Icon(Icons.label),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a piece name';
        }
        if (_pieces.any((piece) => piece.pieceNumber == value)) {
          return 'A piece with this name already exists';
        }
        return null;
      },
    );
  }

  Widget _buildSizeQuantityList() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: newSizesQuantityMap.entries.map((entry) {
          return ListTile(
            title: Text('Size ${entry.key}'),
            subtitle: Text('Quantity: ${entry.value}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
              onPressed: () => _showConfirmationDialog(context, entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddSizeQuantitySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add New Size', style: Theme.of(context).textTheme.subtitle2),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: newSizeController,
                    decoration: InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: newQuantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addNewSize,
              icon: Icon(Icons.add),
              label: Text('Add Size'),
            ),
          ],
        ),
      ),
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
          onPressed: _savePiece,
          child: Text('Save Piece'),
        ),
      ],
    );
  }

  void _savePiece() {
    if (_formKey.currentState!.validate() && newSizesQuantityMap.isNotEmpty) {
      final newPiece = Piece(
        id: Uuid().v4(),
        pieceNumber: pieceNameController.text.trim(),
        sizesQuantityMap: Map.from(newSizesQuantityMap),
      );
      _pieceService.addPiece(newPiece);
      widget.onPieceAdded();
      Navigator.of(context).pop();
    } else if (newSizesQuantityMap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one size and quantity')),
      );
    }
  }

  void _addNewSize() {
    final newSize = newSizeController.text.trim();
    final newQuantity = int.tryParse(newQuantityController.text.trim()) ?? 0;

    if (newSize.isNotEmpty && newQuantity > 0) {
      if (newSizesQuantityMap.containsKey(newSize)) {
        _showReplaceDialog(newSize, newQuantity);
      } else {
        setState(() {
          newSizesQuantityMap[newSize] = newQuantity;
          newSizeController.clear();
          newQuantityController.clear();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid size or quantity')),
      );
    }
  }

  void _showReplaceDialog(String newSize, int newQuantity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Duplicate Size'),
          content:
              Text('Size $newSize already exists. Do you want to replace it?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  newSizesQuantityMap[newSize] = newQuantity;
                  newSizeController.clear();
                  newQuantityController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Replace'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String size) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Size?'),
          content: Text('Are you sure you want to delete size $size?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  newSizesQuantityMap.remove(size);
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor),
            ),
          ],
        );
      },
    );
  }
}
