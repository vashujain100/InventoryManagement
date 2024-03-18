import 'package:flutter/material.dart';

import '../data.dart';
import '../models/piece.dart';

class EditQuantityDialog extends StatefulWidget {
  final Piece piece;

  EditQuantityDialog(this.piece);

  @override
  _EditQuantityDialogState createState() => _EditQuantityDialogState();
}

class _EditQuantityDialogState extends State<EditQuantityDialog> {
  late Map<String, int> newSizesQuantityMap;
  final TextEditingController newSizeController = TextEditingController();
  final TextEditingController newQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    newSizesQuantityMap = Map.from(widget.piece.sizesQuantityMap);
  }

  @override
  void dispose() {
    super.dispose();
    newSizeController.dispose();
    newQuantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Piece'),
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var entry in newSizesQuantityMap.entries)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Size ${entry.key}:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              // Save the new quantity when focus is lost
                              _updatePiece();
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
            _showDeleteConfirmationDialog(context);
          },
          child: Text('Delete Piece'),
        ),
        TextButton(
          onPressed: () {
            _updatePiece();
            _addNewSize(true);
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

  void _updatePiece() {
    Piece updatedPiece =
        widget.piece.copyWithSizesQuantityMap(newSizesQuantityMap);
    int index = Data.pieces.indexWhere(
        (element) => element.pieceNumber == widget.piece.pieceNumber);
    if (index != -1) {
      Data.pieces[index] = updatedPiece;
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
              onPressed: () {
                setState(() {
                  newSizesQuantityMap.remove(size);
                  _updatePiece();
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

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Piece?'),
          content: Text('Are you sure you want to delete this piece?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  Data.pieces.remove(widget.piece);
                });
                Navigator.of(context).pop();
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
    if (isSaveButton) {
      Navigator.of(context).pop();
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
}
