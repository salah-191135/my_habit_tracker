import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_habit_tracker/components/my_drawer.dart';
import 'package:my_habit_tracker/components/my_habit_tile.dart';
import 'package:my_habit_tracker/components/my_heat_map.dart';
import 'package:my_habit_tracker/database/habit_database.dart';
import 'package:my_habit_tracker/models/habit.dart';
import 'package:my_habit_tracker/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //read existing habits on app start
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final TextEditingController textcontroller = TextEditingController();

  void checkHabitOnOf(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

// edit habit name
  void editHabit(Habit habit) {
    textcontroller.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textcontroller,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String habitName = textcontroller.text;
              context.read<HabitDatabase>().updateHabitName(
                    habit.id,
                    habitName,
                  );
              Navigator.pop(context);
              textcontroller.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () => {
              Navigator.pop(context),
              textcontroller.clear(),
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  //delete habit

  void deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "are you sure you want to delete this habit ?",
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String habitName = textcontroller.text;
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
              textcontroller.clear();
            },
            child: const Text("Delete"),
          ),
          MaterialButton(
            onPressed: () => {
              Navigator.pop(context),
              textcontroller.clear(),
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textcontroller,
          decoration: const InputDecoration(hintText: "Enter Habit name"),
          autofocus: true,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String habitName = textcontroller.text;

              context.read<HabitDatabase>().addHabit(habitName);
              Navigator.pop(context);
              textcontroller.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () => {
              Navigator.pop(context),
              textcontroller.clear(),
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDataBase = context.watch<HabitDatabase>();

    List<Habit> habits = habitDataBase.currentHabits;

    return FutureBuilder(
        future: habitDataBase.getFirstLaunchDate(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyHeatMap(
                startDate: snapshot.data!,
                datasets: prepareHeatMapDatasets(habits));
          } else {
            return Container();
          }
        });
  }

  Widget _buildHabitList() {
    final habitDataBase = context.watch<HabitDatabase>();

    List<Habit> habits = habitDataBase.currentHabits;

    return ListView.builder(
      itemCount: habits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //get each habit from the list
        final habit = habits[index];
        //check if it is completed today
        final isCompleted = isCompletedToday(habit.comletedDays);

        return MyHabitTile(
          isCompleted: isCompleted,
          name: habit.name,
          onChanged: (value) => checkHabitOnOf(value, habit),
          deleteHabit: (context) => deleteHabit(habit),
          editHabit: (context) => editHabit(habit),
        );
        //return habit tile
      },
    );
  }
}
