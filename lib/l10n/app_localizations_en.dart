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
  String get journal_search_hint => 'Search journals...';

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

  @override
  String get this_week => 'This Week';

  @override
  String get monday_short => 'Mon';

  @override
  String get tuesday_short => 'Tue';

  @override
  String get wednesday_short => 'Wed';

  @override
  String get thursday_short => 'Thu';

  @override
  String get friday_short => 'Fri';

  @override
  String get saturday_short => 'Sat';

  @override
  String get sunday_short => 'Sun';

  @override
  String get january_short => 'Jan';

  @override
  String get february_short => 'Feb';

  @override
  String get march_short => 'Mar';

  @override
  String get april_short => 'Apr';

  @override
  String get may_short => 'May';

  @override
  String get june_short => 'Jun';

  @override
  String get july_short => 'Jul';

  @override
  String get august_short => 'Aug';

  @override
  String get september_short => 'Sep';

  @override
  String get october_short => 'Oct';

  @override
  String get november_short => 'Nov';

  @override
  String get december_short => 'Dec';

  @override
  String get stat_current => 'Current';

  @override
  String get stat_longest => 'Longest';

  @override
  String get stat_total => 'Total';

  @override
  String get mood_anxious => 'ANXIOUS';

  @override
  String get mood_angry => 'ANGRY';

  @override
  String get mood_sad => 'SAD';

  @override
  String get mood_neutral => 'NEUTRAL';

  @override
  String get mood_joy => 'JOY';

  @override
  String get quick_mood_title => 'How do you feel?';

  @override
  String get quick_mood_subtitle => 'Quick check-in • Takes 10 seconds';

  @override
  String get good_night => 'Good Night';

  @override
  String get how_are_you_feeling => 'How are you feeling?';

  @override
  String get select_your_mood => 'Select your mood';

  @override
  String get happy => 'Happy';

  @override
  String get neutral => 'Neutral';

  @override
  String get sad => 'Sad';

  @override
  String get anxious => 'Anxious';

  @override
  String get angry => 'Angry';

  @override
  String get save_mood => 'Save Mood';

  @override
  String get say_or_type_feeling => 'Say or type how you\'re feeling';

  @override
  String get please_select_mood => 'Please select a mood';

  @override
  String get mood_saved_successfully => 'Mood saved successfully!';

  @override
  String get error_saving_mood => 'Error saving mood: ';

  @override
  String get user_not_logged_in => 'User not logged in';

  @override
  String get mood_mirror => 'MoodMirror';

  @override
  String get welcome_mood_mirror => 'Welcome to MoodMirror';

  @override
  String get mood_mirror_description =>
      'Login to track your mood, receive uplifting quotes, and enjoy music that matches how you feel.';

  @override
  String get login_to_continue => 'Login to Continue';

  @override
  String get please_enter_feeling => 'Please enter or speak how you feel';

  @override
  String get mood_detected => 'Mood detected';

  @override
  String get error_text => 'Error';

  @override
  String get todays_mood => 'Today\'s Mood';

  @override
  String get confidence => 'confidence';

  @override
  String get type_or_speak_hint => 'Type or speak how you feel...';

  @override
  String get stop => 'Stop';

  @override
  String get voice_input => 'Voice Input';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analyze => 'Analyze';

  @override
  String get bubble_breather => 'Bubble Breather';

  @override
  String get bubble_breather_desc =>
      'Close your eyes, take a slow breath in… imagine a bubble floating higher with every exhale. Let your tension drift away with it.';

  @override
  String get for_you => 'For You';

  @override
  String get inspirational_quote => 'Inspirational Quote';

  @override
  String get recommended_music => 'Recommended Music';

  @override
  String get help_center_title => 'Help Center';

  @override
  String get getting_started => 'Getting Started';

  @override
  String get getting_started_desc => 'Learn how to use Serenote features';

  @override
  String get faq => 'FAQ';

  @override
  String get faq_desc => 'Frequently asked questions';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get contact_support_desc => 'Get in touch with our team';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get privacy_policy_desc => 'Learn about our privacy practices';

  @override
  String get guide_step_1 => 'Create Your Account';

  @override
  String get guide_step_1_desc =>
      'Sign up or log in to start using Serenote. Your data will be synced across all your devices.';

  @override
  String get guide_step_2 => 'Set Up Your Profile';

  @override
  String get guide_step_2_desc =>
      'Add a display name and avatar to personalize your experience.';

  @override
  String get guide_step_3 => 'Explore Features';

  @override
  String get guide_step_3_desc =>
      'Try out Todo, Journal, Timer, and Games to discover what works best for you.';

  @override
  String get guide_step_4 => 'Create Your First Todo';

  @override
  String get guide_step_4_desc =>
      'Start by adding tasks to your todo list to stay organized.';

  @override
  String get guide_step_5 => 'Write Your First Journal';

  @override
  String get guide_step_5_desc =>
      'Express your thoughts and reflections in your personal journal.';

  @override
  String get faq_question_1 => 'How do I reset my password?';

  @override
  String get faq_answer_1 =>
      'Go to Login screen, click \"Forgot Password\" and follow the instructions sent to your email.';

  @override
  String get faq_question_2 => 'Is my data secure?';

  @override
  String get faq_answer_2 =>
      'Yes, all your data is encrypted and stored securely. We use industry-standard security practices.';

  @override
  String get faq_question_3 => 'Can I use Serenote offline?';

  @override
  String get faq_answer_3 =>
      'Yes, most features work offline. Your data will sync when you reconnect to the internet.';

  @override
  String get faq_question_4 => 'How do I delete my account?';

  @override
  String get faq_answer_4 =>
      'Contact support from the Help Center to request account deletion.';

  @override
  String get faq_question_5 => 'Are there any subscription fees?';

  @override
  String get faq_answer_5 =>
      'Serenote is currently free to use. We may introduce premium features in the future.';

  @override
  String get contact_get_in_touch => 'Get in Touch';

  @override
  String get contact_help_desc =>
      'We\'re here to help you with any issues or questions.';

  @override
  String get contact_email_support => 'Email Support';

  @override
  String get contact_email => 'support@serenote.com';

  @override
  String get contact_live_chat => 'Live Chat';

  @override
  String get contact_chat_hours => 'Available 9AM-6PM Mon-Fri';

  @override
  String get contact_send_message => 'Send us a Message';

  @override
  String get contact_your_email => 'Your Email';

  @override
  String get contact_message => 'Message';

  @override
  String get contact_send_button => 'Send Message';

  @override
  String get contact_message_sent => 'Message sent to support team!';

  @override
  String get privacy_info_collected => 'Information We Collect';

  @override
  String get privacy_info_collected_desc =>
      'We collect information you provide directly to us, such as when you create an account, use our features, or contact us for support.';

  @override
  String get privacy_info_usage => 'How We Use Your Information';

  @override
  String get privacy_info_usage_desc =>
      'We use the information we collect to provide, maintain, and improve our services, to develop new ones, and to protect Serenote and our users.';

  @override
  String get privacy_info_sharing => 'Information Sharing';

  @override
  String get privacy_info_sharing_desc =>
      'We do not share your personal information with companies, organizations, or individuals outside of Serenote except in the following cases: with your consent, for legal reasons, or with domain administrators.';

  @override
  String get privacy_data_security => 'Data Security';

  @override
  String get privacy_data_security_desc =>
      'We work hard to protect our users from unauthorized access to or unauthorized alteration, disclosure, or destruction of information we hold.';

  @override
  String get privacy_your_rights => 'Your Rights';

  @override
  String get privacy_your_rights_desc =>
      'You have the right to access, correct, or delete your personal information. You can also object to our processing of your personal information.';

  @override
  String get about_title => 'About Serenote';

  @override
  String get about_description =>
      'SereNote A mindful companion. SereNote is designed to help users cultivate emotional awareness, track their moods and habits, and find calm through reflection and focus-enhancing mini-games. It blends journaling, micro-habit tracking, motivational quotes, and soft gamification — creating a space for gentle growth, balance, and insight.';

  @override
  String get sidebar_signup_login => 'Sign up or log in';

  @override
  String get sidebar_guest_mode => 'You are currently on guest mode';

  @override
  String get sidebar_login_button => 'Login';

  @override
  String get sidebar_signup_button => 'Sign Up';

  @override
  String get sidebar_logout => 'Logout';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_language_desc => 'Change app language';

  @override
  String get settings_about => 'About';

  @override
  String get settings_about_desc => 'Learn about Serenote';

  @override
  String get settings_help => 'Help Center';

  @override
  String get settings_help_desc => 'Get help and support';

  @override
  String get journal_delete_cancel => 'Cancel';

  @override
  String get journal_delete_delete => 'Delete';

  @override
  String get journal_delete_error => 'Error: Journal has no ID';

  @override
  String get journal_delete_success => 'Journal entry deleted';

  @override
  String get journal_error_loading => 'Error loading journals: ';

  @override
  String get journal_retry => 'Retry';

  @override
  String get journal_login_description =>
      'You need to log in to create, view, or manage journal entries.';

  @override
  String get journal_start_journey => 'Start Your Journey';

  @override
  String get journal_start_description =>
      'Capture your thoughts, feelings, and reflections.\nStart your first journal entry today.';

  @override
  String get journal_no_matching => 'No matching entries';

  @override
  String get journal_try_different => 'Try a different search term';

  @override
  String get journal_editor_new_title => 'New Journal Entry';

  @override
  String get journal_editor_edit_title => 'Edit Journal Entry';

  @override
  String get journal_editor_title_hint => 'Title';

  @override
  String get journal_editor_content_hint => 'Write your thoughts...';

  @override
  String get journal_editor_record_audio => 'Record Audio';

  @override
  String get journal_editor_stop_recording => 'Stop Recording';

  @override
  String get journal_editor_recording_started => 'Audio recording started';

  @override
  String get journal_editor_recording_stopped => 'Audio recording stopped';

  @override
  String get journal_editor_link_mood => 'Link to Mood';

  @override
  String get journal_editor_tags => 'Tags';

  @override
  String get journal_editor_add_tag => 'Add Tag';

  @override
  String get journal_editor_add_image => 'Add Image';

  @override
  String get journal_editor_image_added => 'Image added successfully!';

  @override
  String get journal_editor_invalid_image => 'Invalid image format';

  @override
  String get journal_editor_image_error => 'Error picking image: ';

  @override
  String get journal_editor_save_error => 'Error saving journal: ';

  @override
  String get journal_editor_validation_error =>
      'Please fill in both title and content';

  @override
  String get journal_editor_created => 'Journal entry created!';

  @override
  String get journal_editor_updated => 'Journal entry updated!';

  @override
  String get journal_editor_add_tag_dialog => 'Add Tag';

  @override
  String get journal_editor_tag_hint => 'Enter tag name';

  @override
  String get journal_editor_cancel => 'Cancel';

  @override
  String get journal_editor_add => 'Add';
}
