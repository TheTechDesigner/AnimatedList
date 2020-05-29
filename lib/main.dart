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
      title: 'Flutter Demo',
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

  List<Item> items = new List();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var _range = Random();

  _addItem() {
    setState(() {
      _listKey.currentState
          .insertItem(items.length, duration: Duration(seconds: 1));
      int id = _range.nextInt(5000);
      items.add(Item(name: 'Add Item $id'));
    });
  }

  _removeItem() {
    setState(() {
      int id = _range.nextInt(items.length);
      _listKey.currentState.removeItem(
        id,
        (context, animation) => _buildItem(context, 0, animation),
        duration: Duration(seconds: 1),
      );
      items.removeAt(id);
    });
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
        key: ValueKey<int>(index),
        axis: Axis.vertical,
        sizeFactor: animation,
        child: ListTile(
          title: Text('${items[index].name}'),
        ));
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
            onPressed: _removeItem,
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedList(
          key: _listKey,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) {
            return _buildItem(context, index, animation);
          },
        ),
      ),
    );
  }
}
