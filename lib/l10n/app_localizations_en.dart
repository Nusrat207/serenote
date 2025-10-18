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
  String get minutes => 'minutes';

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

  @override
  String get settingsTitle => 'Settings';

  @override
  String get pomodoroTechnique => 'Pomodoro Technique';

  @override
  String get focusDuration => 'Focus Duration';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get customGoalsTitle => 'Custom Goals';

  @override
  String get defaultGoals => 'Default Goals';

  @override
  String get customGoals => 'Custom Goals';

  @override
  String get createCustomGoals => 'Create Custom Goals';

  @override
  String get enterGoalHint => 'Enter goal name...';

  @override
  String get applyGoals => 'Apply Goals';

  @override
  String goalCount(Object count) {
    return '$count/50';
  }

  @override
  String get focus => 'Focus';

  @override
  String get read => 'Read';

  @override
  String get study => 'Study';

  @override
  String get workout => 'Workout';

  @override
  String get work => 'Work';

  @override
  String get meditate => 'Meditate';

  @override
  String get relax => 'Relax';

  @override
  String get calendar_sun => 'Sun';

  @override
  String get calendar_mon => 'Mon';

  @override
  String get calendar_tue => 'Tue';

  @override
  String get calendar_wed => 'Wed';

  @override
  String get calendar_thu => 'Thu';

  @override
  String get calendar_fri => 'Fri';

  @override
  String get calendar_sat => 'Sat';

  @override
  String get month_january => 'January';

  @override
  String get month_february => 'February';

  @override
  String get month_march => 'March';

  @override
  String get month_april => 'April';

  @override
  String get month_may => 'May';

  @override
  String get month_june => 'June';

  @override
  String get month_july => 'July';

  @override
  String get month_august => 'August';

  @override
  String get month_september => 'September';

  @override
  String get month_october => 'October';

  @override
  String get month_november => 'November';

  @override
  String get month_december => 'December';

  @override
  String get todo_add_new_task_hint => 'Add a new task to get started';

  @override
  String get reset_password_title => 'Reset Password';

  @override
  String get reset_password_desc =>
      'Enter your email to receive a password reset link';

  @override
  String get email_label => 'Email';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get reset_link_sent_title => 'Reset Link Sent!';

  @override
  String get reset_link_sent_desc =>
      'Check your email for a password reset link. If you don\'t see it, check your spam folder.';

  @override
  String get back_to_login => 'Back to Login';

  @override
  String error_occurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get sign_in_subtitle => 'Sign in to continue your journey';

  @override
  String get password_label => 'Password';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get sign_in_button => 'Sign In';

  @override
  String get signup_prompt => 'Don\'t have an account? Sign up';

  @override
  String get create_account => 'Create Account';

  @override
  String get signup_subtitle => 'Sign up to get started with SereNote';

  @override
  String get full_name_label => 'Full Name';

  @override
  String get confirm_password_label => 'Confirm Password';

  @override
  String get passwords_not_match => 'Passwords do not match';

  @override
  String get password_length_error => 'Password must be at least 6 characters';

  @override
  String get registration_success =>
      'Registration successful! Please check your email for verification.';

  @override
  String get already_have_account => 'Already have an account? Login';

  @override
  String get create_account_button => 'Create Account';

  @override
  String get profile_settings => 'Profile Settings';

  @override
  String get user_not_authenticated => 'User not authenticated. Please log in.';

  @override
  String failed_to_load_profile(Object error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get login => 'Login';

  @override
  String get no_profile_data => 'No profile data available';

  @override
  String get user_default_name => 'User';

  @override
  String get choose_avatar => 'Choose Avatar';

  @override
  String get display_name => 'Display Name';

  @override
  String get full_name_required => 'Full name is required';

  @override
  String get email_required => 'Email is required';

  @override
  String get email_invalid => 'Invalid email format';

  @override
  String get password_required => 'Password is required';

  @override
  String get confirm_password_required => 'Please confirm your password';
}
