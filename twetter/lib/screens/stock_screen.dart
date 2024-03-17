import 'package:flutter/material.dart';

import '../data.dart';
import '../models/piece.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    // Sort the pieces by name
    List<Piece> sortedPieces = List.from(Data.pieces);
    sortedPieces.sort((a, b) => a.pieceNumber.compareTo(b.pieceNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock'),
      ),
      body: ListView.builder(
        itemCount: sortedPieces.length,
        itemBuilder: (context, index) {
          final piece = sortedPieces[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Piece Number: ${piece.pieceNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: piece.sizesQuantityMap.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Size ${entry.key}:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${entry.value}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String pieceNumber = '';
    Map<String, int> sizesQuantityMap = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item to Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Piece Number'),
                onChanged: (value) {
                  pieceNumber = value;
                },
              ),
              SizedBox(height: 16),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: sizesQuantityMap.entries.map((entry) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(labelText: 'Size'),
                              // initialValue: entry.key,
                              onChanged: (value) {
                                setState(() {
                                  sizesQuantityMap[value] = entry.value;
                                  sizesQuantityMap.remove(entry.key);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              // initialValue: entry.value.toString(),
                              onChanged: (value) {
                                setState(() {
                                  sizesQuantityMap[entry.key] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sizesQuantityMap.addAll({
                      '': 0,
                    });
                  });
                },
                child: Text('Add Size'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  Piece existingPiece = Data.pieces.firstWhere(
                    (piece) => piece.pieceNumber == pieceNumber,
                    orElse: () => Piece(
                      pieceNumber: pieceNumber,
                      sizesQuantityMap: {},
                    ),
                  );
                  existingPiece.sizesQuantityMap.addAll(sizesQuantityMap);

                  if (!Data.pieces.contains(existingPiece)) {
                    Data.pieces.add(existingPiece);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
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
