import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);
