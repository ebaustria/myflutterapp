import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(new ToDo());

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
      ),
      home: new ToDoList()
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  createState() => new ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  Map<String, bool> _toDoMap = {};
  
  void _addItem(String toDo) {
    if (toDo.length > 0) {
      setState(() => _toDoMap[toDo] = false);
    }
  }

  Widget _buildList() {
    Iterable<String> keys = _toDoMap.keys;
    return new ListView.builder(
      itemBuilder: (context, place) {
        if (place < _toDoMap.length) {
          return _buildItem(keys.elementAt(place));
        }
      },
    );
  }

  Widget _buildItem(String text) {
    return new CheckboxListTile(
      title: Text(text),
      value: _toDoMap[text],
      onChanged: (newValue) {
        setState(() {
          _toDoMap[text] = newValue;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('To-Do List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            tooltip: 'Delete Checked Items',
            onPressed: _delete
          )
        ]
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          onPressed: _addScreen,
          tooltip: 'Add To-Do',
          child: new Icon(Icons.add)
      ),
    );
  }

  void _delete() {
    if (_toDoMap.values.any((element) => element == true)) {
      setState(() => _toDoMap.removeWhere((k, v) => v == true));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Mark items as finished in order to delete them.'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () => Navigator.of(context).pop()
              )
            ]
          );
        }
      );
    }
  }

  void _addScreen() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add a new task')
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted: (value) {
                _addItem(value);
                Navigator.pop(context);
              },
              decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        }
      )
    );
  }
}