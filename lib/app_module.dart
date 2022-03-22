import 'package:get_it/get_it.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/helpers/shared_preferences_manager.dart';
import 'package:tarot/saved_db/saved_repository.dart';

import 'helpers/notifications_manager.dart';
import 'helpers/subscription_manager.dart';

GetIt getIt = GetIt.instance;

NavigationHelper provideNavHelper() => getIt.get();

SharedPreferencesManager providePrefs() => getIt.get();

NotificationManager provideNotificationManager() => getIt.get();

SavedRepository provideSavedRepository() => getIt.get();

SubscriptionRepository provideSubscriptionRepository() => getIt.get();
