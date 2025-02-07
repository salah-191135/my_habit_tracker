import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final bool isCompleted;
  final String name;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.name,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          //edit habit name
          SlidableAction(
            onPressed: editHabit,
            backgroundColor: Colors.grey.shade700,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(10),
          ),

          //delete habit
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) onChanged!(!isCompleted);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(
              name,
              style: TextStyle(
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decorationThickness: 6.0,
              ),
            ),
            leading: Checkbox(
              value: isCompleted,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
