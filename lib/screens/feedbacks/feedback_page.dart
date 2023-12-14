import 'package:coinxfiat/utils/my_logger.dart';
import 'package:flutter/material.dart';

///TODO: remaining pages
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, this.id});
  final String? id;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.f(
        'FeedbackPage didChangeDependencies: ${widget.id} ${widget.key} ${widget.hashCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      body: Center(
        child: Text('Feedbacks ${widget.id}'),
      ),
    );
  }
}
