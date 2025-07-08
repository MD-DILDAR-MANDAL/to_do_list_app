import "package:cloud_firestore/cloud_firestore.dart";
import "package:to_do_list_app/models/task_model.dart";

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    return _db
        .collection("tasks")
        .doc(userId)
        .collection("userTask")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Task.fromFirestore(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> addTask(String userId, Task task) {
    return _db
        .collection("tasks")
        .doc(userId)
        .collection("userTask")
        .add(task.toFirestore());
  }

  Future<void> editTask(String userId, Task task) {
    return _db
        .collection("tasks")
        .doc(userId)
        .collection("userTask")
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String userId, String taskId) {
    return _db
        .collection("tasks")
        .doc(userId)
        .collection("userTask")
        .doc(taskId)
        .delete();
  }
}
