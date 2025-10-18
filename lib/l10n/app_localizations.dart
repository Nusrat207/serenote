import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SereNote'**
  String get appTitle;

  /// No description provided for @dashboard_mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get dashboard_mood;

  /// No description provided for @dashboard_journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get dashboard_journal;

  /// No description provided for @dashboard_habit.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get dashboard_habit;

  /// No description provided for @games_title.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games_title;

  /// No description provided for @games_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search games...'**
  String get games_search_hint;

  /// No description provided for @games_empty.
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get games_empty;

  /// No description provided for @journal_title.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal_title;

  /// No description provided for @journal_login_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access your journals'**
  String get journal_login_prompt;

  /// No description provided for @journal_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get journal_login_button;

  /// No description provided for @journal_start_title.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get journal_start_title;

  /// No description provided for @journal_start_desc.
  ///
  /// In en, this message translates to:
  /// **'Capture your thoughts, feelings, and reflections.\nStart your first journal entry today.'**
  String get journal_start_desc;

  /// No description provided for @journal_no_match.
  ///
  /// In en, this message translates to:
  /// **'No matching entries'**
  String get journal_no_match;

  /// No description provided for @journal_new_entry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get journal_new_entry;

  /// No description provided for @journal_create_first.
  ///
  /// In en, this message translates to:
  /// **'Create First Entry'**
  String get journal_create_first;

  /// No description provided for @journal_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Journal Entry'**
  String get journal_delete_title;

  /// No description provided for @journal_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String journal_delete_confirm(Object title);

  /// No description provided for @journal_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get journal_delete;

  /// No description provided for @journal_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get journal_cancel;

  /// No description provided for @journal_search_title.
  ///
  /// In en, this message translates to:
  /// **'Search Journals'**
  String get journal_search_title;

  /// No description provided for @journal_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter search term...'**
  String get journal_search_hint;

  /// No description provided for @journal_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get journal_clear;

  /// No description provided for @journal_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get journal_close;

  /// No description provided for @todo_title.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get todo_title;

  /// No description provided for @todo_login_title.
  ///
  /// In en, this message translates to:
  /// **'Login to manage your tasks'**
  String get todo_login_title;

  /// No description provided for @todo_login_desc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to add, edit, and view your daily routines.'**
  String get todo_login_desc;

  /// No description provided for @todo_no_tasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today!'**
  String get todo_no_tasks;

  /// No description provided for @todo_add_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your task...'**
  String get todo_add_hint;

  /// No description provided for @todo_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get todo_add;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get good_morning;

  /// No description provided for @good_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get good_afternoon;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get good_evening;

  /// No description provided for @weekly_moods.
  ///
  /// In en, this message translates to:
  /// **'Weekly Moods'**
  String get weekly_moods;

  /// No description provided for @recent_moods.
  ///
  /// In en, this message translates to:
  /// **'Recent Mood Entries'**
  String get recent_moods;

  /// No description provided for @current_mood.
  ///
  /// In en, this message translates to:
  /// **'Current Mood'**
  String get current_mood;

  /// No description provided for @how_feeling_today.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get how_feeling_today;

  /// No description provided for @you_not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'You\'re not logged in'**
  String get you_not_logged_in;

  /// No description provided for @sign_in_to_track.
  ///
  /// In en, this message translates to:
  /// **'Sign in to start tracking your moods and progress.'**
  String get sign_in_to_track;

  /// No description provided for @moods_tracked_today.
  ///
  /// In en, this message translates to:
  /// **'Moods Tracked Today'**
  String get moods_tracked_today;

  /// No description provided for @day_streak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get day_streak;

  /// No description provided for @habits_title.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habits_title;

  /// No description provided for @please_log_in.
  ///
  /// In en, this message translates to:
  /// **'Please log in'**
  String get please_log_in;

  /// No description provided for @need_login_habits.
  ///
  /// In en, this message translates to:
  /// **'You need to be logged in to view and manage your habits'**
  String get need_login_habits;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_habits_yet.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get no_habits_yet;

  /// No description provided for @create_first_habit.
  ///
  /// In en, this message translates to:
  /// **'Create your first habit to get started'**
  String get create_first_habit;

  /// No description provided for @add_habit.
  ///
  /// In en, this message translates to:
  /// **'Add Habit'**
  String get add_habit;

  /// No description provided for @add_new_habit.
  ///
  /// In en, this message translates to:
  /// **'Add New Habit'**
  String get add_new_habit;

  /// No description provided for @select_icon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon:'**
  String get select_icon;

  /// No description provided for @habit_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Habit name (e.g., Drink water)'**
  String get habit_name_hint;

  /// No description provided for @name_label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_label;

  /// No description provided for @description_hint.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get description_hint;

  /// No description provided for @description_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description_label;

  /// No description provided for @select_days.
  ///
  /// In en, this message translates to:
  /// **'Select Days:'**
  String get select_days;

  /// No description provided for @days_selected.
  ///
  /// In en, this message translates to:
  /// **'{count} days selected'**
  String days_selected(Object count);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @timer_title.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer_title;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @normal_timer.
  ///
  /// In en, this message translates to:
  /// **'Normal Timer'**
  String get normal_timer;

  /// No description provided for @set_timer_duration.
  ///
  /// In en, this message translates to:
  /// **'Set Timer Duration'**
  String get set_timer_duration;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @start_timer.
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get start_timer;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @timer_complete_title.
  ///
  /// In en, this message translates to:
  /// **'Timer Complete!'**
  String get timer_complete_title;

  /// No description provided for @timer_complete_body.
  ///
  /// In en, this message translates to:
  /// **'Your session is complete.'**
  String get timer_complete_body;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @pomodoroTechnique.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Technique'**
  String get pomodoroTechnique;

  /// No description provided for @focusDuration.
  ///
  /// In en, this message translates to:
  /// **'Focus Duration'**
  String get focusDuration;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @customGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Goals'**
  String get customGoalsTitle;

  /// No description provided for @defaultGoals.
  ///
  /// In en, this message translates to:
  /// **'Default Goals'**
  String get defaultGoals;

  /// No description provided for @customGoals.
  ///
  /// In en, this message translates to:
  /// **'Custom Goals'**
  String get customGoals;

  /// No description provided for @createCustomGoals.
  ///
  /// In en, this message translates to:
  /// **'Create Custom Goals'**
  String get createCustomGoals;

  /// No description provided for @enterGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Enter goal name...'**
  String get enterGoalHint;

  /// No description provided for @applyGoals.
  ///
  /// In en, this message translates to:
  /// **'Apply Goals'**
  String get applyGoals;

  /// No description provided for @goalCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/50'**
  String goalCount(Object count);

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @meditate.
  ///
  /// In en, this message translates to:
  /// **'Meditate'**
  String get meditate;

  /// No description provided for @relax.
  ///
  /// In en, this message translates to:
  /// **'Relax'**
  String get relax;

  /// No description provided for @calendar_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get calendar_sun;

  /// No description provided for @calendar_mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get calendar_mon;

  /// No description provided for @calendar_tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get calendar_tue;

  /// No description provided for @calendar_wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get calendar_wed;

  /// No description provided for @calendar_thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get calendar_thu;

  /// No description provided for @calendar_fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get calendar_fri;

  /// No description provided for @calendar_sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get calendar_sat;

  /// No description provided for @month_january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get month_january;

  /// No description provided for @month_february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get month_february;

  /// No description provided for @month_march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get month_march;

  /// No description provided for @month_april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get month_april;

  /// No description provided for @month_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month_may;

  /// No description provided for @month_june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get month_june;

  /// No description provided for @month_july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get month_july;

  /// No description provided for @month_august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get month_august;

  /// No description provided for @month_september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get month_september;

  /// No description provided for @month_october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get month_october;

  /// No description provided for @month_november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get month_november;

  /// No description provided for @month_december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get month_december;

  /// No description provided for @todo_add_new_task_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a new task to get started'**
  String get todo_add_new_task_hint;

  /// No description provided for @reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_title;

  /// No description provided for @reset_password_desc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link'**
  String get reset_password_desc;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @send_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get send_reset_link;

  /// No description provided for @reset_link_sent_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Link Sent!'**
  String get reset_link_sent_title;

  /// No description provided for @reset_link_sent_desc.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a password reset link. If you don\'t see it, check your spam folder.'**
  String get reset_link_sent_desc;

  /// No description provided for @back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get back_to_login;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error_occurred(Object error);

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @sign_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey'**
  String get sign_in_subtitle;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_label;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @sign_in_button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in_button;

  /// No description provided for @signup_prompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get signup_prompt;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @signup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started with SereNote'**
  String get signup_subtitle;

  /// No description provided for @full_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name_label;

  /// No description provided for @confirm_password_label.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password_label;

  /// No description provided for @passwords_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_not_match;

  /// No description provided for @password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_length_error;

  /// No description provided for @registration_success.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please check your email for verification.'**
  String get registration_success;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get already_have_account;

  /// No description provided for @create_account_button.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account_button;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profile_settings;

  /// No description provided for @user_not_authenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated. Please log in.'**
  String get user_not_authenticated;

  /// No description provided for @failed_to_load_profile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String failed_to_load_profile(Object error);

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @no_profile_data.
  ///
  /// In en, this message translates to:
  /// **'No profile data available'**
  String get no_profile_data;

  /// No description provided for @user_default_name.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user_default_name;

  /// No description provided for @choose_avatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get choose_avatar;

  /// No description provided for @display_name.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get display_name;

  /// No description provided for @full_name_required.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get full_name_required;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get email_invalid;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirm_password_required;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
