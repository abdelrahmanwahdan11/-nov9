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
    'all': {'en': 'All', 'ar': 'الكل'},
    'welcome_title': {'en': 'Welcome, {name}!', 'ar': 'مرحبًا، {name}!'},
    'welcome_tagline': {
      'en': "Stay on pace with today's highlights",
      'ar': 'ابقَ على إيقاع أبرز أحداث اليوم',
    },
    'top_stories': {'en': 'Top Stories', 'ar': 'أبرز القصص'},
    'stories_today': {'en': '{count} stories today', 'ar': '{count} قصص اليوم'},
    'politics_priority': {
      'en': 'Politics stays upfront',
      'ar': 'السياسة في المقدمة دائمًا',
    },
    'digest_sections': {'en': 'Sections', 'ar': 'الأقسام'},
    'stories': {'en': 'Stories', 'ar': 'قصص'},
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
    'items.tip_high': {
      'en': 'Keep {name} pristine with light dusting and safe storage.',
      'ar': 'حافظ على {name} نظيفًا ومخزنًا بعناية.',
    },
    'items.tip_medium': {
      'en': 'Consider a gentle restoration to refresh {name}.',
      'ar': 'فكر في ترميم خفيف لإنعاش {name}.',
    },

    'search_intro': {
      'en': 'Fine-tune today's feed with smart filters.',
      'ar': 'اضبط خلاصتك اليوم باستخدام المرشحات الذكية.',
    },
    'search_saved_filters': {
      'en': 'Saved filters',
      'ar': 'المرشحات المحفوظة',
    },
    'search_saved_filters_empty': {
      'en': 'Save your favorite filter combos to access them quickly here.',
      'ar': 'احفظ تركيبات المرشحات المفضلة لديك للوصول إليها بسرعة هنا.',
    },
    'search_suggestions': {
      'en': 'Quick suggestions',
      'ar': 'اقتراحات سريعة',
    },
    'search_open_filters': {
      'en': 'Open filters',
      'ar': 'فتح المرشحات',
    },
    'search_results_count': {
      'en': '{count} matches',
      'ar': '{count} نتائج',
    },
    'search_events': {
      'en': 'Events',
      'ar': 'أحداث',
    },
    'search_items': {
      'en': 'Collectibles',
      'ar': 'مقتنيات',
    },
    'search_delete_filter': {
      'en': 'Delete filter?',
      'ar': 'حذف المرشح؟',
    },
    'search_saved_filter_applied': {
      'en': 'Applied "{name}"',
      'ar': 'تم تطبيق "{name}"',
    },
    'search_filter_deleted': {
      'en': 'Filter removed',
      'ar': 'تم حذف المرشح',
    },
    'search_filters_delete_confirm': {
      'en': 'Remove "{name}" from saved filters?',
      'ar': 'هل تريد إزالة "{name}" من المرشحات المحفوظة؟',
    },
    'search_filters_title': {
      'en': 'Search filters',
      'ar': 'مرشحات البحث',
    },
    'search_filters_categories': {
      'en': 'Categories',
      'ar': 'الفئات',
    },
    'search_filters_date_range': {
      'en': 'Date range',
      'ar': 'نطاق التاريخ',
    },
    'search_filters_any_time': {
      'en': 'Any time',
      'ar': 'أي وقت',
    },
    'search_filters_tags': {
      'en': 'Tags',
      'ar': 'وسوم',
    },
    'search_filters_sources': {
      'en': 'Sources',
      'ar': 'المصادر',
    },
    'search_filters_items_title': {
      'en': 'Items filters',
      'ar': 'مرشحات المقتنيات',
    },
    'search_filters_sale_state': {
      'en': 'Sale status',
      'ar': 'حالة البيع',
    },
    'search_filters_sale_state_any': {
      'en': 'Any status',
      'ar': 'أي حالة',
    },
    'search_filters_sale_state_for_sale': {
      'en': 'For sale',
      'ar': 'للبيع',
    },
    'search_filters_sale_state_keep': {
      'en': 'Keep',
      'ar': 'احتفظ',
    },
    'search_filters_price_range': {
      'en': 'Price range (USD)',
      'ar': 'نطاق السعر (دولار)',
    },
    'search_filters_name_hint': {
      'en': 'Filter name',
      'ar': 'اسم المرشح',
    },
    'search_filters_apply': {
      'en': 'Apply',
      'ar': 'تطبيق',
    },
    'search_filters_reset': {
      'en': 'Reset',
      'ar': 'إعادة تعيين',
    },
    'search_filters_save': {
      'en': 'Save preset',
      'ar': 'حفظ الإعداد',
    },
    'search_filter_saved': {
      'en': 'Filter saved',
      'ar': 'تم حفظ المرشح',
    },
    'confirm': {
      'en': 'Confirm',
      'ar': 'تأكيد',
    },
    'items_target_price': {
      'en': 'Target price: {price} USD',
      'ar': 'السعر المستهدف: {price} دولار',
    },
    'items_empty_state': {
      'en': 'Add your collectibles to track offers and care tips.',
      'ar': 'أضف مقتنياتك لمتابعة العروض ونصائح العناية.',
    },
    'items_offer_banner': {
      'en': 'New offer from {from}',
      'ar': 'عرض جديد من {from}',
    },
    'items_offer_amount': {
      'en': 'Offer amount: {amount} USD',
      'ar': 'قيمة العرض: {amount} دولار',
    },
    'items_offer_view': {
      'en': 'View offer',
      'ar': 'عرض التفاصيل',
    },
    'items_offer_dismiss': {
      'en': 'Dismiss',
      'ar': 'تجاهل',
    },
    'items_sale_status_listed': {
      'en': 'Listed for sale',
      'ar': 'معروض للبيع',
    },
    'items_sale_status_private': {
      'en': 'Kept private',
      'ar': 'محفوظ لديك',
    },
    'items_set_price': {
      'en': 'Set asking price',
      'ar': 'حدد سعر العرض',
    },
    'items_set_target': {
      'en': 'Set target',
      'ar': 'تعيين هدف',
    },
    'items_clear_target': {
      'en': 'Clear target',
      'ar': 'مسح الهدف',
    },
    'items_condition_score': {
      'en': 'Condition score',
      'ar': 'تقييم الحالة',
    },
    'items_mark_for_sale': {
      'en': 'Item listed for sale',
      'ar': 'تم إدراج المقتنى للبيع',
    },
    'items_mark_keep': {
      'en': 'Item marked as kept',
      'ar': 'تم وضع المقتنى كاحتفاظ',
    },
    'items_target_prompt': {
      'en': 'Target price (USD)',
      'ar': 'السعر المستهدف (دولار)',
    },
    'items_target_saved': {
      'en': 'Target saved',
      'ar': 'تم حفظ الهدف',
    },
    'items_price_hint': {
      'en': 'Price (USD)',
      'ar': 'السعر (دولار)',
    },
    'items_save': {
      'en': 'Save',
      'ar': 'حفظ',
    },
    'close': {
      'en': 'Close',
      'ar': 'إغلاق',
    },
    'items.tip_low': {
      'en': "Plan a professional repair to protect {name}'s value.",
      'ar': 'خطط لصيانة احترافية للحفاظ على قيمة {name}.',
    },
  };

  String translate(String key) {
    final values = _localizedValues[key];
    if (values == null) {
      return key;
    }
    return values[locale.languageCode] ?? values['en'] ?? key;
  }

  String translateWithArgs(String key, Map<String, String> args) {
    var template = translate(key);
    args.forEach((placeholder, value) {
      template = template.replaceAll('{$placeholder}', value);
    });
    return template;
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
