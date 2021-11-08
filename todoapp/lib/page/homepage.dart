import 'package:flutter/material.dart';
import 'package:todoapp/api/firebase_api.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/provider/todos_provider.dart';
import 'package:todoapp/widget/add_todo.dart';
import 'package:todoapp/widget/todo_list.dart';
import 'package:todoapp/widget/completed_todo_list.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TodoListWidget(),
      CompletedListWidget(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(MyApp.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fact_check_outlined), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "Completed"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddTodoDialogWidget();
              },
              barrierDismissible: false);
        },
      ),
      body: StreamBuilder<List<Todo>>(
          stream: FirebaseApi.readTodos(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return buildText('Something Went Wrong Try later');
                } else {
                  final todos = snapshot.data as List<Todo>;

                  final provider = Provider.of<TodosProvider>(context);
                  provider.setTodos(todos);

                  return tabs[selectedIndex];
                }
            }
          }),
    );
  }
}

Widget buildText(String text) => Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
