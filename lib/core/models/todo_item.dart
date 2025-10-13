class ToDoItem {
  final String? id;
  final String title;
  final bool isCompleted;
  final DateTime taskDate;

  ToDoItem({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.taskDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'task_date': taskDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
    };
  }

  static ToDoItem fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'],
      taskDate: DateTime.parse(map['task_date']),
    );
  }

  ToDoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? taskDate,
  }) {
    return ToDoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      taskDate: taskDate ?? this.taskDate,
    );
  }
}