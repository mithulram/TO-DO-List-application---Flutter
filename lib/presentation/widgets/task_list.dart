import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_app/presentation/theme/app_theme.dart';
import '../../domain/entities/task.dart';
import '../blocs/task_list_bloc.dart';
import 'delete_confirmation_dialog.dart';
import 'edit_task_dialog.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          key: Key(task.id),
          background: Container(
            color: AppTheme.errorColor, // Use theme color
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => DeleteConfirmationDialog(
                onConfirm: () {
                  context.read<TaskListBloc>().add(DeleteTaskEvent(task.id));
                },
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: task.isCompleted ? Colors.green[50] : Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  context.read<TaskListBloc>().add(
                        UpdateTaskEvent(
                          task.copyWith(isCompleted: value ?? false),
                        ),
                      );
                },
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppTheme.primaryColor, // Use theme color
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTaskDialog(
                          task: task,
                          onSave: (updatedTask) {
                            context.read<TaskListBloc>().add(
                                  UpdateTaskEvent(updatedTask),
                                );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8), // Add spacing between buttons
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: AppTheme.errorColor, // Use theme color
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationDialog(
                          onConfirm: () {
                            context
                                .read<TaskListBloc>()
                                .add(DeleteTaskEvent(task.id));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
