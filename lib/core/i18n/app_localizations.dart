import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const _localizedValues = <String, Map<String, String>>{
    'app_name': {'en': 'Daily Bubble Digest', 'ar': 'ملخص اليوم'},
    'politics': {'en': 'Politics', 'ar': 'سياسة'},
    'arts': {'en': 'Arts & Culture', 'ar': 'فنون وثقافة'},
    'world': {'en': 'World', 'ar': 'عالمي'},
    'compare': {'en': 'Compare', 'ar': 'مقارنة'},
    'ai_insight': {
      'en': 'AI Insight (coming soon)',
      'ar': 'تحليل بالذكاء الاصطناعي (قريبًا)',
    },
    'skip': {'en': 'Skip', 'ar': 'تخطي'},
    'next': {'en': 'Next', 'ar': 'التالي'},
    'get_started': {'en': 'Get Started', 'ar': 'ابدأ'},
    'sign_in': {'en': 'Sign In', 'ar': 'تسجيل الدخول'},
    'sign_up': {'en': 'Create Account', 'ar': 'إنشاء حساب'},
    'email': {'en': 'Email', 'ar': 'البريد الإلكتروني'},
    'password': {'en': 'Password', 'ar': 'كلمة المرور'},
    'confirm_password': {'en': 'Confirm Password', 'ar': 'تأكيد كلمة المرور'},
    'remember_me': {'en': 'Remember me', 'ar': 'تذكرني'},
    'continue_guest': {'en': 'Continue as guest', 'ar': 'المتابعة كضيف'},
    'home': {'en': 'Home', 'ar': 'الرئيسية'},
    'search': {'en': 'Search', 'ar': 'بحث'},
    'catalog': {'en': 'Catalog', 'ar': 'كتالوج'},
    'my_items': {'en': 'My Items', 'ar': 'مقتنياتي'},
    'settings': {'en': 'Settings', 'ar': 'الإعدادات'},
    'ingest_article': {'en': 'Ingest Article', 'ar': 'تحليل المقالة'},
    'notifications': {'en': 'Notifications', 'ar': 'الإشعارات'},
    'language': {'en': 'Language', 'ar': 'اللغة'},
    'theme': {'en': 'Theme', 'ar': 'السمة'},
    'light': {'en': 'Light', 'ar': 'فاتح'},
    'dark': {'en': 'Dark', 'ar': 'داكن'},
    'system': {'en': 'System', 'ar': 'النظام'},
    'primary_color': {'en': 'Primary color', 'ar': 'اللون الأساسي'},
    'clear_data': {'en': 'Clear data', 'ar': 'مسح البيانات'},
    'today_digest': {'en': "Today's Digest", 'ar': 'ملخص اليوم'},
    'search_hint': {'en': 'Search events & items', 'ar': 'ابحث في الأحداث والمقتنيات'},
    'pull_refresh': {'en': 'Pull to refresh', 'ar': 'اسحب للتحديث'},
    'offers': {'en': 'Offers', 'ar': 'عروض'},
    'for_sale': {'en': 'For sale', 'ar': 'للبيع'},
    'keep': {'en': 'Keep', 'ar': 'احتفظ'},
    'add_item': {'en': 'Add item', 'ar': 'إضافة مقتنى'},
    'compare_selected': {'en': 'Compare selected', 'ar': 'مقارنة المختار'},
    'search_filters': {'en': 'Filters', 'ar': 'مرشحات'},
    'no_results': {'en': 'No results found', 'ar': 'لا توجد نتائج'},
    'paste_article': {
      'en': 'Paste article text here...',
      'ar': 'الصق نص المقال هنا...'
    },
    'analyze_article': {'en': 'Analyze Article', 'ar': 'تحليل المقالة'},
    'accept': {'en': 'Accept', 'ar': 'قبول'},
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
  };

  String translate(String key) {
    final values = _localizedValues[key];
    if (values == null) {
      return key;
    }
    return values[locale.languageCode] ?? values['en'] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
