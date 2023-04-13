import 'package:framework/core_lib/_scene.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '_ultimate.dart';

mixin ISharedPreferences {
  Future<ISharedPreferences> init(IServiceProvider site);

  Future<bool> setStringList(String key, List<String> value,
      {required String scene,required String person});

  Future<bool> setInt(String key, int value, {required String scene,required  String person});

  Future<bool> setDouble(String key, double value,
      {required String scene,required  String person});

  Future<bool> setBool(String key, bool value, {required String scene,required  String person});

  Future<bool> setString(String key, String value,
      {required String scene,required  String person});

  bool? containsKey(String key, {required String scene,required  String person});

  String? getString(String key, {required String scene,required  String person});

  dynamic get(String key, {required String scene, required String person});

  Future<bool> remove(String key, {required String scene,required  String person});

  Future<bool> clear();

  @override
  String toString();

  Future<void> reload();

  Set<String>? getKeys({required String scene,required  String person});
}

class DefaultSharedPreferences implements ISharedPreferences {
  late SharedPreferences _sharedPreferences;

  @override
  Future<ISharedPreferences> init(IServiceProvider site) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  String _getStoreKey(String? key, {required String scene, required String person}) {
   String key0='/';
   if(!StringUtil.isEmpty(scene)) {
     key0='$key0/$scene';
   }
   if(!StringUtil.isEmpty(person)) {
     key0='$key0/$person';
   }
   if(key0.endsWith('/')) {
     key0='$key0$key';
   }else{
     key0='$key0/$key';
   }
    return key0;
  }

  @override
  Future<bool> setStringList(String key, List<String> value,
      {required String scene, required String person}) {
    return _sharedPreferences.setStringList(
        _getStoreKey(key, scene: scene,person: person), value);
  }

  @override
  Future<bool> setInt(String key, int value, {required String scene,required  String person}) {
    return _sharedPreferences.setInt(_getStoreKey(key, scene: scene,person: person), value);
  }

  @override
  Future<bool> setDouble(String key, double value,
      {required String scene,required  String person}) {
    return _sharedPreferences.setDouble(_getStoreKey(key, scene: scene,person: person), value);
  }

  @override
  Future<bool> setBool(String key, bool value, {required String scene, required String person}) {
    return _sharedPreferences.setBool(_getStoreKey(key, scene: scene,person: person), value);
  }

  @override
  Future<bool> setString(String key, String value,
      {required String scene,required  String person}) {
    return _sharedPreferences.setString(_getStoreKey(key, scene: scene,person: person), value);
  }

  List<String>? getStringList(String key, {required String scene,required  String person}) {
    return _sharedPreferences.getStringList(_getStoreKey(key, scene: scene,person: person));
  }

  int? getInt(String key, {required String scene,required  String person}) {
    return _sharedPreferences.getInt(_getStoreKey(key, scene: scene,person: person));
  }

  double? getDouble(String key, {required String scene,required  String person}) {
    return _sharedPreferences.getDouble(_getStoreKey(key, scene: scene,person: person));
  }

  bool? getBool(String key, {required String scene, required String person}) {
    return _sharedPreferences.getBool(_getStoreKey(key, scene: scene,person: person));
  }

  @override
  bool containsKey(String key, {required String scene,required  String person}) {
    return _sharedPreferences.containsKey(_getStoreKey(key, scene: scene,person: person));
  }

  @override
  String? getString(String key, {required String scene,required  String person}) {
    return _sharedPreferences.getString(_getStoreKey(key, scene: scene,person: person));
  }

  @override
  dynamic get(String key, {required String scene,required  String person}) {
    _sharedPreferences.get(_getStoreKey(key, scene: scene,person: person));
  }

  @override
  Future<bool> remove(String key, {required String scene, required String person}) {
    return _sharedPreferences.remove(_getStoreKey(key, scene: scene,person: person));
  }

  @override
  Future<bool> clear() {
    return _sharedPreferences.clear();
  }

  @override
  String toString() {
    return _sharedPreferences.toString();
  }

  @override
  Future<void> reload() {
    return _sharedPreferences.reload();
  }

  @override
  Set<String> getKeys({required String scene, required String person}) {
    String prefix = _getStoreKey(null, scene: scene,person: person);
    Set<String> keys = _sharedPreferences.getKeys();
    Set<String> set = {};
    for (String k in keys) {
      if (k.startsWith(prefix)) {
        set.add(k);
      }
    }
    return set;
  }
}
