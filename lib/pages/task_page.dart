import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/constants.dart';
import 'package:to_do_list_app/models/task_model.dart';
import 'package:to_do_list_app/routes/routes.dart';
import 'package:to_do_list_app/services/auth.dart';
import 'package:to_do_list_app/services/task_services.dart';

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
    final auth = Provider.of<Auth>(context);
    final taskProvide = Provider.of<TaskService>(context);
    final currentUid = widget.id;
    final _taskInput = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task's"),
        foregroundColor: Colors.black,
        backgroundColor: _constants.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add New Task'),
                    content: TextField(
                      controller: _taskInput,
                      decoration: InputDecoration(labelText: 'enter...'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          _taskInput.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          final title = _taskInput.text.trim();
                          if (title.isNotEmpty) {
                            taskProvide.addTask(
                              currentUid,
                              Task(
                                id: "",
                                description: title,
                                isCompleted: false,
                              ),
                            );
                          }
                          _taskInput.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.popAndPushNamed(context, RouteManager.loginPage);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: taskProvide.getTasks(currentUid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final tasks = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: _constants.secondaryColor,
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        final updatedTask = Task(
                          id: task.id,
                          description: task.description,
                          isCompleted: value ?? false,
                        );
                        taskProvide.editTask(currentUid, updatedTask);
                      },
                    ),
                    title: Text(
                      task.description,
                      style: TextStyle(
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final editController = TextEditingController(
                                  text: task.description,
                                );
                                return AlertDialog(
                                  title: Text('Edit Task'),
                                  content: TextField(
                                    controller: editController,
                                    decoration: InputDecoration(
                                      labelText: 'Task Description',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                    ),
                                    ElevatedButton(
                                      child: Text('Save'),
                                      onPressed: () {
                                        final newDescription =
                                            editController.text.trim();
                                        if (newDescription.isNotEmpty) {
                                          final updatedTask = Task(
                                            id: task.id,
                                            description: newDescription,
                                            isCompleted: task.isCompleted,
                                          );
                                          taskProvide.editTask(
                                            currentUid,
                                            updatedTask,
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            taskProvide.deleteTask(currentUid, task.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
