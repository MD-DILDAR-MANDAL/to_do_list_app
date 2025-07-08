import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants.dart';

class TaskPage extends StatefulWidget {
  const TaskPage(this.id, {super.key});
  final String id;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final Constants _constants = Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task's"),
        foregroundColor: Colors.black,
        backgroundColor: _constants.primaryColor,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
        ],
      ),
      body: Container(child: StreamBuilder(stream: stream, builder: builder)),
    );
  }
}
