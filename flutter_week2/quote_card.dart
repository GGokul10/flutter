import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback delete;

  QuoteCard({required this.quote, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quote.text,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 6),
            Text(
              '- ${quote.author}',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            TextButton.icon(
              onPressed: delete,
              icon: Icon(Icons.delete, color: Colors.red),
              label: Text('Delete', style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
