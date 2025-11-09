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
    'password_rule_length': {
      'en': 'At least 8 characters',
      'ar': 'ثمانية أحرف على الأقل',
    },
    'password_rule_upper': {
      'en': 'Uppercase letter',
      'ar': 'حرف كبير',
    },
    'password_rule_lower': {
      'en': 'Lowercase letter',
      'ar': 'حرف صغير',
    },
    'password_rule_number': {
      'en': 'Number',
      'ar': 'رقم',
    },
    'password_rule_symbol': {
      'en': 'Symbol',
      'ar': 'رمز',
    },
    'password_strength_weak': {
      'en': 'Strength: Weak',
      'ar': 'القوة: ضعيفة',
    },
    'password_strength_fair': {
      'en': 'Strength: Fair',
      'ar': 'القوة: متوسطة',
    },
    'password_strength_strong': {
      'en': 'Strength: Strong',
      'ar': 'القوة: قوية',
    },
    'remember_me': {'en': 'Remember me', 'ar': 'تذكرني'},
    'continue_guest': {'en': 'Continue as guest', 'ar': 'المتابعة كضيف'},
    'home': {'en': 'Home', 'ar': 'الرئيسية'},
    'briefing_nav': {'en': 'Briefing', 'ar': 'الموجز'},
    'forecast_nav': {'en': 'Forecast', 'ar': 'التوقعات'},
    'scenario_nav': {'en': 'Scenarios', 'ar': 'السيناريوهات'},
    'briefing_title': {'en': 'Command Center', 'ar': 'مركز التحكم'},
    'briefing_intro': {
      'en': 'Review highlights, saved filters, and collection insights in one place.',
      'ar': 'راجع أبرز النقاط والمرشحات المحفوظة ورؤى المقتنيات في مكان واحد.',
    },
    'briefing_metric_events': {'en': 'Stories today', 'ar': 'قصص اليوم'},
    'briefing_metric_items': {'en': 'Tracked items', 'ar': 'مقتنيات متابَعة'},
    'briefing_metric_lead_category': {'en': 'Lead category', 'ar': 'الفئة المتصدرة'},
    'briefing_metric_none': {'en': '—', 'ar': '—'},
    'briefing_quick_actions': {'en': 'Quick actions', 'ar': 'إجراءات سريعة'},
    'briefing_action_forecast': {'en': 'Forecast lab', 'ar': 'مختبر التوقعات'},
    'briefing_action_scenario': {'en': 'Scenario studio', 'ar': 'استوديو السيناريو'},
    'briefing_action_search': {'en': 'Search feed', 'ar': 'بحث في الملخص'},
    'briefing_action_ingest': {'en': 'Parse article', 'ar': 'تحليل مقال'},
    'briefing_action_on_this_day': {'en': 'Historic moments', 'ar': 'أحداث اليوم التاريخية'},
    'briefing_action_inventory': {'en': 'Inventory hub', 'ar': 'مركز المقتنيات'},
    'briefing_action_trends': {'en': 'View trends', 'ar': 'عرض الاتجاهات'},
    'briefing_action_share': {'en': 'Share poster', 'ar': 'مشاركة الملصق'},
    'briefing_action_notebook': {'en': 'Strategy notebook', 'ar': 'دفتر الاستراتيجيات'},
    'notebook': {'en': 'Strategy notebook', 'ar': 'دفتر الاستراتيجيات'},
    'notebook_nav': {'en': 'Notebook', 'ar': 'دفتر'},
    'notebook_title': {'en': 'Strategy Notebook', 'ar': 'دفتر الاستراتيجيات'},
    'notebook_title_label': {'en': 'Title', 'ar': 'العنوان'},
    'notebook_description': {
      'en': 'Capture bilingual playbooks, reactions, and follow-ups in one command space.',
      'ar': 'دوّن الخطط وردود الفعل والمتابعات بلغتين في مساحة قيادة واحدة.',
    },
    'notebook_settings_description': {
      'en': 'Review saved playbooks and confidence trends.',
      'ar': 'راجع الملاحظات المحفوظة واتجاهات الثقة.',
    },
    'notebook_overview_title': {
      'en': 'Latest strategy notes',
      'ar': 'أحدث مذكرات الاستراتيجية',
    },
    'notebook_open_full': {'en': 'Open notebook', 'ar': 'فتح الدفتر'},
    'notebook_empty_preview': {
      'en': 'Draft your first strategy note to populate this feed.',
      'ar': 'أنشئ أول مذكرة استراتيجية لملء هذه الخلاصة.',
    },
    'notebook_summary_metric': {
      'en': '{count} notes • Avg confidence {confidence}%',
      'ar': '{count} مذكرات • متوسط الثقة {confidence}%'
    },
    'notebook_top_confidence_title': {
      'en': 'Most confident move',
      'ar': 'أقوى تحرك ثقةً',
    },
    'notebook_updated_label': {
      'en': 'Updated {time}',
      'ar': 'تم التحديث {time}',
    },
    'notebook_empty': {
      'en': 'No strategy notes yet. Start a new brief to see it here.',
      'ar': 'لا توجد مذكرات استراتيجية بعد. ابدأ مذكرة جديدة لعرضها هنا.',
    },
    'notebook_add_note': {'en': 'Add note', 'ar': 'إضافة مذكرة'},
    'notebook_edit_note': {'en': 'Edit note', 'ar': 'تعديل المذكرة'},
    'notebook_summary_label': {'en': 'Summary', 'ar': 'ملخص'},
    'notebook_details_label': {'en': 'Detailed plan', 'ar': 'خطة تفصيلية'},
    'notebook_tags_hint': {'en': 'Tags (comma separated)', 'ar': 'الوسوم (مفصولة بفواصل)'},
    'notebook_focus_label': {'en': 'Focus', 'ar': 'محور'},
    'notebook_confidence_label': {'en': 'Confidence', 'ar': 'الثقة'},
    'notebook_save': {'en': 'Save', 'ar': 'حفظ'},
    'notebook_save_success': {'en': 'Note saved', 'ar': 'تم حفظ المذكرة'},
    'notebook_validation_error': {
      'en': 'Add a title and summary before saving.',
      'ar': 'أضف عنوانًا وملخصًا قبل الحفظ.',
    },
    'notebook_cancel': {'en': 'Cancel', 'ar': 'إلغاء'},
    'notebook_delete': {'en': 'Delete', 'ar': 'حذف'},
    'notebook_delete_success': {'en': 'Note removed', 'ar': 'تم حذف المذكرة'},
    'notebook_delete_confirm': {
      'en': 'Delete note?',
      'ar': 'حذف المذكرة؟',
    },
    'notebook_delete_message': {
      'en': 'This action removes the strategy note permanently.',
      'ar': 'سيتم حذف مذكرة الاستراتيجية نهائيًا.',
    },
    'notebook_filters': {'en': 'Filters', 'ar': 'مرشحات'},
    'notebook_filter_all': {'en': 'All focus areas', 'ar': 'جميع المحاور'},
    'notebook_clear_filters': {'en': 'Clear filters', 'ar': 'مسح المرشحات'},
    'notebook_search_hint': {'en': 'Search strategy notes', 'ar': 'ابحث في مذكرات الاستراتيجية'},
    'notebook_confidence_high': {'en': 'High confidence', 'ar': 'ثقة عالية'},
    'notebook_confidence_medium': {'en': 'Balanced confidence', 'ar': 'ثقة متوسطة'},
    'notebook_confidence_low': {'en': 'Exploratory', 'ar': 'قيد الاختبار'},
    'notebook_focus_politics': {'en': 'Politics strategy', 'ar': 'استراتيجية سياسية'},
    'notebook_focus_arts': {'en': 'Arts collaboration', 'ar': 'تعاون فني'},
    'notebook_focus_world': {'en': 'Global response', 'ar': 'استجابة عالمية'},
    'notebook_focus_inventory': {'en': 'Collection moves', 'ar': 'تحركات المجموعة'},
    'notebook_focus_timeline': {'en': 'Timeline feature', 'ar': 'ميزة الأحداث التاريخية'},
    'notebook_focus_global': {'en': 'Cross-cutting', 'ar': 'متعدد المحاور'},
    'notebook_metrics_overview': {
      'en': 'Confidence insights',
      'ar': 'رؤى الثقة',
    },
    'notebook_tag_filters': {'en': 'Tag focus', 'ar': 'تصفية الوسوم'},
    'notebook_average_confidence': {
      'en': 'Average confidence {value}%',
      'ar': 'متوسط الثقة {value}%'
    },
    'notebook_focus_breakdown': {
      'en': 'Focus breakdown',
      'ar': 'توزيع المحاور',
    },
    'notebook_highlight_random': {
      'en': 'Quick inspiration',
      'ar': 'إلهام سريع',
    },
    'notebook_highlight_from': {
      'en': 'From {title}',
      'ar': 'من {title}',
    },
    'time_just_now': {'en': 'just now', 'ar': 'لتوّه'},
    'time_minutes': {'en': '{value} min ago', 'ar': 'قبل {value} دقيقة'},
    'time_hours': {'en': '{value} h ago', 'ar': 'قبل {value} ساعة'},
    'time_days': {'en': '{value} d ago', 'ar': 'قبل {value} يومًا'},
    'briefing_no_saved_filters': {
      'en': 'Save searches to reuse them instantly.',
      'ar': 'احفظ عمليات البحث لإعادة استخدامها فورًا.',
    },
    'briefing_manage_filters': {'en': 'Manage filters', 'ar': 'إدارة المرشحات'},
    'briefing_bookmarks_title': {'en': 'Bookmarked stories', 'ar': 'قصص محفوظة'},
    'briefing_bookmarks_empty': {
      'en': 'Bookmark stories to revisit them here.',
      'ar': 'احفظ القصص للعودة إليها هنا.',
    },
    'briefing_bookmarks_more': {'en': 'View all bookmarks', 'ar': 'عرض جميع المحفوظات'},
    'briefing_items_title': {'en': 'Collection spotlight', 'ar': 'مقتنيات مميزة'},
    'briefing_items_empty': {
      'en': 'Add collectibles to see them spotlighted.',
      'ar': 'أضف مقتنيات لتظهر هنا.',
    },
    'briefing_items_manage': {'en': 'Manage collection', 'ar': 'إدارة المجموعة'},
    'briefing_historical_title': {'en': 'On this day preview', 'ar': 'لمحة حدث اليوم'},
    'briefing_historical_empty': {
      'en': 'Historical notes will appear after loading the timeline.',
      'ar': 'ستظهر الملاحظات التاريخية بعد تحميل الخط الزمني.',
    },
    'briefing_history_open': {'en': 'Open timeline', 'ar': 'فتح الخط الزمني'},
    'briefing_top_tags': {'en': 'Top tags', 'ar': 'أبرز الوسوم'},
    'briefing_category_breakdown': {'en': 'Category breakdown', 'ar': 'توزيع الفئات'},
    'briefing_open_search': {'en': 'Open search', 'ar': 'فتح البحث'},
    'forecast_lab_title': {'en': 'Forecast Lab', 'ar': 'مختبر التوقعات'},
    'forecast_reset': {'en': 'Reset controls', 'ar': 'إعادة ضبط الإعدادات'},
    'forecast_overview_title': {'en': 'Strategic outlook', 'ar': 'نظرة استراتيجية'},
    'forecast_overview_momentum': {
      'en': 'Momentum {value}%',
      'ar': 'الزخم {value}%'
    },
    'forecast_overview_horizon': {
      'en': 'Projected over a {days}-day horizon',
      'ar': 'متوقعة خلال أفق {days} أيام'
    },
    'forecast_controls_title': {'en': 'Tuning controls', 'ar': 'ضبط الإعدادات'},
    'forecast_optimism_label': {'en': 'Optimism', 'ar': 'التفاؤل'},
    'forecast_volatility_label': {'en': 'Volatility', 'ar': 'التقلب'},
    'forecast_horizon_label': {'en': 'Horizon (days)', 'ar': 'أفق التوقع (أيام)'},
    'forecast_focus_label': {'en': 'Focus category', 'ar': 'الفئة المركزة'},
    'forecast_projections_title': {'en': 'Category projections', 'ar': 'توقعات الفئات'},
    'forecast_projection_expected': {
      'en': '~{value} stories expected',
      'ar': 'حوالي {value} قصة متوقعة'
    },
    'forecast_projection_change_positive': {
      'en': 'Up {value}%',
      'ar': 'ارتفاع {value}%'
    },
    'forecast_projection_change_negative': {
      'en': 'Down {value}%',
      'ar': 'انخفاض {value}%'
    },
    'forecast_projection_change_neutral': {
      'en': 'Stable outlook',
      'ar': 'توقع مستقر'
    },
    'forecast_recommended_tags': {'en': 'Tags to prioritize', 'ar': 'وسوم يجب التركيز عليها'},
    'forecast_focus_events': {'en': 'Focus watchlist', 'ar': 'قائمة متابعة التركيز'},
    'forecast_focus_empty': {
      'en': 'No recent stories for this focus yet.',
      'ar': 'لا توجد قصص حديثة لهذا التركيز بعد.'
    },
    'forecast_suggestions_title': {'en': 'Strategist notes', 'ar': 'ملاحظات استراتيجية'},
    'forecast_empty_state': {
      'en': 'Tune the controls once new stories arrive to generate projections.',
      'ar': 'قم بضبط الإعدادات عند توفر قصص جديدة لإنشاء التوقعات.'
    },
    'forecast_suggestion_expand': {
      'en': 'Increase coverage on {category} while momentum is rising.',
      'ar': 'زد التغطية لفئة {category} مع ارتفاع الزخم.'
    },
    'forecast_suggestion_monitor': {
      'en': 'Monitor {category} closely; signals are cooling.',
      'ar': 'راقب فئة {category} عن كثب؛ المؤشرات تنخفض.'
    },
    'forecast_suggestion_capitalize': {
      'en': 'Overall sentiment is strong—capitalize on the momentum.',
      'ar': 'المعنويات العامة قوية — استفد من الزخم.'
    },
    'forecast_suggestion_rebalance': {
      'en': 'Momentum is softening; rebalance your focus mix.',
      'ar': 'الزخم يضعف؛ أعد توازن مزيج التركيز.'
    },
    'scenario_lab_title': {'en': 'Scenario Studio', 'ar': 'استوديو السيناريو'},
    'scenario_reset': {'en': 'Reset factors', 'ar': 'إعادة ضبط العوامل'},
    'scenario_header_title': {'en': 'Strategic blueprint', 'ar': 'مخطط استراتيجي'},
    'scenario_header_focus': {
      'en': 'Currently tuned for {focus}',
      'ar': 'مضبوط حاليًا على {focus}',
    },
    'scenario_header_ambition': {
      'en': 'Ambition {value}%',
      'ar': 'الطموح {value}%'
    },
    'scenario_header_resilience': {
      'en': 'Resilience {value}%',
      'ar': 'المرونة {value}%'
    },
    'scenario_controls_focus': {'en': 'Focus lens', 'ar': 'عدسة التركيز'},
    'scenario_controls_ambition': {'en': 'Ambition', 'ar': 'الطموح'},
    'scenario_controls_resilience': {'en': 'Resilience', 'ar': 'المرونة'},
    'scenario_focus_politics': {'en': 'Politics', 'ar': 'سياسة'},
    'scenario_focus_arts': {'en': 'Arts & Culture', 'ar': 'فنون وثقافة'},
    'scenario_focus_world': {'en': 'World', 'ar': 'عالمي'},
    'scenario_focus_collection': {'en': 'Collection', 'ar': 'المجموعة'},
    'scenario_focus_hybrid': {'en': 'Hybrid mix', 'ar': 'مزيج هجين'},
    'scenario_type_accelerate': {'en': 'Acceleration path', 'ar': 'مسار تسارع'},
    'scenario_type_stabilize': {'en': 'Stabilization plan', 'ar': 'خطة استقرار'},
    'scenario_type_diversify': {'en': 'Diversification', 'ar': 'تنويع'},
    'scenario_risk_low': {'en': 'Low risk', 'ar': 'مخاطر منخفضة'},
    'scenario_risk_medium': {'en': 'Moderate risk', 'ar': 'مخاطر متوسطة'},
    'scenario_risk_high': {'en': 'High risk', 'ar': 'مخاطر مرتفعة'},
    'scenario_plan_title': {'en': '{type} for {focus}', 'ar': '{type} لـ {focus}'},
    'scenario_confidence': {'en': 'Confidence', 'ar': 'درجة الثقة'},
    'scenario_drivers': {'en': 'Primary drivers', 'ar': 'محركات رئيسية'},
    'scenario_watchlist': {'en': 'Watchlist signals', 'ar': 'إشارات للمراقبة'},
    'scenario_actions': {'en': 'Next moves', 'ar': 'خطوات قادمة'},
    'scenario_empty_title': {'en': 'No scenarios yet', 'ar': 'لا توجد سيناريوهات بعد'},
    'scenario_empty_message': {
      'en': 'Pull in more stories or adjust the controls to generate scenario blueprints.',
      'ar': 'أضف المزيد من القصص أو عدّل الإعدادات لإنشاء مخططات سيناريو.',
    },
    'scenario_footer_disclaimer': {
      'en': 'Simulated for planning only — no external data required.',
      'ar': 'محاكاة للتخطيط فقط — بدون أي بيانات خارجية.',
    },
    'scenario_action_activate_briefings': {
      'en': 'Activate targeted briefings for {focus} stakeholders.',
      'ar': 'فعّل الإحاطات الموجهة لأصحاب المصلحة في {focus}.',
    },
    'scenario_action_surface_signals': {
      'en': 'Surface the strongest signals in your digest feed.',
      'ar': 'أبرز أقوى الإشارات داخل ملخصك.',
    },
    'scenario_action_launch_spotlight': {
      'en': 'Launch a spotlight package dedicated to {focus} coverage.',
      'ar': 'أطلق حزمة تركيز مخصصة لتغطية {focus}.',
    },
    'scenario_action_strengthen_monitoring': {
      'en': 'Strengthen monitoring cadence for emerging signals.',
      'ar': 'عزز وتيرة المراقبة للإشارات الناشئة.',
    },
    'scenario_action_pair_advisors': {
      'en': 'Pair advisors to co-own the {focus} response.',
      'ar': 'قم بمواءمة المستشارين ليتقاسموا استجابة {focus}.',
    },
    'scenario_action_resilience_drills': {
      'en': 'Schedule resilience drills with your team.',
      'ar': 'حدد تمارين مرونة للفريق.',
    },
    'scenario_action_crosslink_collection': {
      'en': 'Cross-link related collectibles to enrich context.',
      'ar': 'اربط المقتنيات ذات الصلة لإثراء السياق.',
    },
    'scenario_action_expand_partnerships': {
      'en': 'Expand partnerships with {count} aligned contributors.',
      'ar': 'وسع الشراكات مع {count} من الشركاء المتوافقين.',
    },
    'scenario_action_showcase_items': {
      'en': 'Showcase {name} in the next collection feature.',
      'ar': 'اعرض {name} في ميزة المجموعة القادمة.',
    },
    'search': {'en': 'Search', 'ar': 'بحث'},
    'on_this_day': {'en': 'On This Day', 'ar': 'في مثل هذا اليوم'},
    'on_this_day_nav': {'en': 'On This Day', 'ar': 'حدث اليوم'},
    'on_this_day_today': {'en': 'Jump to today', 'ar': 'الانتقال إلى اليوم'},
    'on_this_day_select_date': {'en': 'Choose another date', 'ar': 'اختر تاريخًا آخر'},
    'on_this_day_headline': {'en': 'Historic snapshots', 'ar': 'لمحات تاريخية'},
    'on_this_day_date_label': {'en': 'Moments from {date}', 'ar': 'أحداث بتاريخ {date}'},
    'on_this_day_events_count': {'en': 'Showing {count} moments', 'ar': 'عرض {count} أحداث'},
    'on_this_day_filter_country': {'en': 'Focus by country', 'ar': 'حدد حسب الدولة'},
    'on_this_day_country_all': {'en': 'All countries', 'ar': 'جميع الدول'},
    'on_this_day_country_global': {'en': 'Global', 'ar': 'عالمي'},
    'on_this_day_filter_type': {'en': 'Filter by event type', 'ar': 'التصفية حسب نوع الحدث'},
    'on_this_day_clear_types': {'en': 'Clear types', 'ar': 'إزالة الأنواع'},
    'on_this_day_highlights': {'en': 'Key highlights', 'ar': 'أبرز النقاط'},
    'on_this_day_source': {'en': 'Source: {source}', 'ar': 'المصدر: {source}'},
    'on_this_day_empty_title': {'en': 'No historical notes yet.', 'ar': 'لا توجد أحداث تاريخية حالياً.'},
    'on_this_day_empty_subtitle': {
      'en': 'Try a different date or broaden your filters.',
      'ar': 'جرّب تاريخًا مختلفًا أو وسّع عوامل التصفية.',
    },
    'on_this_day_year_label': {'en': 'Year {year}', 'ar': 'سنة {year}'},
    'historical_type_political': {'en': 'Political', 'ar': 'سياسي'},
    'historical_type_artistic': {'en': 'Artistic', 'ar': 'فني'},
    'historical_type_geographic': {'en': 'Geographic', 'ar': 'جغرافي'},
    'historical_type_natural_disaster': {'en': 'Natural disaster', 'ar': 'كارثة طبيعية'},
    'historical_type_holiday': {'en': 'Holiday', 'ar': 'عطلة'},
    'historical_type_social': {'en': 'Social', 'ar': 'اجتماعي'},
    'historical_type_scientific': {'en': 'Scientific', 'ar': 'علمي'},
    'historical_type_economic': {'en': 'Economic', 'ar': 'اقتصادي'},
    'historical_type_cultural': {'en': 'Cultural', 'ar': 'ثقافي'},
    'global_spotlight_nav': {'en': 'Global Spotlight', 'ar': 'الحدث العالمي'},
    'global_spotlight_date': {'en': 'Global snapshots for {date}', 'ar': 'لقطات عالمية لتاريخ {date}'},
    'global_spotlight_empty': {'en': 'No highlights for this filter yet.', 'ar': 'لا توجد أحداث لهذا الاختيار بعد.'},
    'global_spotlight_types': {'en': 'Event emphasis', 'ar': 'تركيز الأحداث'},
    'global_spotlight_year_range': {'en': 'Year range', 'ar': 'نطاق السنوات'},
    'global_spotlight_recent_only': {'en': 'Only show contemporary stories', 'ar': 'عرض القصص الحديثة فقط'},
    'global_spotlight_country_events': {'en': '{count} stories', 'ar': '{count} قصة'},
    'catalog': {'en': 'Catalog', 'ar': 'كتالوج'},
    'catalog_view_list': {'en': 'List view', 'ar': 'عرض قائمة'},
    'catalog_view_grid': {'en': 'Grid view', 'ar': 'عرض شبكة'},
    'catalog_search_hint': {
      'en': 'Search your collectibles',
      'ar': 'ابحث في مقتنياتك',
    },
    'catalog_stats_total': {'en': 'Total', 'ar': 'الإجمالي'},
    'catalog_stats_for_sale': {'en': 'For sale', 'ar': 'للبيع'},
    'catalog_stats_kept': {'en': 'Kept', 'ar': 'محفوظ'},
    'catalog_stats_compare': {'en': 'Compare', 'ar': 'المقارنة'},
    'catalog_target_matches': {
      'en': 'Close to target price',
      'ar': 'قريب من السعر المستهدف',
    },
    'catalog_filters_conditions': {
      'en': 'Filter by condition',
      'ar': 'التصفية حسب الحالة',
    },
    'catalog_filters_sale_only': {
      'en': 'Show items listed for sale only',
      'ar': 'عرض المعروض للبيع فقط',
    },
    'catalog_filters_price': {
      'en': 'Price range (USD)',
      'ar': 'نطاق السعر (دولار)',
    },
    'catalog_sort_label': {'en': 'Sort items', 'ar': 'ترتيب المقتنيات'},
    'catalog_sort_name': {'en': 'Name A-Z', 'ar': 'الاسم من أ إلى ي'},
    'catalog_sort_condition': {'en': 'Condition', 'ar': 'الحالة'},
    'catalog_sort_price_low': {
      'en': 'Price: low to high',
      'ar': 'السعر: من الأقل إلى الأعلى',
    },
    'catalog_sort_price_high': {
      'en': 'Price: high to low',
      'ar': 'السعر: من الأعلى إلى الأقل',
    },
    'catalog_results_count': {
      'en': 'Showing {count} items',
      'ar': 'عرض {count} مقتنيات',
    },
    'catalog_empty': {
      'en': 'No collectibles match your filters yet.',
      'ar': 'لا توجد مقتنيات مطابقة لمرشحاتك بعد.',
    },
    'catalog_spotlight_for_sale': {'en': 'Marketplace picks', 'ar': 'مختارات السوق'},
    'catalog_spotlight_for_sale_subtitle': {
      'en': 'Fresh offers circling your target prices.',
      'ar': 'عروض جديدة تقترب من أسعارك المستهدفة.',
    },
    'catalog_spotlight_recent': {'en': 'Latest additions', 'ar': 'أحدث الإضافات'},
    'catalog_spotlight_recent_subtitle': {
      'en': 'See what you catalogued most recently.',
      'ar': 'اطلع على أحدث ما أضفته إلى مجموعتك.',
    },
    'inventory_hub_title': {'en': 'Inventory Studio', 'ar': 'استوديو المقتنيات'},
    'inventory_tab_catalog': {'en': 'Discover', 'ar': 'اكتشف'},
    'inventory_tab_collection': {'en': 'My Collection', 'ar': 'مجموعتي'},
    'inventory_open_insights': {'en': 'Collection insights', 'ar': 'تحليلات المجموعة'},
    'inventory_stat_total': {'en': 'Items', 'ar': 'العناصر'},
    'inventory_stat_for_sale': {'en': 'For sale', 'ar': 'للبيع'},
    'inventory_stat_kept': {'en': 'Kept', 'ar': 'محفوظ'},
    'inventory_stat_compare_ready': {'en': 'Compare bin', 'ar': 'قائمة المقارنة'},
    'inventory_add_item': {'en': 'Add collectible', 'ar': 'أضف مقتنى'},
    'inventory_sheet_title': {'en': 'Collection insight', 'ar': 'ملخص المجموعة'},
    'inventory_sheet_conditions': {'en': 'Condition breakdown', 'ar': 'توزيع الحالات'},
    'inventory_nav': {'en': 'Inventory', 'ar': 'المجموعة'},
    'my_items': {'en': 'My Items', 'ar': 'مقتنياتي'},
    'my_items_tab_kept': {'en': 'Kept', 'ar': 'محفوظة'},
    'my_items_tab_listed': {'en': 'Listed', 'ar': 'معروضة'},
    'my_items_kept_title': {
      'en': 'Your kept collection',
      'ar': 'مقتنياتك المحفوظة',
    },
    'my_items_kept_count': {
      'en': 'You are keeping {count} pieces',
      'ar': 'تحتفظ بـ {count} مقتنيات',
    },
    'my_items_listed_title': {
      'en': 'Marketplace listings',
      'ar': 'القوائم المعروضة',
    },
    'my_items_listed_count': {
      'en': 'You listed {count} pieces',
      'ar': 'عرضت {count} مقتنيات',
    },
    'my_items_overview_total': {
      'en': '{count} total pieces curated',
      'ar': '{count} عنصر في مجموعتك',
    },
    'my_items_recent': {'en': 'Recently added', 'ar': 'أضيفت حديثًا'},
    'my_items_metric_total': {'en': 'Items', 'ar': 'المقتنيات'},
    'my_items_metric_condition': {
      'en': 'Avg. condition',
      'ar': 'متوسط الحالة',
    },
    'my_items_tips_title': {'en': 'Care tips', 'ar': 'نصائح العناية'},
    'my_items_unknown_item': {'en': 'Unknown item', 'ar': 'مقتنى غير معروف'},
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
    'required': {
      'en': 'Required',
      'ar': 'إلزامي',
    },
    'items_composer_image': {
      'en': 'Cover image',
      'ar': 'صورة الغلاف',
    },
    'items_composer_image_url': {
      'en': 'Image URL',
      'ar': 'رابط الصورة',
    },
    'items_composer_name': {
      'en': 'Item name',
      'ar': 'اسم المقتنى',
    },
    'items_composer_brand': {
      'en': 'Brand',
      'ar': 'العلامة التجارية',
    },
    'items_composer_year': {
      'en': 'Year',
      'ar': 'السنة',
    },
    'items_composer_condition': {
      'en': 'Condition',
      'ar': 'الحالة',
    },
    'items_composer_notes': {
      'en': 'Notes',
      'ar': 'ملاحظات',
    },
    'items_composer_specs': {
      'en': 'Specifications',
      'ar': 'المواصفات',
    },
    'items_composer_spec_key': {
      'en': 'Label',
      'ar': 'المسمى',
    },
    'items_composer_spec_value': {
      'en': 'Value',
      'ar': 'القيمة',
    },
    'items_composer_add_spec': {
      'en': 'Add specification',
      'ar': 'إضافة مواصفة',
    },
    'items_composer_for_sale': {
      'en': 'List for sale',
      'ar': 'عرض للبيع',
    },
    'items_composer_for_sale_hint': {
      'en': 'Buyers will see this item in the marketplace.',
      'ar': 'سيظهر هذا المقتنى للمشترين في السوق.',
    },
    'items_composer_price': {
      'en': 'Asking price (USD)',
      'ar': 'سعر العرض (دولار)',
    },
    'items_composer_target': {
      'en': 'Target price (USD)',
      'ar': 'السعر المستهدف (دولار)',
    },
    'item_condition_new_': {'en': 'New', 'ar': 'جديد'},
    'item_condition_like_new': {'en': 'Like new', 'ar': 'بحالة ممتازة'},
    'item_condition_used': {'en': 'Used', 'ar': 'مستعمل'},
    'item_condition_needs_fix': {'en': 'Needs repair', 'ar': 'يحتاج إلى إصلاح'},
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
