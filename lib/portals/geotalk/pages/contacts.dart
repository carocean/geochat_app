import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/widgets/azlistview/models.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../../widgets/azlistview/utils.dart';


class ContactsPage extends StatefulWidget {
  final PageContext context;

  const ContactsPage({Key? key, required this.context}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  List<ContactInfo> contactList = [];
  List<ContactInfo> topList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    topList.add(ContactInfo(
        name: '新的朋友',
        tagIndex: '↑',
        bgColor: Colors.orange,
        iconData: Icons.person_add));
    topList.add(ContactInfo(
        name: '群聊',
        tagIndex: '↑',
        bgColor: Colors.green,
        iconData: Icons.people));
    topList.add(ContactInfo(
        name: '广播',
        tagIndex: '↑',
        bgColor: Colors.teal,
        iconData: FontAwesomeIcons.towerBroadcast));
    topList.add(ContactInfo(
        name: '现实',
        tagIndex: '↑',
        bgColor: Colors.green,
        iconData: FontAwesomeIcons.streetView));
    topList.add(ContactInfo(
        name: '标签',
        tagIndex: '↑',
        bgColor: Colors.blue,
        iconData: Icons.local_offer));
    loadData();
  }
  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('lib/widgets/azlistview/data/car_models.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        contactList.add(ContactInfo.fromJson(v));
      });
      _handleList(contactList);
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(contactList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(contactList);

    // add topList.
    contactList.insertAll(0, topList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: contactList,
      itemCount: contactList.length,
      itemBuilder: (BuildContext context, int index) {
        ContactInfo model = contactList[index];
        return Utils.getWeChatListItem(
          context,
          model,
          defHeaderBgColor: Color(0xFFE5E5E5),
        );
      },
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      susItemBuilder: (BuildContext context, int index) {
        ContactInfo model = contactList[index];
        if ('↑' == model.getSuspensionTag()) {
          return Container();
        }
        return Utils.getSusItem(context, model.getSuspensionTag());
      },
      indexBarData: ['↑', '☆', ...kIndexBarData],
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        ignoreDragCancel: true,
        downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
        downItemDecoration:
        BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        indexHintWidth: 120 / 2,
        indexHintHeight: 100 / 2,
        indexHintDecoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Utils.getImgPath('ic_index_bar_bubble_gray')),
            fit: BoxFit.contain,
          ),
        ),
        indexHintAlignment: Alignment.centerRight,
        indexHintChildAlignment: Alignment(-0.25, 0.0),
        indexHintOffset: Offset(-20, 0),
      ),
    );
  }
}
