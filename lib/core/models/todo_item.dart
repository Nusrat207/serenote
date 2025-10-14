class ToDoItem {
  final String? id;
  final String title;
  final bool isCompleted;
  final DateTime taskDate;
  final String? userId; // Add this field

  ToDoItem({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.taskDate,
    this.userId, // Add this parameter
  });

  Map<String, dynamic> toMap() {
  final map = {
    'title': title,
    'is_completed': isCompleted,
    'task_date': taskDate.toIso8601String().split('T')[0],
    'user_id': userId,
  };
  
  // Only include id if it's not null
  if (id != null) {
    map['id'] = id;
  }
  
  return map;
}

  static ToDoItem fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'],
      taskDate: DateTime.parse(map['task_date']),
      userId: map['user_id'], // Parse user_id
    );
  }

  ToDoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? taskDate,
    String? userId,
  }) {
    return ToDoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      taskDate: taskDate ?? this.taskDate,
      userId: userId ?? this.userId,
    );
  }
}