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
  String get todo_title => 'করণীয় কাজ';

  @override
  String get todo_login_title => 'আপনার কাজ পরিচালনা করতে লগইন করুন';

  @override
  String get todo_login_desc =>
      'আপনার দৈনন্দিন রুটিন যোগ, সম্পাদনা এবং দেখার জন্য সাইন ইন করুন।';

  @override
  String get todo_no_tasks => 'আজকের জন্য কোন কাজ নেই!';

  @override
  String get todo_add_hint => 'আপনার কাজ লিখুন...';

  @override
  String get todo_add => 'যোগ করুন';

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

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get pomodoroTechnique => 'পোমোডোরো টেকনিক';

  @override
  String get focusDuration => 'মনোযোগ সময়কাল';

  @override
  String get shortBreak => 'সংক্ষিপ্ত বিরতি';

  @override
  String get longBreak => 'দীর্ঘ বিরতি';

  @override
  String get saveSettings => 'সেটিংস সংরক্ষণ করুন';

  @override
  String get customGoalsTitle => 'কাস্টম লক্ষ্য';

  @override
  String get defaultGoals => 'ডিফল্ট লক্ষ্য';

  @override
  String get customGoals => 'নিজস্ব লক্ষ্য';

  @override
  String get createCustomGoals => 'নিজস্ব লক্ষ্য তৈরি করুন';

  @override
  String get enterGoalHint => 'লক্ষ্যের নাম লিখুন...';

  @override
  String get applyGoals => 'লক্ষ্য প্রয়োগ করুন';

  @override
  String goalCount(Object count) {
    return '$count/৫০';
  }

  @override
  String get focus => 'মনোযোগ';

  @override
  String get read => 'পড়া';

  @override
  String get study => 'পড়াশোনা';

  @override
  String get workout => 'ব্যায়াম';

  @override
  String get work => 'কাজ';

  @override
  String get meditate => 'ধ্যান';

  @override
  String get relax => 'আরাম';

  @override
  String get calendar_sun => 'রবি';

  @override
  String get calendar_mon => 'সোম';

  @override
  String get calendar_tue => 'মঙ্গল';

  @override
  String get calendar_wed => 'বুধ';

  @override
  String get calendar_thu => 'বৃহস্পতি';

  @override
  String get calendar_fri => 'শুক্র';

  @override
  String get calendar_sat => 'শনি';

  @override
  String get month_january => 'জানুয়ারি';

  @override
  String get month_february => 'ফেব্রুয়ারি';

  @override
  String get month_march => 'মার্চ';

  @override
  String get month_april => 'এপ্রিল';

  @override
  String get month_may => 'মে';

  @override
  String get month_june => 'জুন';

  @override
  String get month_july => 'জুলাই';

  @override
  String get month_august => 'আগস্ট';

  @override
  String get month_september => 'সেপ্টেম্বর';

  @override
  String get month_october => 'অক্টোবর';

  @override
  String get month_november => 'নভেম্বর';

  @override
  String get month_december => 'ডিসেম্বর';

  @override
  String get todo_add_new_task_hint =>
      'কাজ শুরু করার জন্য একটি নতুন কাজ যোগ করুন';

  @override
  String get reset_password_title => 'পাসওয়ার্ড রিসেট করুন';

  @override
  String get reset_password_desc =>
      'পাসওয়ার্ড রিসেট লিঙ্ক পেতে আপনার ইমেল লিখুন';

  @override
  String get email_label => 'ইমেল';

  @override
  String get send_reset_link => 'রিসেট লিঙ্ক পাঠান';

  @override
  String get reset_link_sent_title => 'রিসেট লিঙ্ক পাঠানো হয়েছে!';

  @override
  String get reset_link_sent_desc =>
      'পাসওয়ার্ড রিসেট লিঙ্কের জন্য আপনার ইমেল চেক করুন। যদি না দেখেন, স্প্যাম ফোল্ডার চেক করুন।';

  @override
  String get back_to_login => 'লগইনে ফিরে যান';

  @override
  String error_occurred(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String get welcome_back => 'স্বাগতম';

  @override
  String get sign_in_subtitle => 'আপনার যাত্রা চালিয়ে যেতে সাইন ইন করুন';

  @override
  String get password_label => 'পাসওয়ার্ড';

  @override
  String get forgot_password => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get sign_in_button => 'সাইন ইন';

  @override
  String get signup_prompt => 'অ্যাকাউন্ট নেই? সাইন আপ করুন';

  @override
  String get create_account => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get signup_subtitle => 'SereNote ব্যবহার শুরু করতে সাইন আপ করুন';

  @override
  String get full_name_label => 'পূর্ণ নাম';

  @override
  String get confirm_password_label => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get passwords_not_match => 'পাসওয়ার্ড মেলে না';

  @override
  String get password_length_error => 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';

  @override
  String get registration_success =>
      'রেজিস্ট্রেশন সফল! যাচাইয়ের জন্য আপনার ইমেল পরীক্ষা করুন।';

  @override
  String get already_have_account => 'ইতিমধ্যেই একটি অ্যাকাউন্ট আছে? লগইন করুন';

  @override
  String get create_account_button => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get profile_settings => 'প্রোফাইল সেটিংস';

  @override
  String get user_not_authenticated =>
      'ব্যবহারকারী প্রমাণীকৃত নয়। অনুগ্রহ করে লগইন করুন।';

  @override
  String failed_to_load_profile(Object error) {
    return 'প্রোফাইল লোড করতে ব্যর্থ: $error';
  }

  @override
  String get login => 'লগইন';

  @override
  String get no_profile_data => 'প্রোফাইল ডেটা পাওয়া যায়নি';

  @override
  String get user_default_name => 'ব্যবহারকারী';

  @override
  String get choose_avatar => 'অবতার নির্বাচন করুন';

  @override
  String get display_name => 'প্রদর্শিত নাম';

  @override
  String get full_name_required => 'পুরো নাম প্রয়োজন';

  @override
  String get email_required => 'ইমেইল প্রয়োজন';

  @override
  String get email_invalid => 'ইমেইল ফরমেট সঠিক নয়';

  @override
  String get password_required => 'পাসওয়ার্ড প্রয়োজন';

  @override
  String get confirm_password_required =>
      'দয়া করে আপনার পাসওয়ার্ড নিশ্চিত করুন';
}
