import 'package:flutter/material.dart';
import 'package:twetter/services/pieces_services.dart';

import '../models/piece.dart';
import '../utility/piece_search_delegate.dart';
import '../widgets/add_piece_dialog.dart';
import '../widgets/edit_quantity_dialog.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final _pieceService = PiecesService();
  List<Piece> _pieces = [];
  final TextEditingController _deleteConfirmController =
      TextEditingController();

  @override
  void initState() {
    _loadPieces();
    super.initState();
  }

  Future<void> _loadPieces() async {
    final pieces = await _pieceService.getAllPieces();
    setState(() {
      _pieces = pieces;
    });
  }

  @override
  void dispose() {
    _deleteConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Piece> sortedPieces = List.from(_pieces);
    sortedPieces.sort((a, b) => a.pieceNumber.compareTo(b.pieceNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PieceSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteAllConfirmationDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddPieceDialog(
                    onPieceAdded: () {
                      setState(() {
                        _loadPieces(); // Assuming you have a method to load pieces in the parent widget
                      });
                    },
                  );
                },
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Piece Number: ${piece.pieceNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditQuantityDialog(
                                piece,
                                onPieceUpataed: () {
                                  setState(() {
                                    _loadPieces();
                                  });
                                },
                              );
                            },
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
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
    );
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Pieces?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Are you sure you want to delete all pieces? This action cannot be undone.'),
              SizedBox(height: 20),
              Text('Type "Delete" to confirm:'),
              TextField(
                controller: _deleteConfirmController,
                decoration: InputDecoration(
                  hintText: 'Type "Delete" here',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_deleteConfirmController.text.trim() == 'Delete') {
                  await _pieceService.deleteAllPieces();
                  _deleteConfirmController.clear();
                  Navigator.of(context).pop();
                  _loadPieces();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please type "Delete" to confirm')),
                  );
                }
              },
              child: Text('Delete All'),
            ),
          ],
        );
      },
    );
  }
}
