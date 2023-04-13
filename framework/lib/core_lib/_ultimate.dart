
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

typedef BuildServices = Future<Map<String, dynamic>> Function(
    IServiceProvider site);

mixin IServiceProvider {
  getService(String name);
}

mixin IServiceBuilder {
  Future<void> builder(IServiceProvider site);
}

mixin IDisposable {
  void dispose();
}

mixin StringUtil {
  static bool isEmpty(String? qs) {
    return qs?.isEmpty??true;
  }
}

String getPath(String url) {
  var path = '';
  int pos = url.indexOf("?");
  if (pos < 0) {
    path = url;
  } else {
    path = url.substring(0, pos);
  }
  while (path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  return path;
}

String fileExt(String path) {
  String remain = path;
  int pos = remain.indexOf("?");
  if (pos > -1) {
    remain = remain.substring(0, pos);
  }
  pos = remain.lastIndexOf('/');
  if (pos > -1) {
    remain = remain.substring(pos + 1);
  }
  pos = remain.lastIndexOf('.');
  if (pos < 0) {
    return '';
  }
  return remain.substring(pos + 1);
}


mixin MD5Util {
  static String MD5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
}