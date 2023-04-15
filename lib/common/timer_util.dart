import 'package:intl/intl.dart';

///时间数据格式转换
/// 1、当天的消息，一小时以内，显示分钟；                             格式 1  30分钟前（如果小于1分钟，显示刚刚）
/// 2、当天的消息，超出一小时，显示上午或下午 + 收发消息的时间；         格式 2  下午 13:54
/// 3、消息超过一天，小于两天，昨天 + 显示上午或下午 + 收发消息的时间；   格式 3  昨天 下午17:54
/// 4、消息超过一天，小于一周，周x + 显示上午或下午 + 收发消息的时间；    格式 4  周日 下午17:54    不建议使用
/// 5、超过一年，年月日 + 显示上午或下午 + 收发消息的时间；             格式 5  2020年06月01日 下午17:54
/// 6、其他样式：月日 + 显示上午或下午 + 收发消息的时间；               格式 6  6月01日 下午17:54
///
/// 使用：
/// 例：String _time = GlobalVariable.timeUtils(startTime: "2020-09-25 10:18:17")

String timeUtils({required String startTime}) {
  if (startTime != null && startTime.runtimeType != Null && startTime != "") {
    ///字符串类型转换成时间戳
    int _maturityTim = DateTime.parse(startTime).millisecondsSinceEpoch;

    ///创建时间戳 转换为 DateTime对象
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(_maturityTim);

    ///超出一年
    if (_dateTime.year != DateTime.now().year) {
      String _r = DateFormat('yyyy年MM月dd日').format(_dateTime);
      if (_dateTime.hour < 12) {
        return "$_r ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      } else {
        return "$_r ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      }
    } else {
      ///间隔时间 = 当前时间 - 创建时间   单位：分钟
      int _m = DateTime.now().difference(_dateTime).inMinutes.abs();

      ///一小时以内
      if (_m < 60) {
        return "${_m}分前";
      } else if (_m < 1) {
        return "刚刚";
      }
      String inputStr = DateFormat('yyyyMMdd')
          .format(new DateTime.fromMillisecondsSinceEpoch(_maturityTim));
      String todayStr = DateFormat('yyyyMMdd').format(DateTime.now());

      ///当天
      if (inputStr == todayStr) {
        ///12点之前 上午
        if (_dateTime.hour < 12) {
          return "${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

          ///12点之后 下午
        } else {
          return "${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }

      ///前一天
      if ((DateTime.now().day - _dateTime.day) == 1) {
        if (_dateTime.hour < 12) {
          return "昨天 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        } else {
          return "昨天 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }

      ///前两天
      if ((DateTime.now().day - _dateTime.day) == 2) {
        if (_dateTime.hour < 12) {
          return "前天 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        } else {
          return "前天 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
        }
      }
      ///一周以内 不建议用 时间信息不够明确
//        if ((DateTime.now().day - _dateTime.day) <= 7) {
//          String _x = DateUtil.getWeekday(
//              DateTime.fromMillisecondsSinceEpoch(
//                  _dateTime.millisecondsSinceEpoch),
//              languageCode: "zh");
//
//          if (_dateTime.hour < 12) {
//            return "$_x 上午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
//          } else {
//            return "$_x 下午${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
//          }
//        }

      ///其他样式 6月01日 下午17:54
      ///12点之前 上午
      if (_dateTime.hour < 12) {
        return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";

        ///12点之后 下午
      } else {
        return "${_dateTime.month}月${numberUtils(_dateTime.day)}日 ${numberUtils(_dateTime.hour)}:${numberUtils(_dateTime.minute)}";
      }
    }
  }
  return "";
}

///时间值转换
///2:1  => 02 : 01
String numberUtils(int number) {
  if (number < 10) {
    return "0${number.toString()}";
  }
  return number.toString();
}
