// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get appTitle => 'SereNote';

  @override
  String get dashboard_mood => 'Mood';

  @override
  String get dashboard_journal => 'Journal';

  @override
  String get dashboard_habit => 'Habit';

  @override
  String get games_title => 'Games';

  @override
  String get games_search_hint => 'Search games...';

  @override
  String get games_empty => 'No games found';

  @override
  String get journal_title => 'Journal';

  @override
  String get journal_login_prompt => 'Please log in to access your journals';

  @override
  String get journal_login_button => 'Login';

  @override
  String get journal_start_title => 'Start Your Journey';

  @override
  String get journal_start_desc =>
      'Capture your thoughts, feelings, and reflections.\nStart your first journal entry today.';

  @override
  String get journal_no_match => 'No matching entries';

  @override
  String get journal_new_entry => 'New Entry';

  @override
  String get journal_create_first => 'Create First Entry';

  @override
  String get journal_delete_title => 'Delete Journal Entry';

  @override
  String journal_delete_confirm(Object title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get journal_delete => 'Delete';

  @override
  String get journal_cancel => 'Cancel';

  @override
  String get journal_search_title => 'Search Journals';

  @override
  String get journal_search_hint => 'Enter search term...';

  @override
  String get journal_clear => 'Clear';

  @override
  String get journal_close => 'Close';

  @override
  String get todo_title => 'To Do';

  @override
  String get todo_login_title => 'Login to manage your tasks';

  @override
  String get todo_login_desc =>
      'Sign in to add, edit, and view your daily routines.';

  @override
  String get todo_no_tasks => 'No tasks for today!';

  @override
  String get todo_add_hint => 'Enter your task...';

  @override
  String get todo_add => 'Add';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get good_morning => 'Good Morning';

  @override
  String get good_afternoon => 'Good Afternoon';

  @override
  String get good_evening => 'Good Evening';

  @override
  String get weekly_moods => 'Weekly Moods';

  @override
  String get recent_moods => 'Recent Mood Entries';

  @override
  String get current_mood => 'Current Mood';

  @override
  String get how_feeling_today => 'How are you feeling today?';

  @override
  String get you_not_logged_in => 'You\'re not logged in';

  @override
  String get sign_in_to_track =>
      'Sign in to start tracking your moods and progress.';

  @override
  String get moods_tracked_today => 'Moods Tracked Today';

  @override
  String get day_streak => 'Day Streak';

  @override
  String get habits_title => 'Habits';

  @override
  String get please_log_in => 'Please log in';

  @override
  String get need_login_habits =>
      'You need to be logged in to view and manage your habits';

  @override
  String get retry => 'Retry';

  @override
  String get no_habits_yet => 'No habits yet';

  @override
  String get create_first_habit => 'Create your first habit to get started';

  @override
  String get add_habit => 'Add Habit';

  @override
  String get add_new_habit => 'Add New Habit';

  @override
  String get select_icon => 'Select Icon:';

  @override
  String get habit_name_hint => 'Habit name (e.g., Drink water)';

  @override
  String get name_label => 'Name';

  @override
  String get description_hint => 'Description (optional)';

  @override
  String get description_label => 'Description';

  @override
  String get select_days => 'Select Days:';

  @override
  String days_selected(Object count) {
    return '$count days selected';
  }

  @override
  String get create => 'Create';

  @override
  String get timer_title => 'Timer';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get normal_timer => 'Normal Timer';

  @override
  String get set_timer_duration => 'Set Timer Duration';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get pause => 'Pause';

  @override
  String get start => 'Start';

  @override
  String get start_timer => 'Start Timer';

  @override
  String get reset => 'Reset';

  @override
  String get settings => 'Settings';

  @override
  String get goals => 'Goals';

  @override
  String get timer_complete_title => 'Timer Complete!';

  @override
  String get timer_complete_body => 'Your session is complete.';

  @override
  String get ok => 'OK';
}
