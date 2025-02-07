import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:my_habit_tracker/models/app_settings.dart';
import 'package:my_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

// setup

  // INITIALIZE- DATABASE

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heatmap
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

//? crud operations
// List of habits
  final List<Habit> currentHabits = [];
  // CREATE - add a new habit
  Future<void> addHabit(String name) async {
    // create a new habit
    final newHabit = Habit()..name = name;

    // save it
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // reread it
    readHabits();
  }

  // READ — read saved habits
  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    notifyListeners();
  }

  // UPDATE — check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    //if habit is comleted add current date to comleted days in db
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.comletedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.comletedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          // if not completed remove current date
          habit.comletedDays.removeWhere(
            (date) =>
                date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year,
          );
        }
        //save the updated habits to the db
        await isar.habits.put(habit);
      });
    }
    //re-read habits
    readHabits();
  }

  // UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // DELETE - delete habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }
}
