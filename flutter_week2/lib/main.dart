import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Quotes',
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: QuoteList(
        darkMode: _darkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}

class QuoteList extends StatefulWidget {
  final bool darkMode;
  final VoidCallback toggleTheme;

  QuoteList({required this.darkMode, required this.toggleTheme});

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Quote> quotes = [];

  final _authorController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  // Load quotes from shared preferences
  Future<void> loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? quotesData = prefs.getString('quotes');
    if (quotesData != null) {
      List<dynamic> jsonList = jsonDecode(quotesData);
      quotes = jsonList.map((json) => Quote.fromMap(json)).toList();
    } else {
      // Initial default quotes
      quotes = [
        Quote(author: 'Oscar Wilde', text: 'Be yourself; everyone else is already taken'),
        Quote(author: 'Oscar Wilde', text: 'I have nothing to declare except my genius'),
        Quote(author: 'Oscar Wilde', text: 'The truth is rarely pure and never simple'),
      ];
    }
    setState(() {});
  }

  // Save quotes to shared preferences
  Future<void> saveQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = quotes.map((q) => q.toMap()).toList();
    prefs.setString('quotes', jsonEncode(jsonList));
  }

  void addQuote(Quote quote) {
    quotes.insert(0, quote);
    _listKey.currentState?.insertItem(0);
    saveQuotes();
  }

  void removeQuote(int index) {
    final removedQuote = quotes.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => slideIt(removedQuote, animation),
      duration: Duration(milliseconds: 300),
    );
    saveQuotes();
  }

  Widget slideIt(Quote quote, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: QuoteCard(
        quote: quote,
        delete: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.darkMode ? Colors.grey[900] : Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(widget.darkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle Dark Mode',
          ),
        ],
      ),
      body: Column(
        children: [
          // Form to add a quote
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Quote',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: 'Author',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_textController.text.trim().isEmpty || _authorController.text.trim().isEmpty) return;
                    final newQuote = Quote(author: _authorController.text.trim(), text: _textController.text.trim());
                    addQuote(newQuote);
                    _textController.clear();
                    _authorController.clear();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Quote'),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: quotes.length,
              itemBuilder: (context, index, animation) {
                final quote = quotes[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: QuoteCard(
                    quote: quote,
                    delete: () => removeQuote(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
