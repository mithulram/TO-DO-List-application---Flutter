import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/data/repositories/%20task_repository_impl.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/blocs/task_list_bloc.dart';
import 'presentation/blocs/task_form_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = TaskRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskListBloc>(
          create: (context) => TaskListBloc(
            getTasks: GetTasks(taskRepository),
            addTask: AddTask(taskRepository),
            updateTask: UpdateTask(taskRepository),
            deleteTask: DeleteTask(taskRepository),
          )..add(LoadTasks()),
        ),
        BlocProvider<TaskFormBloc>(
          create: (context) => TaskFormBloc(
            addTask: AddTask(taskRepository),
            updateTask: UpdateTask(taskRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'To-Do List App',
        theme: AppTheme.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
