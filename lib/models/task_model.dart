class Task {
  final String id;
  final String description;
  final bool isCompleted;

  Task({required this.id, required this.description, this.isCompleted = false});

  factory Task.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'description': description, 'isCompleted': isCompleted};
  }
}
