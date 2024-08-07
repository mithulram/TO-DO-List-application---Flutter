import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

// Events
abstract class TaskListEvent {}

class LoadTasks extends TaskListEvent {}

class AddTaskEvent extends TaskListEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskListEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskListEvent {
  final String id;
  DeleteTaskEvent(this.id);
}

class FilterTasks extends TaskListEvent {
  final TaskFilter filter;
  FilterTasks(this.filter);
}

enum TaskFilter { all, completed, pending }

// State
class TaskListState {
  final List<Task> allTasks;
  final List<Task> filteredTasks;
  final bool isLoading;
  final TaskFilter currentFilter;

  TaskListState({
    required this.allTasks,
    required this.filteredTasks,
    this.isLoading = false,
    this.currentFilter = TaskFilter.all,
  });

  TaskListState copyWith({
    List<Task>? allTasks,
    List<Task>? filteredTasks,
    bool? isLoading,
    TaskFilter? currentFilter,
  }) {
    return TaskListState(
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      isLoading: isLoading ?? this.isLoading,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskListBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskListState(allTasks: [], filteredTasks: [])) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FilterTasks>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(
      LoadTasks event, Emitter<TaskListState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tasks = await getTasks();
    emit(state.copyWith(
      allTasks: tasks,
      filteredTasks: _filterTasks(tasks, state.currentFilter),
      isLoading: false,
    ));
  }

  Future<void> _onAddTask(
      AddTaskEvent event, Emitter<TaskListState> emit) async {
    await addTask(event.task);
    final tasks = await getTasks();
    emit(state.copyWith(
      allTasks: tasks,
      filteredTasks: _filterTasks(tasks, state.currentFilter),
    ));
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskListState> emit) async {
    await updateTask(event.task);
    final tasks = await getTasks();
    emit(state.copyWith(
      allTasks: tasks,
      filteredTasks: _filterTasks(tasks, state.currentFilter),
    ));
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskListState> emit) async {
    await deleteTask(event.id);
    final tasks = await getTasks();
    emit(state.copyWith(
      allTasks: tasks,
      filteredTasks: _filterTasks(tasks, state.currentFilter),
    ));
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskListState> emit) {
    emit(state.copyWith(
      currentFilter: event.filter,
      filteredTasks: _filterTasks(state.allTasks, event.filter),
    ));
  }

  List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
    switch (filter) {
      case TaskFilter.completed:
        return tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.pending:
        return tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }
}
