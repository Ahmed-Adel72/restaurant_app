import 'package:restaurant_app/core/network/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartLocalDataSource {
  Future<String?> getGuestId();
  Future<void> saveGuestId(String guestId);
  Future<void> clearGuestId();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<String?> getGuestId() async {
    return sharedPreferences.getString(ApiConstants.guestIdKey);
  }

  @override
  Future<void> saveGuestId(String guestId) async {
    await sharedPreferences.setString(ApiConstants.guestIdKey, guestId);
  }

  @override
  Future<void> clearGuestId() async {
    await sharedPreferences.remove(ApiConstants.guestIdKey);
  }
}
