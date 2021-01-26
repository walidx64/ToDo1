import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo1/helpers/db_helper.dart';
import '../Screens/add_task_screen.dart';
import '../Models/task_model.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18.0,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              '${DateFormat.yMMMMd('en_US').format(task.date)} '
              ' ${task.priority}',
              style: TextStyle(
                fontSize: 15.0,
                decoration: task.status == 0
                    ? TextDecoration.none
                    : TextDecoration.lineThrough,
              ),
            ),
            trailing: Checkbox(
              value: task.status == 1 ? true : false,
              onChanged: (value) {
                task.status = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Color(0xff6C63FF),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  updateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 3.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.blueGrey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  updateTaskList: _updateTaskList,
                ),
              ),
            );
          },
          backgroundColor: Color(0xff6C63FF),
          child: Icon(Icons.add),
        ),
        body: Stack(
          children: [
            Stack(children: <Widget>[
              Image(
                image: AssetImage("assets/2.png"),
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitHeight,
              ),
              FutureBuilder(
                future: _taskList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final int completedTaskCount = snapshot.data
                      .where((Task task) => task.status == 1)
                      .toList()
                      .length;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 80.0),
                    itemCount: 1 + snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 110.0,
                              ),
                              Text(
                                'My Tasks',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '$completedTaskCount of ${snapshot.data.length}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }
                      return buildTask(snapshot.data[index - 1]);
                      // Container(
                      //   margin: EdgeInsets.all(10.0),
                      //   height: 100.0,
                      //   width: double.infinity,
                      //   color: Colors.blueAccent,
                    },
                  );
                },
              ),
            ])
          ],
        ));
  }
}
