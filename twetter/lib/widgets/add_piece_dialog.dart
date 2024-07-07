import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../services/pieces_services.dart';

class AddPieceDialog extends StatefulWidget {
  final Function() onPieceAdded;

  AddPieceDialog({required this.onPieceAdded});

  @override
  _AddPieceDialogState createState() => _AddPieceDialogState();
}

class _AddPieceDialogState extends State<AddPieceDialog> {
  late Map<String, int> newSizesQuantityMap;
  final TextEditingController pieceNameController = TextEditingController();
  final TextEditingController newSizeController = TextEditingController();
  final TextEditingController newQuantityController = TextEditingController();
  final _pieceService = PiecesService();
  List<Piece> _pieces = [];

  @override
  void initState() {
    _loadPieces();
    super.initState();
    newSizesQuantityMap = {};
  }

  Future<void> _loadPieces() async {
    final pieces = await _pieceService.getAllPieces();
    setState(() {
      _pieces = pieces;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pieceNameController.dispose();
    newSizeController.dispose();
    newQuantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Piece'),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: pieceNameController,
                  decoration: InputDecoration(labelText: 'Piece Name'),
                  onChanged: (value) {
                    // Check if a piece with the same name already exists
                    if (_pieces.any((piece) => piece.pieceNumber == value)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('A piece with the same name already exists'),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 10),
                for (var entry in newSizesQuantityMap.entries)
                  Row(
                    children: [
                      Expanded(
                        child: Text('Size ${entry.key}:'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              // Save the new quantity when focus is lost
                              // _updatePiece();
                            }
                          },
                          child: TextFormField(
                            initialValue:
                                newSizesQuantityMap[entry.key].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              // Update the quantity in the map when the value changes
                              newSizesQuantityMap[entry.key] =
                                  int.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showConfirmationDialog(context, entry.key);
                        },
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newSizeController,
                        decoration: InputDecoration(labelText: 'Add Size'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: newQuantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _addNewSize(false);
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _addNewSize(true);
              _savePiece();
            });
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _savePiece() {
    String pieceName = pieceNameController.text.trim();
    if (pieceName.isNotEmpty && newSizesQuantityMap.isNotEmpty) {
      Piece newPiece =
          Piece(pieceNumber: pieceName, sizesQuantityMap: newSizesQuantityMap);
      _pieceService.addPiece(newPiece);
      widget.onPieceAdded();
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a piece name and at least one size'),
        ),
      );
    }
  }

  void _addNewSize(bool isSaveButton) {
    String newSize = newSizeController.text.trim();
    String newQuantityStr = newQuantityController.text.trim();
    int newQuantity = int.tryParse(newQuantityStr) ?? 0;

    if (newSize.isNotEmpty && newQuantity > 0) {
      if (newSizesQuantityMap.containsKey(newSize)) {
        setState(() {
          _showReplaceDialog(newSize, newQuantity);
        });
      } else {
        setState(() {
          newSizesQuantityMap[newSize] = newQuantity;
          newSizeController.clear();
          newQuantityController.clear();
        });
      }
    } else if (!isSaveButton) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid size or quantity'),
        ),
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
              onPressed: () {
                setState(() {
                  newSizeController.clear();
                  newQuantityController.clear();
                  newSizesQuantityMap[newSize] = newQuantity;
                });
                Navigator.of(context).pop();
              },
              child: Text('Replace'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
              onPressed: () {
                setState(() {
                  newSizesQuantityMap.remove(size);
                  // _updatePiece();
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
