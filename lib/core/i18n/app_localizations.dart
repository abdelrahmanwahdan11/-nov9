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
    'insights_today': {
      'en': 'Digest pulse',
      'ar': 'نبض الملخص',
    },
    'insights_total': {
      'en': 'Stories today: {count}',
      'ar': 'القصص اليوم: {count}',
    },
    'insights_empty': {
      'en': 'Insights will appear once events roll in.',
      'ar': 'ستظهر الإحصاءات عند وصول الأحداث.',
    },
    'insights_tags': {
      'en': 'Trending tags',
      'ar': 'الوسوم الرائجة',
    },
    'insights_primary': {
      'en': '{category} leads today\'s coverage.',
      'ar': '{category} تتصدر تغطية اليوم.',
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
    'bookmark_added': {
      'en': 'Saved to bookmarks',
      'ar': 'تمت الإضافة إلى المحفوظات',
    },
    'bookmark_removed': {
      'en': 'Removed from bookmarks',
      'ar': 'تمت الإزالة من المحفوظات',
    },
    'quick_facts': {
      'en': 'Quick facts',
      'ar': 'حقائق سريعة',
    },
    'related_events': {
      'en': 'Related events',
      'ar': 'أحداث مرتبطة',
    },
    'history': {
      'en': 'History',
      'ar': 'الأرشيف',
    },
    'history_filters_heading': {
      'en': 'Refine this day',
      'ar': 'تصفية هذا اليوم',
    },
    'history_bookmarked_only': {
      'en': 'Bookmarked only',
      'ar': 'المحفوظات فقط',
    },
    'history_empty': {
      'en': 'No stories archived for this day yet.',
      'ar': 'لا توجد قصص مؤرشفة لهذا اليوم بعد.',
    },
    'history_filtered_empty': {
      'en': 'No archived stories match these filters.',
      'ar': 'لا توجد قصص مؤرشفة تطابق هذه المرشحات.',
    },
    'history_results_count': {
      'en': 'Stories: {count}',
      'ar': 'عدد القصص: {count}',
    },
    'history_insights_title': {
      'en': 'Archive snapshot',
      'ar': 'ملخص الأرشيف',
    },
    'history_insights_total': {
      'en': 'Total archived stories: {count}',
      'ar': 'إجمالي القصص المؤرشفة: {count}',
    },
    'history_insights_category': {
      'en': '{label}: {count}',
      'ar': '{label}: {count}',
    },
    'bookmarks': {
      'en': 'Bookmarks',
      'ar': 'المحفوظات',
    },
    'bookmarks_search_hint': {
      'en': 'Search saved stories',
      'ar': 'ابحث في القصص المحفوظة',
    },
    'bookmarks_results_count': {
      'en': 'Saved stories: {count}',
      'ar': 'القصص المحفوظة: {count}',
    },
    'bookmarks_empty': {
      'en': 'Add events to your bookmarks to keep them close at hand.',
      'ar': 'أضف الأحداث إلى المحفوظات للاطلاع عليها سريعًا.',
    },
    'bookmarks_filtered_empty': {
      'en': 'No bookmarks match your search yet.',
      'ar': 'لا توجد محفوظات تطابق بحثك بعد.',
    },
    'bookmarks_sort_label': {
      'en': 'Sort bookmarks',
      'ar': 'ترتيب المحفوظات',
    },
    'bookmarks_sort_newest': {
      'en': 'Newest first',
      'ar': 'الأحدث أولًا',
    },
    'bookmarks_sort_oldest': {
      'en': 'Oldest first',
      'ar': 'الأقدم أولًا',
    },
    'bookmarks_sort_alphabetical': {
      'en': 'A–Z',
      'ar': 'أ–ي',
    },
    'topics': {
      'en': 'Topics',
      'ar': 'المواضيع',
    },
    'topics_description': {
      'en': 'Choose which sections stay in your daily digest feed.',
      'ar': 'اختر الأقسام التي تريد ظهورها في ملخصك اليومي.',
    },
    'topics_enable_all': {
      'en': 'Enable all topics',
      'ar': 'تفعيل كل المواضيع',
    },
    'topics_keep_politics': {
      'en': 'Politics always stays pinned first for priority context.',
      'ar': 'ستبقى السياسة مثبتة في المقدمة لإبراز أهميتها.',
    },
    'topics_politics': {
      'en': 'Key updates on policy, diplomacy, and governance.',
      'ar': 'آخر المستجدات في السياسة والدبلوماسية والحكم.',
    },
    'topics_arts': {
      'en': 'Creative highlights from arts, culture, and festivals.',
      'ar': 'إضاءات إبداعية من الفنون والثقافة والمهرجانات.',
    },
    'topics_world': {
      'en': 'Global movements affecting the planet and economies.',
      'ar': 'حركات عالمية تؤثر على العالم والاقتصاد.',
    },
    'sources': {
      'en': 'Sources',
      'ar': 'المصادر',
    },
    'sources_description': {
      'en': 'Toggle which sources feed into your digest.',
      'ar': 'حدد المصادر التي تغذي ملخصك.',
    },
    'sources_empty': {
      'en': 'No sources available yet. Parse an article to begin.',
      'ar': 'لا توجد مصادر حالياً. قم بتحليل مقالة للبدء.',
    },
    'sources_enable_all': {
      'en': 'Enable all sources',
      'ar': 'تفعيل كل المصادر',
    },
    'trends': {
      'en': 'Trends',
      'ar': 'التحليلات',
    },
    'trends_categories': {
      'en': 'Stories by category',
      'ar': 'القصص حسب الفئة',
    },
    'trends_tags': {
      'en': 'Top tags today',
      'ar': 'أبرز الوسوم اليوم',
    },
    'trends_daily': {
      'en': 'Daily story volume',
      'ar': 'عدد القصص اليومي',
    },
    'trends_empty': {
      'en': 'Trends will appear once events roll in.',
      'ar': 'ستظهر التحليلات عند توفر الأحداث.',
    },
    'settings_data_tools': {
      'en': 'Data & backups',
      'ar': 'البيانات والنسخ الاحتياطية',
    },
    'settings_backup': {
      'en': 'Export backup JSON',
      'ar': 'تصدير نسخة احتياطية JSON',
    },
    'settings_backup_ready': {
      'en': 'Backup copied. Store it somewhere safe.',
      'ar': 'تم تجهيز النسخة الاحتياطية. احتفظ بها في مكان آمن.',
    },
    'settings_restore': {
      'en': 'Restore from backup',
      'ar': 'استعادة من النسخة الاحتياطية',
    },
    'settings_restore_hint': {
      'en': 'Paste a previously exported JSON blob here.',
      'ar': 'الصق ملف JSON الذي تم تصديره مسبقًا هنا.',
    },
    'settings_restore_success': {
      'en': 'Preferences restored',
      'ar': 'تمت استعادة الإعدادات',
    },
    'settings_reset': {
      'en': 'Reset to defaults',
      'ar': 'إعادة الإعدادات الافتراضية',
    },
    'settings_reset_success': {
      'en': 'Preferences reset',
      'ar': 'تمت إعادة التعيين',
    },
    'share_poster': {
      'en': 'Share poster',
      'ar': 'مشاركة ملصق',
    },
    'share_poster_event': {
      'en': 'Select an event',
      'ar': 'اختر حدثًا',
    },
    'share_poster_item': {
      'en': 'Select an item',
      'ar': 'اختر مقتنى',
    },
    'share_poster_event_tab': {
      'en': 'Events',
      'ar': 'أحداث',
    },
    'share_poster_item_tab': {
      'en': 'Items',
      'ar': 'مقتنيات',
    },
    'share_poster_export': {
      'en': 'Export poster',
      'ar': 'تصدير الملصق',
    },
    'share_poster_none': {
      'en': 'Add events or items to craft a poster.',
      'ar': 'أضف أحداثًا أو مقتنيات لإنشاء ملصق.',
    },
    'share_poster_success': {
      'en': 'Poster generated (~{size} KB)',
      'ar': 'تم إنشاء الملصق (~{size} كيلوبايت)',
    },
    'help_about': {
      'en': 'Help & About',
      'ar': 'المساعدة والتعريف',
    },
    'help_about_faq_title': {
      'en': 'FAQ',
      'ar': 'الأسئلة الشائعة',
    },
    'help_about_faq_content': {
      'en': 'Learn how the offline digest works, how to pin topics, and how to parse new articles without connectivity.',
      'ar': 'تعرف على كيفية عمل الملخص دون اتصال وكيفية تثبيت المواضيع وتحليل المقالات الجديدة دون اتصال.',
    },
    'help_about_privacy_title': {
      'en': 'Privacy',
      'ar': 'الخصوصية',
    },
    'help_about_privacy_content': {
      'en': 'Everything runs locally on your device. No accounts, no uploads, just personal control.',
      'ar': 'كل شيء يعمل محليًا على جهازك. لا حسابات ولا رفع بيانات، فقط تحكم شخصي.',
    },
    'help_about_version': {
      'en': 'Version 1.0.0',
      'ar': 'الإصدار 1.0.0',
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
