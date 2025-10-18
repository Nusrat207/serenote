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
  /// **'Minutes'**
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
