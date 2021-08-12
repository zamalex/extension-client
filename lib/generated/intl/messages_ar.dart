// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static m0(dow, day, month, year, time) => "${dow}, ${day} ${month} ${year} at ${time}";

  static m1(sort) => "${Intl.select(sort, {'date_asc': 'Oldest first', 'date_desc': 'Newest first', 'other': 'Other', })}";

  static m2(status) => "${Intl.select(status, {'active': 'Active', 'completed': 'Completed', 'other': 'Other', })}";

  static m3(number) => "بـ ${number}?";

  static m4(current, total) => "Step ${current} of ${total}";

  static m5(page) => "${Intl.select(page, {'page1': 'Select services', 'page2': 'Select staff', 'page3': 'Appointment', 'page4': 'Confirmation', 'other': '---', })}";

  static m6(from, to, total) => "من ${from} الى ${to} (${total})";

  static m7(name) => "${name} is not available on this day";

  static m8(name) => "مع ${name}";

  static m9(status) => "${Intl.select(status, {'active': 'active', 'canceled': 'canceled', 'completed': 'completed', 'declined': 'declined', 'failed': 'failed', 'other': 'unknown', })}";

  static m10(value) => "\$${value}";

  static m11(mode) => "${Intl.select(mode, {'dynamic': 'Dynamic', 'alwaysOn': 'Always on', 'alwaysOff': 'Always off', 'other': 'Unknown', })}";

  static m12(value) => "${value} دقيقة";

  static m13(mins) => "in 1 hour, ${mins} mins";

  static m14(hours) => "in 1 day, ${hours} hours";

  static m15(days) => "in ${days} days";

  static m16(hours) => "in ${hours} hours";

  static m17(mins) => "in ${mins} mins";

  static m18(locale) => "${Intl.select(locale, {'ar': 'Arabic', 'en': 'English', 'hr': 'Croatian', 'other': 'Unknown', })}";

  static m19(day) => "${Intl.select(day, {'january': 'January', 'february': 'February', 'march': 'March', 'april': 'April', 'may': 'May', 'june': 'June', 'july': 'July', 'august': 'August', 'september': 'September', 'october': 'October', 'november': 'November', 'december': 'December', 'other': 'Unknown', })}";

  static m20(day) => "${Intl.select(day, {'january': 'Jan', 'february': 'Feb', 'march': 'Mar', 'april': 'Apr', 'may': 'May', 'june': 'Jun', 'july': 'Jul', 'august': 'Aug', 'september': 'Sep', 'october': 'Oct', 'november': 'Nov', 'december': 'Dec', 'other': 'Unknown', })}";

  static m21(source) => "${Intl.select(source, {'gallery': 'Photo gallery', 'camera': 'Phone camera', 'other': '---', })}";

  static m22(day) => "${Intl.select(day, {'monday': 'Monday', 'tuesday': 'Tuesday', 'wednesday': 'Wednesday', 'thursday': 'Thursday', 'friday': 'Friday', 'saturday': 'Saturday', 'sunday': 'Sunday', 'other': 'Unknown', })}";

  static m23(day) => "${Intl.select(day, {'monday': 'Mon', 'tuesday': 'Tue', 'wednesday': 'Wed', 'thursday': 'Thu', 'friday': 'Fri', 'saturday': 'Sat', 'sunday': 'Sun', 'other': 'Unknown', })}";

  static m24(length) => "Min. length is ${length} characters";

  static m25(name) => "اهلا, ${name}!";

  static m26(code) => "Get Salon and use code ${code} to get US\$5 off your first booking expenses.";

  static m27(num) => "${num} خدمة متاحة";

  static m28(number) => "الاتصال بالرقم ${number}?";

  static m29(date) => "تم الرد في ${date}";

  static m30(num) => "${num} تقييم";

  static m31(num) => "${num} characters remaining";

  static m32(from, to) => "${from} - ${to} km";

  static m33(num) => "${num}+ Stars";

  static m34(num) => "الصالونات (${num})";

  static m35(length) => "Password must be at least ${length} characters long and contain at least one number and one uppercase letter.";

  static m36(date) => "Valid until: ${date}";

  static m37(date) => "Expired on: ${date}";

  static m38(date) => "Redeemed on: ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addPaymentCardButton" : MessageLookupByLibrary.simpleMessage("Save Card"),
    "addPaymentCardTitle" : MessageLookupByLibrary.simpleMessage("Add card"),
    "appointmentAt" : m0,
    "appointmentCancelationConfirmation" : MessageLookupByLibrary.simpleMessage("هل انت متاكد ؟"),
    "appointmentSubtitleNotes" : MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "appointmentSubtitleTotal" : MessageLookupByLibrary.simpleMessage("الاجمالي"),
    "appointmentsBtnExplore" : MessageLookupByLibrary.simpleMessage("Explore salons nearby"),
    "appointmentsLabelReview" : MessageLookupByLibrary.simpleMessage("Review"),
    "appointmentsSort" : m1,
    "appointmentsStatusGroup" : m2,
    "appointmentsTitle" : MessageLookupByLibrary.simpleMessage("المواعيد"),
    "appointmentsWarningCompletedList" : MessageLookupByLibrary.simpleMessage("No previous appointments found."),
    "appointmentsWarningOtherList" : MessageLookupByLibrary.simpleMessage("No appointment found that matches your search criteria."),
    "appointmentsWarningUpcomingList" : MessageLookupByLibrary.simpleMessage("No upcoming appointments found."),
    "appointmentsWelcomeSignInBtn" : MessageLookupByLibrary.simpleMessage("Sign in"),
    "appointmentsWelcomeSignInLabel" : MessageLookupByLibrary.simpleMessage("Already registered?"),
    "appointmentsWelcomeSubtitle" : MessageLookupByLibrary.simpleMessage("Explore and book your first appointment"),
    "appointmentsWelcomeTitle" : MessageLookupByLibrary.simpleMessage("My Appointments"),
    "bcart" : MessageLookupByLibrary.simpleMessage("السلة"),
    "bhome" : MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "bookingAddNotes" : MessageLookupByLibrary.simpleMessage("اضافة ملاحظات"),
    "bookingBtnCalendar" : MessageLookupByLibrary.simpleMessage("Calendar"),
    "bookingBtnCall" : MessageLookupByLibrary.simpleMessage("Call"),
    "bookingBtnCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "bookingBtnClose" : MessageLookupByLibrary.simpleMessage("Ok, got it"),
    "bookingBtnConfirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "bookingBtnNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "bookingBtnNotes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "bookingCallConfirmation" : m3,
    "bookingLabelSteps" : m4,
    "bookingMinutes" : MessageLookupByLibrary.simpleMessage("دقيقة"),
    "bookingNoteslabel" : MessageLookupByLibrary.simpleMessage("ملاحظات خاصة"),
    "bookingPayInStore" : MessageLookupByLibrary.simpleMessage("الدفع في الصالون"),
    "bookingPayWithCard" : MessageLookupByLibrary.simpleMessage("الدفع بالنقاط"),
    "bookingSigninTitle" : MessageLookupByLibrary.simpleMessage("Login to continue"),
    "bookingStaffNoPreferenceDescription" : MessageLookupByLibrary.simpleMessage("No preference"),
    "bookingStaffNoPreferenceName" : MessageLookupByLibrary.simpleMessage("No preference"),
    "bookingSubtitleAppointment" : MessageLookupByLibrary.simpleMessage("الموعد"),
    "bookingSubtitleCancelationPolicy" : MessageLookupByLibrary.simpleMessage("سياسة الإلغاء"),
    "bookingSubtitleCheckout" : MessageLookupByLibrary.simpleMessage("تم"),
    "bookingSubtitleDate" : MessageLookupByLibrary.simpleMessage("التاريخ"),
    "bookingSubtitleLocation" : MessageLookupByLibrary.simpleMessage("الصالون"),
    "bookingSubtitleServices" : MessageLookupByLibrary.simpleMessage("الخدمات"),
    "bookingSubtitleSignin" : MessageLookupByLibrary.simpleMessage("سجل الدخول اولا"),
    "bookingSubtitleTime" : MessageLookupByLibrary.simpleMessage("الوقت"),
    "bookingSuccessSubtitle" : MessageLookupByLibrary.simpleMessage("لا تحتاج إلى فعل أي شيء آخر. سنرسل لك تذكيرًا قبل الموعد"),
    "bookingSuccessTitle" : MessageLookupByLibrary.simpleMessage("تم الحجز"),
    "bookingTitleWizardPage" : m5,
    "bookingTotalTime" : m6,
    "bookingWarningAppointment" : MessageLookupByLibrary.simpleMessage("اختر التاريخ والوقت من القائمة التي تناسبك."),
    "bookingWarningNoServices" : MessageLookupByLibrary.simpleMessage("لا توجد خدمات"),
    "bookingWarningNoSlots" : MessageLookupByLibrary.simpleMessage("غير متاح"),
    "bookingWarningServices" : MessageLookupByLibrary.simpleMessage("الرجاء تحديد خدمة واحدة على الأقل للمتابعة"),
    "bookingWarningStaffUnavailable" : m7,
    "bookingWithStaff" : m8,
    "bprofile" : MessageLookupByLibrary.simpleMessage("بياناتي"),
    "bsearch" : MessageLookupByLibrary.simpleMessage("البحث"),
    "chatOnlineLabel" : MessageLookupByLibrary.simpleMessage("Online"),
    "chatPlaceholder" : MessageLookupByLibrary.simpleMessage("Type a message..."),
    "commonAppointmentStatus" : m9,
    "commonBtnApply" : MessageLookupByLibrary.simpleMessage("تطبيق"),
    "commonBtnCancel" : MessageLookupByLibrary.simpleMessage("الغاء"),
    "commonBtnClose" : MessageLookupByLibrary.simpleMessage("اغلاق"),
    "commonBtnOk" : MessageLookupByLibrary.simpleMessage("حستا"),
    "commonCurrencyFormat" : m10,
    "commonDarkMode" : m11,
    "commonDialogsErrorTitle" : MessageLookupByLibrary.simpleMessage("Oops!"),
    "commonDurationFormat" : m12,
    "commonElapseHhourMins" : m13,
    "commonElapsedDayHours" : m14,
    "commonElapsedDays" : m15,
    "commonElapsedHours" : m16,
    "commonElapsedMins" : m17,
    "commonElapsedNow" : MessageLookupByLibrary.simpleMessage("in process"),
    "commonGendersWomen" : MessageLookupByLibrary.simpleMessage("Women only"),
    "commonLocales" : m18,
    "commonLocationFavorited" : MessageLookupByLibrary.simpleMessage("تم الاضافة الى مفضلاتك"),
    "commonLocationUnfavorited" : MessageLookupByLibrary.simpleMessage("تم الحذف من مفضلاتك"),
    "commonLowestRating" : MessageLookupByLibrary.simpleMessage("الافل تقييما"),
    "commonMonthLong" : m19,
    "commonMonthShort" : m20,
    "commonPhotoSources" : m21,
    "commonRating" : MessageLookupByLibrary.simpleMessage("الاعلى تقييما"),
    "commonReadMore" : MessageLookupByLibrary.simpleMessage("read more"),
    "commonSearchSortTypeDistance" : MessageLookupByLibrary.simpleMessage("الاقرب"),
    "commonSearchSortTypePopularity" : MessageLookupByLibrary.simpleMessage("الاكثر شهرة"),
    "commonSearchSortTypePrice" : MessageLookupByLibrary.simpleMessage("الافل سعرا"),
    "commonSearchSortTypeRating" : MessageLookupByLibrary.simpleMessage("الاعلى تقييما"),
    "commonSmartRefresherFooterCanLoadingText" : MessageLookupByLibrary.simpleMessage("Release to load more"),
    "commonSmartRefresherFooterIdleText" : MessageLookupByLibrary.simpleMessage("Pull to load more"),
    "commonSmartRefresherFooterLoadingText" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "commonSmartRefresherHeaderCompleteText" : MessageLookupByLibrary.simpleMessage("Refresh completed"),
    "commonSmartRefresherHeaderIdleText" : MessageLookupByLibrary.simpleMessage("Pull down to refresh"),
    "commonSmartRefresherHeaderRefreshingText" : MessageLookupByLibrary.simpleMessage("Refreshing..."),
    "commonSmartRefresherHeaderReleaseText" : MessageLookupByLibrary.simpleMessage("Release to refresh"),
    "commonTooltipInfo" : MessageLookupByLibrary.simpleMessage("Info"),
    "commonTooltipRefresh" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "commonWeekdayLong" : m22,
    "commonWeekdayShort" : m23,
    "commonWeekdayToday" : MessageLookupByLibrary.simpleMessage("اليوم"),
    "commonWeekdayTomorrow" : MessageLookupByLibrary.simpleMessage("غدا"),
    "editProfileBtnUpdate" : MessageLookupByLibrary.simpleMessage("تعديل"),
    "editProfileLabelAddress" : MessageLookupByLibrary.simpleMessage("العنوان"),
    "editProfileLabelCity" : MessageLookupByLibrary.simpleMessage("المدينة"),
    "editProfileLabelFullname" : MessageLookupByLibrary.simpleMessage("الاسم"),
    "editProfileLabelPhone" : MessageLookupByLibrary.simpleMessage("ؤقم الجوال"),
    "editProfileLabelZIP" : MessageLookupByLibrary.simpleMessage("ZIP"),
    "editProfileListTitleAddress" : MessageLookupByLibrary.simpleMessage("العنوان"),
    "editProfileListTitleContact" : MessageLookupByLibrary.simpleMessage("الاتصال"),
    "editProfileSuccess" : MessageLookupByLibrary.simpleMessage("تم التعديل بنجاح"),
    "editProfileTitle" : MessageLookupByLibrary.simpleMessage("تعديل الملف الشخصي"),
    "emptyTitle" : MessageLookupByLibrary.simpleMessage("(not implemented)"),
    "favoritesNoResults" : MessageLookupByLibrary.simpleMessage("Your favorites list is empty."),
    "favoritesTitle" : MessageLookupByLibrary.simpleMessage("My favorites"),
    "favoritesTitleNoResults" : MessageLookupByLibrary.simpleMessage("No favorites yet"),
    "forgotPasswordBack" : MessageLookupByLibrary.simpleMessage("العودة"),
    "forgotPasswordBtn" : MessageLookupByLibrary.simpleMessage("استعادة كلمة المرور"),
    "forgotPasswordDialogText" : MessageLookupByLibrary.simpleMessage("تم ارسال رمز التحقق الى رقم جوالك"),
    "forgotPasswordDialogTitle" : MessageLookupByLibrary.simpleMessage("تم ارسال رمز التحقق"),
    "forgotPasswordLabel" : MessageLookupByLibrary.simpleMessage("ادخل رقم الجوال وسيتم ارسال رمز التحقق"),
    "forgotPasswordTitle" : MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "formValidatorEmail" : MessageLookupByLibrary.simpleMessage("الهاتف ليس صحيح"),
    "formValidatorInvalidPassword" : MessageLookupByLibrary.simpleMessage("كلمة المرور غير صحيحة"),
    "formValidatorMinLength" : m24,
    "formValidatorRequired" : MessageLookupByLibrary.simpleMessage("الحقل مطلوب"),
    "homeHeaderSubtitle" : MessageLookupByLibrary.simpleMessage("Book what you love"),
    "homePlaceholderSearch" : MessageLookupByLibrary.simpleMessage("Search for a service or business"),
    "homeTitleGuest" : MessageLookupByLibrary.simpleMessage("اكتشف"),
    "homeTitlePopularCategories" : MessageLookupByLibrary.simpleMessage("الاقسام"),
    "homeTitleRecentlyViewed" : MessageLookupByLibrary.simpleMessage("المعروض حديثا"),
    "homeTitleTopRated" : MessageLookupByLibrary.simpleMessage("الاعلى تقييما"),
    "homeTitleUser" : m25,
    "inboxSlideButtonArchive" : MessageLookupByLibrary.simpleMessage("Archive"),
    "inboxSlideButtonDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "inboxTitle" : MessageLookupByLibrary.simpleMessage("Messages"),
    "inviteButton" : MessageLookupByLibrary.simpleMessage("Share your code"),
    "inviteDescription" : MessageLookupByLibrary.simpleMessage("Invite your friends and give them each US\$5 in coupons. And for every friend who completes their first booking process, we will give you a US\$5 coupon!"),
    "inviteEarningsLabel" : MessageLookupByLibrary.simpleMessage("Total Earnings"),
    "inviteShareText" : m26,
    "inviteSubtitle" : MessageLookupByLibrary.simpleMessage("Get discounts by inviting friends"),
    "inviteTitle" : MessageLookupByLibrary.simpleMessage("Invite friends"),
    "locationAvailableServies" : m27,
    "locationBtnBook" : MessageLookupByLibrary.simpleMessage("احجز"),
    "locationCallConfirmation" : m28,
    "locationClosed" : MessageLookupByLibrary.simpleMessage("مفلق"),
    "locationCurrentlyClosed" : MessageLookupByLibrary.simpleMessage("مفلق الان"),
    "locationInstantConfirmation" : MessageLookupByLibrary.simpleMessage("تأكيد فوري!"),
    "locationLabelGenders" : MessageLookupByLibrary.simpleMessage("Genders"),
    "locationLabelPhone" : MessageLookupByLibrary.simpleMessage("الهاتف"),
    "locationLabelWeb" : MessageLookupByLibrary.simpleMessage("الموقع"),
    "locationLabelWorkingHours" : MessageLookupByLibrary.simpleMessage("ساعات العمل"),
    "locationLinkAllReviews" : MessageLookupByLibrary.simpleMessage("كل التقييمات"),
    "locationLinkAllServices" : MessageLookupByLibrary.simpleMessage("كل الخدمات"),
    "locationNoResults" : MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
    "locationRepliedOn" : m29,
    "locationTitleAboutUs" : MessageLookupByLibrary.simpleMessage("عننا"),
    "locationTitleNearby" : MessageLookupByLibrary.simpleMessage("الصالونات القريبة"),
    "locationTitleRatings" : MessageLookupByLibrary.simpleMessage("التقييمات"),
    "locationTitleReviews" : MessageLookupByLibrary.simpleMessage("الاراء"),
    "locationTitleStaff" : MessageLookupByLibrary.simpleMessage("موظفينا"),
    "locationTitleTopServices" : MessageLookupByLibrary.simpleMessage("الخدمات"),
    "locationTotalReviews" : m30,
    "locationWebConfirmation" : MessageLookupByLibrary.simpleMessage("Open web page?"),
    "myOrders" : MessageLookupByLibrary.simpleMessage("طلباتي"),
    "onboardingBtnGetStarted" : MessageLookupByLibrary.simpleMessage("Get Started"),
    "onboardingBtnSkip" : MessageLookupByLibrary.simpleMessage("Skip"),
    "onboardingPage1Body" : MessageLookupByLibrary.simpleMessage("Salon lets you easily find and book appointments with local health and beauty professionals."),
    "onboardingPage1Title" : MessageLookupByLibrary.simpleMessage("Welcome to Salon"),
    "onboardingPage2Body" : MessageLookupByLibrary.simpleMessage("Find the perfect health or beauty service by name, location and availability."),
    "onboardingPage2Title" : MessageLookupByLibrary.simpleMessage("Find Businesses"),
    "onboardingPage3Body" : MessageLookupByLibrary.simpleMessage("Pick the services you want and get an instant approval. No more waiting in line."),
    "onboardingPage3Title" : MessageLookupByLibrary.simpleMessage("Make an Appointment"),
    "paymentCardTitle" : MessageLookupByLibrary.simpleMessage("Payment card"),
    "paymentCardWarningBtn" : MessageLookupByLibrary.simpleMessage("+ Add your card"),
    "paymentCardWarningNote" : MessageLookupByLibrary.simpleMessage("You can use your debit or credit card to book an appointment (card will not be charged until all the booked services are complete)."),
    "paymentCardWarningTitle" : MessageLookupByLibrary.simpleMessage("No card available"),
    "paymentCardWidgetCardHolderLabel" : MessageLookupByLibrary.simpleMessage("Card holder name"),
    "paymentCardWidgetCardHolderPlaceholder" : MessageLookupByLibrary.simpleMessage("CARD HOLDER"),
    "paymentCardWidgetCardNumberLabel" : MessageLookupByLibrary.simpleMessage("Card number"),
    "paymentCardWidgetExpirationDateLabel" : MessageLookupByLibrary.simpleMessage("Expiration date"),
    "paymentCardWidgetExpirationDatePlaceholder" : MessageLookupByLibrary.simpleMessage("MM/YY"),
    "paymentCardWidgetSecurityCodeLabel" : MessageLookupByLibrary.simpleMessage("Security code"),
    "paymentCardWidgetValidityLabel" : MessageLookupByLibrary.simpleMessage("VALID THRU"),
    "pickerBtnSelect" : MessageLookupByLibrary.simpleMessage("اختر"),
    "pickerPlaceholderSearch" : MessageLookupByLibrary.simpleMessage("البحث"),
    "pickerTitleCity" : MessageLookupByLibrary.simpleMessage("اختر المكان"),
    "pickerTitleDate" : MessageLookupByLibrary.simpleMessage("اختار التاريخ"),
    "pickerTitleLanguages" : MessageLookupByLibrary.simpleMessage("اختر اللغة"),
    "profileListAppointments" : MessageLookupByLibrary.simpleMessage("حجوزاتي"),
    "profileListEdit" : MessageLookupByLibrary.simpleMessage("تعديل بياناتي"),
    "profileListFavorites" : MessageLookupByLibrary.simpleMessage("مفضلاتي"),
    "profileListInvite" : MessageLookupByLibrary.simpleMessage("Invite friends"),
    "profileListLogout" : MessageLookupByLibrary.simpleMessage("تسجبل الخروج"),
    "profileListPaymentCard" : MessageLookupByLibrary.simpleMessage("Payment card"),
    "profileListReviews" : MessageLookupByLibrary.simpleMessage("تقييماتي"),
    "profileListSettings" : MessageLookupByLibrary.simpleMessage("الاعدادات"),
    "profileListTitleSettings" : MessageLookupByLibrary.simpleMessage("الاعدادات"),
    "profileListVouchers" : MessageLookupByLibrary.simpleMessage("My vouchers"),
    "reviewCommentPlaceholder" : MessageLookupByLibrary.simpleMessage("اكتب تقييمك هنا..."),
    "reviewLabelComment" : MessageLookupByLibrary.simpleMessage("Your Comment (optional)"),
    "reviewLabelRate" : MessageLookupByLibrary.simpleMessage("What\'s Your Rate?"),
    "reviewLengthLimit" : m31,
    "reviewSubmitBtn" : MessageLookupByLibrary.simpleMessage("ارسال"),
    "reviewSuccessSubtitle" : MessageLookupByLibrary.simpleMessage("تم الارسال بنجاح"),
    "reviewSuccessTitle" : MessageLookupByLibrary.simpleMessage("شكرا"),
    "reviewTitle" : MessageLookupByLibrary.simpleMessage("قيم الخدمة"),
    "reviewWarning" : MessageLookupByLibrary.simpleMessage("Please rate this salon by clicking on the number of stars you want to assign."),
    "reviewsTitle" : MessageLookupByLibrary.simpleMessage("تقييماتي"),
    "searchBtnGroupAny" : MessageLookupByLibrary.simpleMessage("Any"),
    "searchBtnGroupCurrentlyOpen" : MessageLookupByLibrary.simpleMessage("Currently Open"),
    "searchDrawerDistanceRange" : m32,
    "searchLabelAll" : MessageLookupByLibrary.simpleMessage("الكل"),
    "searchLabelNearby" : MessageLookupByLibrary.simpleMessage("قريب منك"),
    "searchLabelQuickSearch" : MessageLookupByLibrary.simpleMessage("ما الذي تبحث عنه"),
    "searchLabelRatingFilter" : m33,
    "searchPlaceholderQuickSearchCities" : MessageLookupByLibrary.simpleMessage("اسم المدينة..."),
    "searchPlaceholderQuickSearchLocations" : MessageLookupByLibrary.simpleMessage("اسم الصالون ..."),
    "searchTitleDistance" : MessageLookupByLibrary.simpleMessage("المسافة"),
    "searchTitleFilter" : MessageLookupByLibrary.simpleMessage("Filter"),
    "searchTitleLocationServiceDisabled" : MessageLookupByLibrary.simpleMessage("Location service disabled"),
    "searchTitleNoResults" : MessageLookupByLibrary.simpleMessage("No results"),
    "searchTitlePrice" : MessageLookupByLibrary.simpleMessage("السعر"),
    "searchTitleRating" : MessageLookupByLibrary.simpleMessage("التقييم"),
    "searchTitleRecentSearches" : MessageLookupByLibrary.simpleMessage("تاريخ البحث"),
    "searchTitleResults" : m34,
    "searchTitleSortOrder" : MessageLookupByLibrary.simpleMessage("Sort order"),
    "searchTitleWorkingHours" : MessageLookupByLibrary.simpleMessage("ساعات العمل"),
    "searchTooltipBack" : MessageLookupByLibrary.simpleMessage("العودة"),
    "searchTooltipFilters" : MessageLookupByLibrary.simpleMessage("Filters"),
    "searchTooltipMap" : MessageLookupByLibrary.simpleMessage("الخريطة"),
    "searchTooltipView" : MessageLookupByLibrary.simpleMessage("عرض"),
    "settingsCopyright" : MessageLookupByLibrary.simpleMessage("© 2020 Zoran Juric"),
    "settingsHomepageConfirmation" : MessageLookupByLibrary.simpleMessage("Want to visit the template homepage?"),
    "settingsListDarkMode" : MessageLookupByLibrary.simpleMessage("Dark mode"),
    "settingsListLanguage" : MessageLookupByLibrary.simpleMessage("اللغة"),
    "settingsListPrivacy" : MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "settingsListTerms" : MessageLookupByLibrary.simpleMessage("شروط الاستخدام"),
    "settingsListTitleInterface" : MessageLookupByLibrary.simpleMessage("Interface"),
    "settingsListTitleSupport" : MessageLookupByLibrary.simpleMessage("Support"),
    "settingsTitle" : MessageLookupByLibrary.simpleMessage("الاعدادات"),
    "signInButtonForgot" : MessageLookupByLibrary.simpleMessage("نسيت كلمة المرو؟"),
    "signInButtonLogin" : MessageLookupByLibrary.simpleMessage("تسجيل دخول"),
    "signInButtonRegister" : MessageLookupByLibrary.simpleMessage("سجل الان"),
    "signInFormTitle" : MessageLookupByLibrary.simpleMessage("Welcome back"),
    "signInHintEmail" : MessageLookupByLibrary.simpleMessage("رقم الجوال"),
    "signInHintPassword" : MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "signInRegisterLabel" : MessageLookupByLibrary.simpleMessage("ليس لديك حساب"),
    "signInTitle" : MessageLookupByLibrary.simpleMessage("تسجيل دخول"),
    "signUpBtnSend" : MessageLookupByLibrary.simpleMessage("انشاء حساب"),
    "signUpErrorConsent" : MessageLookupByLibrary.simpleMessage("يجب عليك قبول شروط وأحكام الخدمة للمتابعة."),
    "signUpHelptextPassword" : m35,
    "signUpHintFullName" : MessageLookupByLibrary.simpleMessage("الاسم"),
    "signUpHintLabelPassword" : MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "signUpLabelConsent" : MessageLookupByLibrary.simpleMessage("لقد قرأت ووافقت على شروط خدمة المستخدم وأدرك أنه ستتم معالجة بياناتي الشخصية وفقًا لبيان الخصوصية."),
    "signUpLabelFullName" : MessageLookupByLibrary.simpleMessage("الاسم"),
    "signUpLabelPassword" : MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "signUpReadMore" : MessageLookupByLibrary.simpleMessage("View the legal documents"),
    "signUpTitle" : MessageLookupByLibrary.simpleMessage("انشاء حساب"),
    "signupHintLabelEmail" : MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "signupLabelEmail" : MessageLookupByLibrary.simpleMessage("البريد الالكتروني"),
    "takePictureTitle" : MessageLookupByLibrary.simpleMessage("Take a picture"),
    "topRatedSalonz" : MessageLookupByLibrary.simpleMessage("الاعلى تقييما"),
    "voucherLabelCouponCode" : MessageLookupByLibrary.simpleMessage("Coupon Code"),
    "voucherLabelSpecialTerms" : MessageLookupByLibrary.simpleMessage("Special Terms And Conditions"),
    "vouchersDueDateActive" : m36,
    "vouchersDueDateExpired" : m37,
    "vouchersDueDateRedeemed" : m38,
    "vouchersHeroNoteActive" : MessageLookupByLibrary.simpleMessage("No available coupon found."),
    "vouchersHeroNoteExpired" : MessageLookupByLibrary.simpleMessage("No coupon expired so far."),
    "vouchersHeroNoteRedeemed" : MessageLookupByLibrary.simpleMessage("You have not used any of your coupons so far."),
    "vouchersInfo" : MessageLookupByLibrary.simpleMessage("Here you can see a list of your coupons that you can use the next time you visit a particular location. When paying the bill for a certain service, the final amount will be reduced by the amount indicated on the coupon."),
    "vouchersLabelOff" : MessageLookupByLibrary.simpleMessage("off the final price"),
    "vouchersTabActive" : MessageLookupByLibrary.simpleMessage("Active"),
    "vouchersTabExpired" : MessageLookupByLibrary.simpleMessage("Expired"),
    "vouchersTabRedeemed" : MessageLookupByLibrary.simpleMessage("Redeemed"),
    "vouchersTitle" : MessageLookupByLibrary.simpleMessage("My vouchers")
  };
}
