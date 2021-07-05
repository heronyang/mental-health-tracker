import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'survey.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'MindTrend - Mental Health Tracker',
      'button_submit': 'Submit',
      'table_head_time': 'Time',
      'table_head_score': 'Score',
      'table_head_result': 'Result',
      'dialog_succeed_title': 'Succeed!',
      'dialog_succeed_content': 'Go to result page to see records.',
      'dialog_succeed_button': 'Go',
      'dialog_failed_empty_title': 'Oops!',
      'dialog_failed_empty_content': 'Please select response to all answers.',
      'dialog_failed_empty_button': 'OK',
      'dialog_welcome_title': 'Hi',
      'dialog_welcome_content':
          'MindTrend gives you mental health test periodically to track your scores.\n\nDisclaimer: The tool is still under development and is for testing only now.',
    },
    'zh': {
      'title': 'MindTrend - 心理健康追蹤器',
      'button_submit': '提交',
      'table_head_time': '時間',
      'table_head_score': '分數',
      'table_head_result': '結果',
      'dialog_succeed_title': '成功！',
      'dialog_succeed_content': '前往結果頁面',
      'dialog_succeed_button': '好',
      'dialog_failed_empty_title': '等等',
      'dialog_failed_empty_content': '請把題目都完成後再提交',
      'dialog_failed_empty_button': '好',
      'dialog_welcome_title': '嗨！',
      'dialog_welcome_content':
          '心理健康程度不容易看見，若下滑時會漸漸影響生活，嚴重時需就醫。\n這工具幫助您：定期做心理問卷，以追蹤心理健康。\n\n[免責聲明：這工具開發目前無專業心理師參與，僅作參考使用。]',
    },
  };
  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }

  String get button_submit {
    return _localizedValues[locale.languageCode]!['button_submit']!;
  }

  String get table_head_time {
    return _localizedValues[locale.languageCode]!['table_head_time']!;
  }

  String get table_head_score {
    return _localizedValues[locale.languageCode]!['table_head_score']!;
  }

  String get table_head_result {
    return _localizedValues[locale.languageCode]!['table_head_result']!;
  }

  String get dialog_succeed_title {
    return _localizedValues[locale.languageCode]!['dialog_succeed_title']!;
  }

  String get dialog_succeed_content {
    return _localizedValues[locale.languageCode]!['dialog_succeed_content']!;
  }

  String get dialog_succeed_button {
    return _localizedValues[locale.languageCode]!['dialog_succeed_button']!;
  }

  String get dialog_failed_empty_title {
    return _localizedValues[locale.languageCode]!['dialog_failed_empty_title']!;
  }

  String get dialog_failed_empty_content {
    return _localizedValues[locale.languageCode]![
        'dialog_failed_empty_content']!;
  }

  String get dialog_failed_empty_button {
    return _localizedValues[locale.languageCode]![
        'dialog_failed_empty_button']!;
  }

  String get dialog_welcome_title {
    return _localizedValues[locale.languageCode]!['dialog_welcome_title']!;
  }

  String get dialog_welcome_content {
    return _localizedValues[locale.languageCode]!['dialog_welcome_content']!;
  }

  static Map<String, Survey> _localizedSurveys = {
    'en': EnSurvey(),
    'zh': ZhSurvey()
  };

  Survey get survey {
    return _localizedSurveys[locale.languageCode]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
