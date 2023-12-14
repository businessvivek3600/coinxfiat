import 'package:flutter/material.dart';

///TODO: remaining pages
class BuyOrSell extends StatefulWidget {
  const BuyOrSell({super.key, required this.type, this.requestId});
  final String type;
  final String? requestId;

  @override
  State<BuyOrSell> createState() => _BuyOrSellState();
}

class _BuyOrSellState extends State<BuyOrSell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.toLowerCase() == 'buy' ? 'Buy' : 'Sell'),
      ),
      body: Center(
        child: Text('Buy or Sell ${widget.type} ${widget.requestId}'),
      ),
    );
  }
}
