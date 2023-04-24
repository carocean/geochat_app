import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/framework.dart';
import 'package:framework/widgets/_ballistic_indicator_ultimate.dart';
import 'package:intl/intl.dart';

import '../../../common/message_session.dart';
import '../../../common/timer_util.dart';

class MessagesPage extends StatefulWidget {
  final PageContext context;

  const MessagesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  ScrollController? _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BallisticIndicatorSingleChildScrollView(
      parentContext: context,
      scrollController: _scrollController,
      headerSettings: HeaderSettings(
          reservePixels: 50,
          expandPixels: MediaQuery.of(context).size.height - 130,
          buildChild: (settings, notify, direction) {
            return _renderExpandPanel();
          }),
      footerSettings: FooterSettings(
          reservePixels: 50.00,
          // onLoad: ()async{
          //
          // },
          buildChild: (settings, notify, direction) {
            return DotFooterView(
              footerSettings: settings,
              scrollDirection: direction,
              footerNotifier: notify,
            );
          }),
      display: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            _rendSearcher(),
            SizedBox(
              height: 10,
            ),
            _rendTopMessageSessionPanel(),
            SizedBox(
              height: 10,
            ),
            _rendBodyMessageSessionPanel(),
          ],
        ),
      ),
      positioneds: const [],
    );
  }

  _rendSearcher() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_sharp,
            size: 18,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            '搜索',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rendTopMessageSessionPanel() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFefefef),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _renderMessageSessionView(
            MessageSession(
              title: '地微运动',
              faceSrc: 'message@0xe63c',
              text:
                  '[107条]开心小店：店庆促销活动广告语 1、迎“新”三步曲 店庆“四”吉祥 2.四周庆,势不可当!! 挡不住的诱惑,你相信吗? 3.四年铸就辉煌、开创百年未来! 4.三年你我,给利回馈! 5.生意兴隆,',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-04-14 12:32:26')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 70,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '惠客多超市南京路店',
              faceSrc: 'lib/portals/geotalk/images/examples/shandong.jpeg',
              text: '[32条]推出新大礼，快来看看。',
              isMute: true,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-04-14 11:22:26')
                  .toLocal(),
            ),
          ),
        ],
      ),
    );
  }

  _rendBodyMessageSessionPanel() {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFefefef),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _renderMessageSessionView(
            MessageSession(
              title: '福田火车站',
              faceSrc: 'lib/portals/geotalk/images/examples/futian.jpg',
              text:
                  '[246条]我坐在章丘车站宽大明亮的候车大厅，准备从这里乘车去高密祭祖，看着来来往往的乘客，坐在候车椅上等候的顾客，人均一部手机自己玩儿自己的，环顾四周都是电子设备，很是方便。',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-04-13 14:22:26')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 70,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '塘头山东老家',
              faceSrc: 'lib/portals/geotalk/images/examples/shandong.jpg',
              text: '[5条]现在人多需排队，可线上排号。',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-04-12 23:22:26')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '静心',
              faceSrc: 'lib/portals/geotalk/images/examples/jingxin2.jpeg',
              text: '[位置]南宁街溜湖公园附近。',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-04-12 14:22:26')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '互联网事业一部',
              faceSrc: 'lib/portals/geotalk/images/examples/hezuo.png',
              text: '[12条]王兴：你来的可是时候啊，又是路上堵车吗？或者是什么原因？',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 14:22:26')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '日美旅游群',
              faceSrc: 'lib/portals/geotalk/images/examples/group1.png',
              text: '[21k]周川鸿：多年后你的儿子开着宾利上大学，暑假练开飞机，你呢，驾牛车！',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '有机大叔（生态）菜志强',
              faceSrc: 'lib/portals/geotalk/images/examples/mevu.jpeg',
              text: '[语音消息]',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '地微支付',
              faceSrc: 'lib/system/images/avatar2.jpg',
              text: '已支付¥12.00',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '2023合作伙伴第二期产品方案最终讨论案',
              faceSrc: 'lib/portals/geotalk/images/examples/hezou2.png',
              text: '[11条]“风东部售贷事业部-张洪峰”撤回了一条消息',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '东方不败',
              faceSrc: 'lib/portals/geotalk/images/examples/dfbb.png',
              text: '比如，入口后逻辑系统的列表界面，然后进去各个逻辑系统后的首页界面。',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '@你我他',
              faceSrc: 'lib/system/images/avatar2.jpg',
              text: '刘相阳：当地时间21日，日本首相岸田文雄抵达乌克兰首都基辅，会见乌克兰总统泽连司机，并举行了',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
          SizedBox(
            child: Divider(
              height: 1,
              indent: 75,
            ),
          ),
          _renderMessageSessionView(
            MessageSession(
              title: '服务通知',
              faceSrc: 'message@0xe8aa',
              text: '[WPS]上线新功能，申请试用有奖励！',
              isMute: false,
              time: DateFormat('yyyy-MM-dd HH:mm:ss')
                  .parse('2023-01-08 4:54:27')
                  .toLocal(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderMessageSessionView(MessageSession messageSession) {
    var src = messageSession.faceSrc;
    dynamic face;
    if (src.startsWith('message@0x')) {
      src = src.substring('message@'.length);
      int color = int.parse(src);
      face = Icon(
        IconData(color, fontFamily: 'message'),
        size: 40,
        color: Colors.green,
      );
    } else {
      face = Image.asset(
        messageSession.faceSrc,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    }
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
        top: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: face,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        messageSession.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      timeUtils(
                          startTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(messageSession.time)),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        messageSession.text,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(
                          height: 1.20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    messageSession.isMute
                        ? Icon(
                            Icons.volume_mute_outlined,
                            size: 16,
                            color: Colors.grey[400],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderExpandPanel() {
    return  Column(
      children: [
        Expanded(
          child: _renderExpandContent(),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: (details) {
            _scrollController?.animateTo(
              _scrollController?.position.minScrollExtent??0,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.linear,
            );
          },

          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            constraints: const BoxConstraints.tightFor(width: double.infinity),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10,),
              child: FaIcon(
                FontAwesomeIcons.circleArrowUp,
                color: Color(0xFFcecece),
                size: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  _renderExpandContent() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: TextButton(
        style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.grey),),
        child: Text('测试'),
        onPressed: (){
          print(':::::test');
        },
      ),
    );
  }
}
