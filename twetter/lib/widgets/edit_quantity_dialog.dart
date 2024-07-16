import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../services/pieces_services.dart';

class EditQuantityDialog extends StatefulWidget {
  final Piece piece;
  final Function() onPieceUpdated;

  EditQuantityDialog(this.piece, {required this.onPieceUpdated});

  @override
  _EditQuantityDialogState createState() => _EditQuantityDialogState();
}

class _EditQuantityDialogState extends State<EditQuantityDialog> {
  late Map<String, int> newSizesQuantityMap;
  final TextEditingController newSizeController = TextEditingController();
  final TextEditingController newQuantityController = TextEditingController();
  final _pieceService = PiecesService();

  @override
  void initState() {
    super.initState();
    newSizesQuantityMap = Map.from(widget.piece.sizesQuantityMap);
  }

  @override
  void dispose() {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Edit Piece: ${widget.piece.pieceNumber}',
                  style: Theme.of(context).textTheme.headline6),
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
            subtitle: TextFormField(
              initialValue: entry.value.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                newSizesQuantityMap[entry.key] = int.tryParse(value) ?? 0;
              },
            ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _showDeleteConfirmationDialog(context),
          child: Text('Delete Piece'),
          style: TextButton.styleFrom(primary: Theme.of(context).errorColor),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                _updatePiece();
                widget.onPieceUpdated();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  void _updatePiece() {
    _addCurrentSizeAndQuantity();
    Piece updatedPiece =
        widget.piece.copyWithSizesQuantityMap(newSizesQuantityMap);
    _pieceService.updatePiece(updatedPiece);
  }

  void _addCurrentSizeAndQuantity() {
    final newSize = newSizeController.text.trim();
    final newQuantity = int.tryParse(newQuantityController.text.trim()) ?? 0;

    if (newSize.isNotEmpty && newQuantity > 0) {
      newSizesQuantityMap[newSize] = newQuantity;
    }
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Piece?'),
          content: Text('Are you sure you want to delete this piece?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _pieceService.deletePieceById(widget.piece.id);
                widget.onPieceUpdated();
                Navigator.of(context).pop();
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

  void _addNewSize() {
    String newSize = newSizeController.text.trim();
    String newQuantityStr = newQuantityController.text.trim();
    int newQuantity = int.tryParse(newQuantityStr) ?? 0;

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
}
