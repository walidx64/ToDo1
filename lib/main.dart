import 'package:flutter/material.dart';
import './Screens/todo_list_screen.dart ';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Task - Todo List',
      theme: ThemeData(
        primaryColor: Color(0xff6C63FF),
        accentColor: Color(0xff6C63FF),
        backgroundColor: Color(0xff6C63FF),
      ),
      home: TodoListScreen(),
    );
  }
}
