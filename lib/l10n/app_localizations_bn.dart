// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get languageSettings => 'ভাষা সেটিংস';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন';

  @override
  String get appTitle => 'সিরিনোট';

  @override
  String get dashboard_mood => 'মুড';

  @override
  String get dashboard_journal => 'জার্নাল';

  @override
  String get dashboard_habit => 'অভ্যাস';

  @override
  String get games_title => 'গেমস';

  @override
  String get games_search_hint => 'গেম খুঁজুন...';

  @override
  String get games_empty => 'কোনো গেম পাওয়া যায়নি';

  @override
  String get journal_title => 'জার্নাল';

  @override
  String get journal_login_prompt => 'জার্নাল দেখতে লগইন করুন';

  @override
  String get journal_login_button => 'লগইন';

  @override
  String get journal_start_title => 'শুরু করুন';

  @override
  String get journal_start_desc =>
      'আপনার ভাবনা, অনুভূতি ও প্রতিফলন লিখুন।\nআজই প্রথম জার্নাল এন্ট্রি দিন।';

  @override
  String get journal_no_match => 'কোনো মিল পাওয়া যায়নি';

  @override
  String get journal_new_entry => 'নতুন এন্ট্রি';

  @override
  String get journal_create_first => 'প্রথম এন্ট্রি তৈরি করুন';

  @override
  String get journal_delete_title => 'জার্নাল এন্ট্রি মুছুন';

  @override
  String journal_delete_confirm(Object title) {
    return '\"$title\" মুছতে চান?';
  }

  @override
  String get journal_delete => 'মুছুন';

  @override
  String get journal_cancel => 'বাতিল';

  @override
  String get journal_search_title => 'জার্নাল সার্চ';

  @override
  String get journal_search_hint => 'সার্চ টেক্সট লিখুন...';

  @override
  String get journal_clear => 'ক্লিয়ার';

  @override
  String get journal_close => 'বন্ধ';

  @override
  String get todo_title => 'টু-ডু';

  @override
  String get todo_login_title => 'টাস্ক ম্যানেজ করতে লগইন করুন';

  @override
  String get todo_login_desc =>
      'প্রতিদিনের রুটিন যোগ, সম্পাদনা ও দেখার জন্য সাইন ইন করুন।';

  @override
  String get todo_no_tasks => 'আজ কোনো টাস্ক নেই!';

  @override
  String get todo_add_hint => 'আপনার টাস্ক লিখুন...';

  @override
  String get todo_add => 'অ্যাড';

  @override
  String get today => 'আজ';

  @override
  String get tomorrow => 'আগামীকাল';

  @override
  String get good_morning => 'সুপ্রভাত';

  @override
  String get good_afternoon => 'শুভ অপরাহ্ন';

  @override
  String get good_evening => 'শুভ সন্ধ্যা';

  @override
  String get weekly_moods => 'সাপ্তাহিক মুড';

  @override
  String get recent_moods => 'সাম্প্রতিক মুড এন্ট্রি';

  @override
  String get current_mood => 'বর্তমান মুড';

  @override
  String get how_feeling_today => 'আজ আপনি কেমন অনুভব করছেন?';

  @override
  String get you_not_logged_in => 'আপনি লগইন করেননি';

  @override
  String get sign_in_to_track => 'মুড ও প্রগ্রেস ট্র্যাক করতে সাইন ইন করুন।';

  @override
  String get moods_tracked_today => 'আজ ট্র্যাককৃত মুড';

  @override
  String get day_streak => 'দিনের স্ট্রিক';

  @override
  String get habits_title => 'অভ্যাস';

  @override
  String get please_log_in => 'লগইন করুন';

  @override
  String get need_login_habits => 'অভ্যাস দেখতে ও ম্যানেজ করতে লগইন করুন';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get no_habits_yet => 'এখনও কোনো অভ্যাস নেই';

  @override
  String get create_first_habit => 'শুরু করতে প্রথম অভ্যাস তৈরি করুন';

  @override
  String get add_habit => 'অভ্যাস যোগ করুন';

  @override
  String get add_new_habit => 'নতুন অভ্যাস যোগ করুন';

  @override
  String get select_icon => 'আইকন নির্বাচন করুন:';

  @override
  String get habit_name_hint => 'অভ্যাসের নাম (যেমন, পানি পান)';

  @override
  String get name_label => 'নাম';

  @override
  String get description_hint => 'বর্ণনা (ঐচ্ছিক)';

  @override
  String get description_label => 'বর্ণনা';

  @override
  String get select_days => 'দিন নির্বাচন করুন:';

  @override
  String days_selected(Object count) {
    return '$count দিন নির্বাচিত';
  }

  @override
  String get create => 'তৈরি করুন';

  @override
  String get timer_title => 'টাইমার';

  @override
  String get pomodoro => 'পোমোডোরো';

  @override
  String get normal_timer => 'নরমাল টাইমার';

  @override
  String get set_timer_duration => 'টাইমার সময় নির্ধারণ';

  @override
  String get hours => 'ঘন্টা';

  @override
  String get minutes => 'মিনিট';

  @override
  String get pause => 'বিরতি';

  @override
  String get start => 'শুরু';

  @override
  String get start_timer => 'টাইমার শুরু করুন';

  @override
  String get reset => 'রিসেট';

  @override
  String get settings => 'সেটিংস';

  @override
  String get goals => 'লক্ষ্য';

  @override
  String get timer_complete_title => 'টাইমার শেষ!';

  @override
  String get timer_complete_body => 'আপনার সেশন সম্পন্ন হয়েছে।';

  @override
  String get ok => 'ঠিক আছে';
}
