
# My Habit Tracker

My Habit Tracker is a Flutter-based mobile application designed to help you build and maintain daily habits. With a simple and intuitive interface, you can create new habits, track your daily progress, edit or delete habits, and visualize your habit history using an interactive heatmap.

## Features

- **Habit Management**  
  - **Create** new habits with an easy-to-use dialog interface.
  - **Edit** habit names directly from the home screen.
  - **Delete** habits with a confirmation dialog to prevent accidental removals.
  
- **Progress Tracking**  
  - Mark habits as completed on a daily basis.
  - Automatically update your progress using state management.

- **Visual Insights**  
  - An interactive **heatmap** displays your habit completion history since your first launch.
  
- **Clean & Responsive UI**  
  - Built with Flutter and Material Design for a smooth user experience.
  - Custom components like drawers and habit tiles for a consistent look and feel.

- **State Management**  
  - Uses the [Provider](https://pub.dev/packages/provider) package for efficient state management and seamless data updates across the app.

## Getting Started

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/salah-191135/my_habit_tracker.git
   cd my_habit_tracker
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

## Project Structure

Here's an overview of the project structure:

```
my_habit_tracker/
├── lib/
│   ├── components/
│   │   ├── my_drawer.dart         # Custom drawer for app navigation
│   │   ├── my_habit_tile.dart     # Widget for displaying individual habit entries
│   │   └── my_heat_map.dart       # Custom heatmap widget for habit tracking visualization
│   ├── database/
│   │   └── habit_database.dart    # Handles CRUD operations for habits
│   ├── models/
│   │   └── habit.dart             # Data model representing a habit
│   ├── utils/
│   │   └── habit_util.dart        # Utility functions (e.g., for heatmap data preparation)
│   └── pages/
│       └── home_page.dart         # Main page displaying habits and heatmap; see below
├── pubspec.yaml                   # Project dependencies and metadata
└── README.md                      # Project overview and instructions
```

### How It Works

- **HomePage Widget**  
  Located in `lib/pages/home_page.dart`, this is the central screen that:
  - Loads existing habits on app start.
  - Displays a list of habits with options to mark them as completed, edit their names, or delete them.
  - Shows an interactive heatmap that summarizes your progress over time.

- **User Interactions**  
  - **Creating a Habit:** Tap the floating action button (FAB) to open a dialog where you can enter a new habit name.
  - **Editing a Habit:** Tap on a habit’s edit icon to modify its name using a text field dialog.
  - **Deleting a Habit:** Tap on the delete icon and confirm your action in the dialog to remove a habit.
  - **Marking as Completed:** Use the checkbox on each habit tile to mark the habit as completed for the day.

- **State Management**  
  The app uses the Provider package to manage state changes. The `HabitDatabase` class (found in `lib/database/habit_database.dart`) handles the CRUD operations, and its data is consumed by widgets like `HomePage` and `MyHabitTile`.

## License

This project is licensed under the [MIT License](LICENSE).
