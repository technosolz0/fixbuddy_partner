// import 'dart:convert';
// import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
// import 'package:fixbuddy_partner/app/utils/servex_utils.dart';

// class LocalStorage {
//   AndroidOptions _getAndroidOptions() =>
//       const AndroidOptions(encryptedSharedPreferences: true);

//   late FlutterSecureStorage pref;

//   LocalStorage() {
//     pref = FlutterSecureStorage(aOptions: _getAndroidOptions());
//   }

//   // General shared pref keys
//   final String tokenKey = 'tokenKey';
//   final String firebaseTokenKey = 'firebaseTokenKey';
//   final String VendorIDKey = 'VendorIDKey';
//   final String lastLoginDateKey = 'lastLoginDateKey';
//   final String VendorLanguageKey = 'VendorLanguageKey';
//   final String lastFCMUpdatedAtKey = 'lastFCMUpdatedAtKey';
//   final String lastSentFCMKey = 'lastSentFCMKey';
//   final String isOnboardedKey = 'isOnboardedKey';
//   final String hasResetPasswordKey = 'hasResetPasswordKey';
//   final String allGoalsProvidedKey = 'allGoalsProvidedKey';
//   final String VendorDetailsKey = 'VendorDetailsKey';
//   final String isDarkModeKey = 'isDarkModeKey';

//   // Device info keys
//   final String deviceNameKey = 'deviceNameKey';
//   final String deviceLatitudeKey = 'deviceLatitudeKey';
//   final String deviceLongitudeKey = 'deviceLongitudeKey';

//   // Registration key
//   final String registrationModalKey = 'registrationModal';

//   // Task reminders related keys
//   final String reminderPreferenceKey = 'reminderPreferenceKey';
//   final String preferredCalIdKey = 'preferredCalIdKey';
//   final String addedCalendarEventIdKey = 'addedCalendarEventIdKey';
//   final String addedRemindersKey = 'addedRemindersKey';

//   final String homeDataKey = 'homeDataKey';
//   final String lastHomeDataFetchedAtKey = 'lastHomeDataFetchedAtKey';
//   final String lastStepsUpdatedAtKey = 'lastStepsUpdatedAtKey';
//   final String lastAssessmentRemindedAt = 'lastAssessmentRemindedAtKey';
//   final String VendorOptedForManualStepsKey = 'VendorOptedForManualStepsKey';
//   final String hasFetchedStepsProgressTodayKey =
//       'hasFetchedStepsProgressTodayKey';
//   final String stepsProgressTrackingKey = 'stepsProgressTrackingKey';
//   final String VendorBadgesKey = 'VendorBadgesKey';

//   final String communityDataKey = 'communityDataKey';
//   final String VendorBuddiesKey = 'VendorBuddiesKey';
//   final String VendorSentBuddyRequestsKey = 'VendorSentBuddyRequestsKey';

//   final String hasIOSHealthPermissionKey = 'hasIOHealthPermissionKey';
//   final String lastAssessedAtKey = 'lastAssessedAtKey';
//   final String stepsDataKey = 'stepsDataKey';
//   final String stepsPreferenceKey = 'stepsPreferenceKey';

//   Future<void> clearLocalStorage({bool preserveRegistration = true}) async {
//     String? prevLang = await getLanguage();
//     bool? prevIsDarkMode = await getIsDarkMode();
//     String? registrationData = preserveRegistration
//         ? await pref.read(key: registrationModalKey)
//         : null;

//     await pref.deleteAll(aOptions: _getAndroidOptions());
//     ServexUtils.logPrint(
//       'Local storage cleared${preserveRegistration ? ', preserving registration data' : ''}',
//     );

//     if (prevLang != null) {
//       await setLanguage(prevLang);
//     }
//     if (prevIsDarkMode != null) {
//       await setIsDarkMode(prevIsDarkMode);
//     }
//     if (preserveRegistration && registrationData != null) {
//       try {
//         final jsonData = jsonDecode(registrationData);
//         if (jsonData is Map<String, dynamic> &&
//             jsonData['registration_step'] is int &&
//             jsonData['registration_step'] < 5) {
//           await pref.write(key: registrationModalKey, value: registrationData);
//           ServexUtils.logPrint(
//             'Preserved registrationModal with step: ${jsonData['registration_step']}',
//           );
//         } else {
//           ServexUtils.logPrint(
//             'Registration data not preserved: ${jsonData['registration_step'] == 5 ? 'registration complete' : 'invalid data'}',
//           );
//         }
//       } catch (e) {
//         ServexUtils.logPrint(
//           'Error parsing registration data during clear: $e',
//         );
//       }
//     }
//   }

//   // Token
//   Future<void> setToken(String val) async {
//     await pref.write(key: tokenKey, value: val);
//   }

//   Future<String?> getToken() async {
//     return await pref.read(key: tokenKey);
//   }

//   // Vendor ID
//   Future<void> setVendorID(String val) async {
//     await pref.write(key: VendorIDKey, value: val);
//   }

//   Future<String?> getVendorID() async {
//     return await pref.read(key: VendorIDKey);
//   }

//   // Last login date
//   Future<void> setLastLoginDate(DateTime val) async {
//     await pref.write(key: lastLoginDateKey, value: val.toString());
//   }

//   Future<DateTime?> getLastLoginDate() async {
//     String? str = await pref.read(key: lastLoginDateKey);
//     if (str == null) return null;
//     return DateTime.tryParse(str);
//   }

//   // Language
//   Future<void> setLanguage(String val) async {
//     await pref.write(key: VendorLanguageKey, value: val);
//   }

//   Future<String?> getLanguage() async {
//     return await pref.read(key: VendorLanguageKey);
//   }

//   // Last FCM updated at
//   Future<void> setLastFCMUpdatedAtDate(DateTime val) async {
//     await pref.write(key: lastFCMUpdatedAtKey, value: val.toString());
//   }

//   Future<DateTime?> getLastFCMUpdatedAtDate() async {
//     String? str = await pref.read(key: lastFCMUpdatedAtKey);
//     if (str == null) return null;
//     return DateTime.tryParse(str);
//   }

//   // Last sent FCM
//   Future<void> setLastSentFCM(String val) async {
//     await pref.write(key: lastSentFCMKey, value: val);
//   }

//   Future<String?> getLastSentFCM() async {
//     return await pref.read(key: lastSentFCMKey);
//   }

//   // Onboarded
//   Future<void> setIsOnboarded(bool val) async {
//     await pref.write(key: isOnboardedKey, value: val.toString());
//   }

//   Future<bool> getIsOnboarded() async {
//     return bool.parse(await pref.read(key: isOnboardedKey) ?? 'false');
//   }

//   // Reset password
//   Future<void> setHasResetPassword(bool val) async {
//     await pref.write(key: hasResetPasswordKey, value: val.toString());
//   }

//   Future<bool> getHasResetPassword() async {
//     return bool.parse(await pref.read(key: hasResetPasswordKey) ?? 'false');
//   }

//   // Goals provided
//   Future<void> setAllGoalsProvided(bool val) async {
//     await pref.write(key: allGoalsProvidedKey, value: val.toString());
//   }

//   Future<bool> getAllGoalsProvided() async {
//     return bool.parse(await pref.read(key: allGoalsProvidedKey) ?? 'false');
//   }

//   // Vendor details (old method kept for compatibility)
//   Future<void> setVendorDetails(VendorModel details) async {
//     await pref.write(key: VendorDetailsKey, value: jsonEncode(details.toJson()));
//   }

//   Future<void> setVendorDetails(VendorModel vendor) async {
//     await pref.write(key: VendorDetailsKey, value: jsonEncode(vendor.toJson()));
//     ServexUtils.logPrint('Vendor details saved: $vendor');
//   }

//   Future<VendorModel?> getVendorDetails() async {
//     try {
//       String? data = await pref.read(key: VendorDetailsKey);
//       if (data == null) return null;
//       final jsonData = jsonDecode(data);
//       if (jsonData is Map<String, dynamic>) {
//         return VendorModel.fromJson(jsonData);
//       }
//       ServexUtils.logPrint('Invalid vendor details format: $jsonData');
//       return null;
//     } catch (e) {
//       ServexUtils.logPrint('Error loading vendor details: $e');
//       return null;
//     }
//   }

//   // Dark mode
//   Future<void> setIsDarkMode(bool val) async {
//     await pref.write(key: isDarkModeKey, value: val.toString());
//   }

//   Future<bool?> getIsDarkMode() async {
//     String? str = await pref.read(key: isDarkModeKey);
//     if (str == null) return null;
//     return bool.tryParse(str);
//   }

//   // Device info
//   Future<void> setDeviceName(String val) async {
//     await pref.write(key: deviceNameKey, value: val);
//   }

//   Future<String?> getDeviceName() async {
//     return await pref.read(key: deviceNameKey);
//   }

//   Future<void> setDeviceLatitude(String val) async {
//     await pref.write(key: deviceLatitudeKey, value: val);
//   }

//   Future<String?> getDeviceLatitude() async {
//     return await pref.read(key: deviceLatitudeKey);
//   }

//   Future<void> setDeviceLongitude(String val) async {
//     await pref.write(key: deviceLongitudeKey, value: val);
//   }

//   Future<String?> getDeviceLongitude() async {
//     return await pref.read(key: deviceLongitudeKey);
//   }

//   // Registration step
//   Future<void> setRegistrationStep(int step) async {
//     try {
//       String? registrationData = await pref.read(key: registrationModalKey);
//       Map<String, dynamic> registrationModal = registrationData != null
//           ? jsonDecode(registrationData) as Map<String, dynamic>
//           : {};
//       registrationModal['registration_step'] = step;
//       await pref.write(
//         key: registrationModalKey,
//         value: jsonEncode(registrationModal),
//       );
//       ServexUtils.logPrint('Registration step saved: $step');
//     } catch (e) {
//       ServexUtils.logPrint('Error saving registration step: $e');
//     }
//   }

//   Future<int> getRegistrationStep() async {
//     try {
//       String? registrationData = await pref.read(key: registrationModalKey);
//       if (registrationData == null) return 0;
//       final jsonData = jsonDecode(registrationData);
//       if (jsonData is Map<String, dynamic> &&
//           jsonData['registration_step'] is int) {
//         ServexUtils.logPrint(
//           'Registration step loaded: ${jsonData['registration_step']}',
//         );
//         return jsonData['registration_step'] as int;
//       }
//       ServexUtils.logPrint('Invalid registration step format: $jsonData');
//       return 0;
//     } catch (e) {
//       ServexUtils.logPrint('Error loading registration step: $e');
//       return 0;
//     }
//   }
// }

import 'dart:convert';
import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/utils/servex_utils.dart';
import 'package:intl/intl.dart';

class LocalStorage {
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  late FlutterSecureStorage pref;

  LocalStorage() {
    pref = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  // General shared pref keys
  final String tokenKey = 'tokenKey';
  final String firebaseTokenKey = 'firebaseTokenKey';
  final String VendorIDKey = 'VendorIDKey';
  final String lastLoginDateKey = 'lastLoginDateKey';
  final String VendorLanguageKey = 'VendorLanguageKey';
  final String lastFCMUpdatedAtKey = 'lastFCMUpdatedAtKey';
  final String lastSentFCMKey = 'lastSentFCMKey';
  final String isOnboardedKey = 'isOnboardedKey';
  final String hasResetPasswordKey = 'hasResetPasswordKey';
  final String allGoalsProvidedKey = 'allGoalsProvidedKey';
  final String VendorDetailsKey = 'VendorDetailsKey';
  final String isDarkModeKey = 'isDarkModeKey';

  // Device info keys
  final String deviceNameKey = 'deviceNameKey';
  final String deviceLatitudeKey = 'deviceLatitudeKey';
  final String deviceLongitudeKey = 'deviceLongitudeKey';

  // Registration key
  final String registrationModalKey = 'registrationModal';

  // Task reminders related keys
  final String reminderPreferenceKey = 'reminderPreferenceKey';
  final String preferredCalIdKey = 'preferredCalIdKey';
  final String addedCalendarEventIdKey = 'addedCalendarEventIdKey';
  final String addedRemindersKey = 'addedRemindersKey';

  final String homeDataKey = 'homeDataKey';
  final String lastHomeDataFetchedAtKey = 'lastHomeDataFetchedAtKey';
  final String lastStepsUpdatedAtKey = 'lastStepsUpdatedAtKey';
  final String lastAssessmentRemindedAt = 'lastAssessmentRemindedAtKey';
  final String VendorOptedForManualStepsKey = 'VendorOptedForManualStepsKey';
  final String hasFetchedStepsProgressTodayKey =
      'hasFetchedStepsProgressTodayKey';
  final String stepsProgressTrackingKey = 'stepsProgressTrackingKey';
  final String VendorBadgesKey = 'VendorBadgesKey';

  final String communityDataKey = 'communityDataKey';
  final String VendorBuddiesKey = 'VendorBuddiesKey';
  final String VendorSentBuddyRequestsKey = 'VendorSentBuddyRequestsKey';

  final String hasIOSHealthPermissionKey = 'hasIOHealthPermissionKey';
  final String lastAssessedAtKey = 'lastAssessedAtKey';
  final String stepsDataKey = 'stepsDataKey';
  final String stepsPreferenceKey = 'stepsPreferenceKey';

  // Additional keys from the second LocalStorage class
  final String registrationStatus = 'registrationStatus';
  final String VendorName = 'VendorName';
  final String VendorLevelName = 'VendorLevelName';
  final String VendorLevel = 'VendorLevel';
  final String VendorCategory = 'VendorCategory';
  final String VendorImg = 'VendorImg';
  final String VendorCountry = 'VendorCountry';
  final String subscriptionAmount = 'subscriptionAmount';
  final String reminder15days = 'reminder15days';
  final String reminder7days = 'reminder7days';
  final String reminder1day = 'reminder1day';
  final String VendorSubscribed = 'VendorSubscribed';
  final String followedPDF = 'followedPDF';
  final String likedDiscussions = 'likedDiscussions';
  final String bookrmarkedDiscussions = 'bookrmarkedDiscussions';
  final String likedSubmissionArticles = 'likedSubmissionArticles';
  final String bookmarkedSubmissionArticles = 'bookmarkedSubmissionArticles';
  final String isVendorActive = 'isVendorActive';
  final String subscriptionStartDate = 'subscriptionStartDate';
  final String subscriptionEndDate = 'subscriptionEndDate';
  final String VendorPoints = 'VendorPoints';
  final String followingVendors = 'followingVendors';
  final String homeNews = 'homeNews';
  final String homeDiscussions = 'homeDiscussions';
  final String homeSubsmissionArticles = 'homeSubmissionArticles';
  final String homeEvents = 'homeEvents';
  final String homeJobs = 'homeJobs';
  final String VendorPDFs = 'VendorPDFs';
  final String cachedRecentSearches = 'cachedRecentSearches';
  static String VendorProfile = "MyProfile";
  static String VendorWork = "MyWork";
  static String VendorEducation = "MyEducation";

  Future<void> clearLocalStorage({bool preserveRegistration = true}) async {
    String? prevLang = await getLanguage();
    bool? prevIsDarkMode = await getIsDarkMode();
    String? registrationData = preserveRegistration
        ? await pref.read(key: registrationModalKey)
        : null;

    await pref.deleteAll(aOptions: _getAndroidOptions());
    ServexUtils.logPrint(
      'Local storage cleared${preserveRegistration ? ', preserving registration data' : ''}',
    );

    if (prevLang != null) {
      await setLanguage(prevLang);
    }
    if (prevIsDarkMode != null) {
      await setIsDarkMode(prevIsDarkMode);
    }
    if (preserveRegistration && registrationData != null) {
      try {
        final jsonData = jsonDecode(registrationData);
        if (jsonData is Map<String, dynamic> &&
            jsonData['registration_step'] is int &&
            jsonData['registration_step'] < 5) {
          await pref.write(key: registrationModalKey, value: registrationData);
          ServexUtils.logPrint(
            'Preserved registrationModal with step: ${jsonData['registration_step']}',
          );
        } else {
          ServexUtils.logPrint(
            'Registration data not preserved: ${jsonData['registration_step'] == 5 ? 'registration complete' : 'invalid data'}',
          );
        }
      } catch (e) {
        ServexUtils.logPrint(
          'Error parsing registration data during clear: $e',
        );
      }
    }
  }

  // Firebase Token
  Future<void> setFirebaseToken(String val) async {
    await pref.write(key: firebaseTokenKey, value: val, aOptions: _getAndroidOptions());
    ServexUtils.logPrint('FCM Token saved: $val');
  }

  Future<String?> getFirebaseToken() async {
    return await pref.read(key: firebaseTokenKey, aOptions: _getAndroidOptions());
  }

  // Token
  Future<void> setToken(String val) async {
    await pref.write(key: tokenKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getToken() async {
    return await pref.read(key: tokenKey, aOptions: _getAndroidOptions());
  }

  // Vendor ID
  Future<void> setVendorID(String val) async {
    await pref.write(key: VendorIDKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getVendorID() async {
    return await pref.read(key: VendorIDKey, aOptions: _getAndroidOptions());
  }

  // Last login date
  Future<void> setLastLoginDate(DateTime val) async {
    await pref.write(key: lastLoginDateKey, value: val.toString(), aOptions: _getAndroidOptions());
  }

  Future<DateTime?> getLastLoginDate() async {
    String? str = await pref.read(key: lastLoginDateKey, aOptions: _getAndroidOptions());
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  // Language
  Future<void> setLanguage(String val) async {
    await pref.write(key: VendorLanguageKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getLanguage() async {
    return await pref.read(key: VendorLanguageKey, aOptions: _getAndroidOptions());
  }

  // Last FCM updated at
  Future<void> setLastFCMUpdatedAtDate(DateTime val) async {
    await pref.write(key: lastFCMUpdatedAtKey, value: val.toString(), aOptions: _getAndroidOptions());
  }

  Future<DateTime?> getLastFCMUpdatedAtDate() async {
    String? str = await pref.read(key: lastFCMUpdatedAtKey, aOptions: _getAndroidOptions());
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  // Last sent FCM
  Future<void> setLastSentFCM(String val) async {
    await pref.write(key: lastSentFCMKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getLastSentFCM() async {
    return await pref.read(key: lastSentFCMKey, aOptions: _getAndroidOptions());
  }

  // Onboarded
  Future<void> setIsOnboarded(bool val) async {
    await pref.write(key: isOnboardedKey, value: val.toString(), aOptions: _getAndroidOptions());
  }

  Future<bool> getIsOnboarded() async {
    return bool.parse(await pref.read(key: isOnboardedKey, aOptions: _getAndroidOptions()) ?? 'false');
  }

  // Reset password
  Future<void> setHasResetPassword(bool val) async {
    await pref.write(key: hasResetPasswordKey, value: val.toString(), aOptions: _getAndroidOptions());
  }

  Future<bool> getHasResetPassword() async {
    return bool.parse(await pref.read(key: hasResetPasswordKey, aOptions: _getAndroidOptions()) ?? 'false');
  }


  Future<void> setVendorDetails(VendorModel vendor) async {
    await pref.write(key: VendorDetailsKey, value: jsonEncode(vendor.toJson()), aOptions: _getAndroidOptions());
    ServexUtils.logPrint('Vendor details saved: $vendor');
  }

  Future<VendorModel?> getVendorDetails() async {
    try {
      String? data = await pref.read(key: VendorDetailsKey, aOptions: _getAndroidOptions());
      if (data == null) return null;
      final jsonData = jsonDecode(data);
      if (jsonData is Map<String, dynamic>) {
        return VendorModel.fromJson(jsonData);
      }
      ServexUtils.logPrint('Invalid vendor details format: $jsonData');
      return null;
    } catch (e) {
      ServexUtils.logPrint('Error loading vendor details: $e');
      return null;
    }
  }

  // Dark mode
  Future<void> setIsDarkMode(bool val) async {
    await pref.write(key: isDarkModeKey, value: val.toString(), aOptions: _getAndroidOptions());
  }

  Future<bool?> getIsDarkMode() async {
    String? str = await pref.read(key: isDarkModeKey, aOptions: _getAndroidOptions());
    if (str == null) return null;
    return bool.tryParse(str);
  }

  // Device info
  Future<void> setDeviceName(String val) async {
    await pref.write(key: deviceNameKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getDeviceName() async {
    return await pref.read(key: deviceNameKey, aOptions: _getAndroidOptions());
  }

  Future<void> setDeviceLatitude(String val) async {
    await pref.write(key: deviceLatitudeKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getDeviceLatitude() async {
    return await pref.read(key: deviceLatitudeKey, aOptions: _getAndroidOptions());
  }

  Future<void> setDeviceLongitude(String val) async {
    await pref.write(key: deviceLongitudeKey, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getDeviceLongitude() async {
    return await pref.read(key: deviceLongitudeKey, aOptions: _getAndroidOptions());
  }

  // Registration step
  Future<void> setRegistrationStep(int step) async {
    try {
      String? registrationData = await pref.read(key: registrationModalKey, aOptions: _getAndroidOptions());
      Map<String, dynamic> registrationModal = registrationData != null
          ? jsonDecode(registrationData) as Map<String, dynamic>
          : {};
      registrationModal['registration_step'] = step;
      await pref.write(
        key: registrationModalKey,
        value: jsonEncode(registrationModal),
        aOptions: _getAndroidOptions(),
      );
      ServexUtils.logPrint('Registration step saved: $step');
    } catch (e) {
      ServexUtils.logPrint('Error saving registration step: $e');
    }
  }

  Future<int> getRegistrationStep() async {
    try {
      String? registrationData = await pref.read(key: registrationModalKey, aOptions: _getAndroidOptions());
      if (registrationData == null) return 0;
      final jsonData = jsonDecode(registrationData);
      if (jsonData is Map<String, dynamic> &&
          jsonData['registration_step'] is int) {
        ServexUtils.logPrint(
          'Registration step loaded: ${jsonData['registration_step']}',
        );
        return jsonData['registration_step'] as int;
      }
      ServexUtils.logPrint('Invalid registration step format: $jsonData');
      return 0;
    } catch (e) {
      ServexUtils.logPrint('Error loading registration step: $e');
      return 0;
    }
  }

  // Additional methods from the second LocalStorage class

  // Vendor registration status
  Future<void> setRegistrationStatus(int val) async {
    await pref.write(
        key: registrationStatus,
        value: val.toString(),
        aOptions: _getAndroidOptions());
  }

  Future<int> getRegistrationStatus() async {
    return int.parse(await pref.read(
            key: registrationStatus, aOptions: _getAndroidOptions()) ?? '0');
  }

  // Vendor subscription status


  // Vendor name
  Future<void> setVendorName(String val) async {
    await pref.write(key: VendorName, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getVendorName() async {
    return await pref.read(key: VendorName, aOptions: _getAndroidOptions());
  }


  // Vendor image
  Future<void> setVendorImage(String val) async {
    await pref.write(key: VendorImg, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getVendorImage() async {
    return await pref.read(key: VendorImg, aOptions: _getAndroidOptions());
  }

  // Vendor country
  Future<void> setVendorCountry(String val) async {
    await pref.write(
        key: VendorCountry, value: val, aOptions: _getAndroidOptions());
  }

  Future<String?> getVendorCountry() async {
    return await pref.read(key: VendorCountry, aOptions: _getAndroidOptions());
  }


  // Vendor onboarded
  
 


  



  // Cached recent searches
  Future<void> addToCachedRecentSearches(String val) async {
    List<String> cachedSearches = await getCachedRecentSearches();
    if (cachedSearches.isEmpty) {
      cachedSearches.add(val);
    } else {
      cachedSearches.insert(0, val);
      if (cachedSearches.length > 3) {
        cachedSearches = cachedSearches.sublist(0, 3);
      }
    }
    await pref.write(
        key: cachedRecentSearches,
        value: json.encode(cachedSearches),
        aOptions: _getAndroidOptions());
  }

  Future<List<String>> getCachedRecentSearches() async {
    List cached = json.decode(await pref.read(
            key: cachedRecentSearches, aOptions: _getAndroidOptions()) ?? '[]');
    return List<String>.from(cached);
  }

  Future<void> removeCachedRecentSearchesAt(int index) async {
    List<String> cachedSearches = await getCachedRecentSearches();
    if (index >= 0 && index < cachedSearches.length) {
      cachedSearches.removeAt(index);
      await pref.write(
          key: cachedRecentSearches,
          value: json.encode(cachedSearches),
          aOptions: _getAndroidOptions());
    }
  }

  // Profile, work, and education
  Future<void> saveDataToLocal(String key, String data) async {
    await pref.write(key: key, value: data, aOptions: _getAndroidOptions());
  }

  Future<Map> getMapDataFromLocal(String key) async {
    String data = await pref.read(key: key, aOptions: _getAndroidOptions()) ?? "{}";
    return json.decode(data);
  }

  Future<List> getListDataFromLocal(String key) async {
    String data = await pref.read(key: key, aOptions: _getAndroidOptions()) ?? "[]";
    return json.decode(data);
  }
}