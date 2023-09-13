import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:framework/core_lib/_ultimate.dart';

mixin ILanguage {
  Locale? get current;

  Map<String, String>? get nameMapping;

  void setLanguage(String languageCode, String? countryCode) {}

  void load(Iterable<Locale> supportedLocales) {}
}

class DefaultLanguage implements ILanguage {
  Map<String, Locale>? _locales;
  Map<String, String>? languageNames;
  Locale? _current;

  DefaultLanguage({this.languageNames}) : _locales = <String, Locale>{};

  @override
  Locale? get current {
    return _current ?? WidgetsBinding.instance.platformDispatcher.locales.first;
  }

  @override
  void setLanguage(String languageCode, String? countryCode) {
    var locale = _locales?[languageCode];
    if (!StringUtil.isEmpty(countryCode)) {
      String key = '${languageCode}_${countryCode!}';
      var d = _locales?[key];
      if (d != null) {
        locale = d;
      }
    }
    _current = locale;
  }

  @override
  void load(Iterable<Locale> supportedLocales) {
    _locales?.clear();
    for (var locale in supportedLocales) {
      var kv = locale.languageCode;
      if (!StringUtil.isEmpty(locale.countryCode)) {
        kv += '_${locale.countryCode!}';
      }
      _locales?[kv] = locale;
    }
  }

  @override
  // TODO: implement nameMapping
  Map<String, String>? get nameMapping => languageNames;
}
