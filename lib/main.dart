import 'dart:math';

import 'package:flutter/material.dart';

class Item {
  Item({this.name});
  String name;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AnimatedList, AnimatedListState, Directionality | Random',
      theme: ThemeData(
        primaryColor: Color(0xFF832685),
        primaryColorLight: Color(0xFFC81379),
        accentColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'AnimatedList/State';

  final items = new List<Item>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final _range = Random();

  _addItem() {
    setState(() {
      _listKey.currentState
          .insertItem(items.length, duration: Duration(seconds: 1));
      final id = _range.nextInt(5000);
      items.add(Item(name: 'Add Item $id'));
    });
  }

  _removeItem() {
    setState(() {
      final id = _range.nextInt(items.length);
      final title = items[0].name;
      _listKey.currentState.removeItem(
        id,
        (context, animation) => _buildItem(context, 0, animation, title),
        duration: Duration(seconds: 1),
      );

      items.removeAt(id);
    });
  }

  Widget _buildItem(BuildContext context, int index,
      Animation<double> animation, String title) {
    return SizeTransition(
      key: ValueKey<int>(index),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: ListTile(
        title: Text('$title'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: _addItem,
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: items.length > 0 ? _removeItem : null,
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedList(
          key: _listKey,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(context, index, animation, items[index].name);
          },
        ),
      ),
    );
  }
}
