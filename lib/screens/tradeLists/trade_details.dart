import 'package:flutter/material.dart';

///TODO: remaining pages
class TradeDetails extends StatefulWidget {
  const TradeDetails({super.key, this.id});
  final String? id;

  @override
  State<TradeDetails> createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade Details'),
      ),
      body: Center(
        child: Text('Trade Details ${widget.id}'),
      ),
    );
  }
}
