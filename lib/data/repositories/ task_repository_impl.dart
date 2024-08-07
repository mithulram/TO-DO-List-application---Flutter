import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<TaskModel> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(TaskModel(
        id: task.id, title: task.title, isCompleted: task.isCompleted));
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = TaskModel(
          id: task.id, title: task.title, isCompleted: task.isCompleted);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
