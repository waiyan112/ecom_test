import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Center(
        child: Center(
          child: Column(
            children: [
              Text(
                "Search Page",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                Provider.of<Counter>(context).count.toString(),
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
