import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';

// Events
abstract class TaskFormEvent {}

class SubmitTask extends TaskFormEvent {
  final String title;
  final String? id;
  final bool isCompleted;
  SubmitTask({required this.title, this.id, this.isCompleted = false});
}

// State
class TaskFormState {
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  TaskFormState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });
}

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final AddTask addTask;
  final UpdateTask updateTask;

  TaskFormBloc({required this.addTask, required this.updateTask})
      : super(TaskFormState()) {
    on<SubmitTask>(_onSubmitTask);
  }

  Future<void> _onSubmitTask(
      SubmitTask event, Emitter<TaskFormState> emit) async {
    emit(TaskFormState(isSubmitting: true));
    try {
      final task = Task(
        id: event.id ?? DateTime.now().toString(),
        title: event.title,
        isCompleted: event.isCompleted,
      );
      if (event.id == null) {
        await addTask(task);
      } else {
        await updateTask(task);
      }
      emit(TaskFormState(isSuccess: true));
    } catch (e) {
      emit(TaskFormState(errorMessage: e.toString()));
    }
  }
}
