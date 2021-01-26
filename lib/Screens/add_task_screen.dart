import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo1/helpers/db_helper.dart';
import '../Models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  final Function updateTaskList;

  AddTaskScreen({this.updateTaskList, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();
  String title = '';
  String priority;
  DateTime _date = DateTime.now();

  TextEditingController dateController = TextEditingController();
  final List<String> priorites = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      title = widget.task.title;
      _date = widget.task.date;
      priority = widget.task.priority;
    }
    dateController.text = DateFormat.yMMMMd('en_US').format(_date);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      dateController.text = DateFormat.yMMMMd('en_US').format(date);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Task task = Task(title: title, date: _date, priority: priority);
      if (widget.task == null) {
        // Insert the task to our user's database
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update the task
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Stack(children: <Widget>[
          Image(
            image: AssetImage("assets/1.png"),
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            fit: BoxFit.fitHeight,
            // alignment: Alignment.topRight,
          ),
          GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 30.0,
                          color: Color(0xff6C63FF),
                        ),
                      ),
                      SizedBox(height: 180.0),
                      Center(
                        child: Text(
                          widget.task == null ? 'Add Task' : 'Update Task',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Your Task',
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (input) => input.trim().isEmpty
                                    ? 'Please enter the task name'
                                    : null,
                                onSaved: (input) => title = input,
                                initialValue: title,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: dateController,
                                style: TextStyle(fontSize: 18.0),
                                onTap: handleDatePicker,
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: DropdownButtonFormField(
                                isDense: true,
                                icon: Icon(Icons.arrow_drop_down_circle),
                                iconEnabledColor: Color(0xff6C63FF),
                                items: priorites.map((String prop) {
                                  return DropdownMenuItem(
                                    value: prop,
                                    child: Text(
                                      prop,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Priority',
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (input) => priority == null
                                    ? 'Please select a priority level'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    priority = value;
                                  });
                                },
                                value: priority,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xff6C63FF),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: FlatButton(
                                child: Text(
                                  widget.task == null ? 'Add' : 'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: submit,
                              ),
                            ),
                            widget.task != null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    height: 60.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff6C63FF),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: FlatButton(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      onPressed: _delete,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ]),
      ],
    ));
  }
}
