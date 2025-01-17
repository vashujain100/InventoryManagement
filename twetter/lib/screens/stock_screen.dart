import 'package:flutter/material.dart';
import 'package:twetter/services/pieces_services.dart';

import '../models/piece.dart';
import '../utility/piece_search_delegate.dart';
import '../widgets/add_piece_dialog.dart';
import '../widgets/edit_quantity_dialog.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

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
    _deleteConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Piece> sortedPieces = List.from(_pieces);
    sortedPieces.sort((a, b) => a.pieceNumber.compareTo(b.pieceNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Items',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: PieceSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              _showDeleteAllConfirmationDialog(context);
            },
          ),
          // PopupMenuButton<String>(
          //   onSelected: (String result) {
          //     setState(() {
          //       _expandAll = result == 'expand';
          //     });
          //   },
          //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //     const PopupMenuItem<String>(
          //       value: 'expand',
          //       child: Text('Expand All'),
          //     ),
          //     const PopupMenuItem<String>(
          //       value: 'collapse',
          //       child: Text('Collapse All'),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: sortedPieces.isEmpty
          ? _buildEmptyStockMessage()
          : _buildStockList(sortedPieces),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPieceDialog(
                onPieceAdded: () {
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
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  Widget _buildEmptyStockMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 100, color: Theme.of(context).colorScheme.secondary),
          SizedBox(height: 20),
          Text(
            'Your stock is empty',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Add some pieces to get started!',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(List<Piece> sortedPieces) {
    return ListView.builder(
      itemCount: sortedPieces.length,
      itemBuilder: (context, index) {
        final piece = sortedPieces[index];
        return CustomExpansionTile(
          piece: piece,
          onEdit: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditQuantityDialog(
                  piece,
                  onPieceUpdated: () {
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
        );
      },
    );
  }

  void _showDeleteAllConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Pieces?',
              style: TextStyle(color: Theme.of(context).errorColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete all pieces? This action cannot be undone.',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              SizedBox(height: 20),
              Text('Type "Delete" to confirm:',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold)),
              TextField(
                controller: _deleteConfirmController,
                decoration: const InputDecoration(
                  hintText: 'Type "Delete" here',
                  border: OutlineInputBorder(),
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
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).errorColor),
            ),
          ],
        );
      },
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final Piece piece;
  final VoidCallback onEdit;

  const CustomExpansionTile({
    Key? key,
    required this.piece,
    required this.onEdit,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Piece Number: ${widget.piece.pieceNumber}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: widget.onEdit,
                ),
                RotationTransition(
                  turns: _iconTurns,
                  child: IconButton(
                    icon: Icon(Icons.expand_more),
                    onPressed: _handleTap,
                  ),
                ),
              ],
            ),
            onTap: _handleTap,
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.piece.sizesQuantityMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Size ${entry.key}:',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        Text(
                          '${entry.value}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
