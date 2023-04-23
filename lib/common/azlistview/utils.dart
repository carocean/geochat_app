import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import 'models.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'lib/common/azlistview/images/$name.$format';
  }

  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static Widget getListItem(BuildContext context, CityModel model,
      {double susHeight = 40}) {
    return ListTile(
      title: Text(model.name),
      onTap: () {
        Utils.showSnackBar(context, 'onItemClick : ${model.name}');
      },
    );
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        Offstage(
//          offstage: !(model.isShowSuspension == true),
//          child: getSusItem(context, model.getSuspensionTag(),
//              susHeight: susHeight),
//        ),
//        ListTile(
//          title: Text(model.name),
//          onTap: () {
//            LogUtil.e("onItemClick : $model");
//            Utils.showSnackBar(context, 'onItemClick : ${model.name}');
//          },
//        )
//      ],
//    );
  }

  static Widget getWeChatListItem(
      BuildContext context,
      ContactInfo model, {
        double susHeight = 40,
        Color? defHeaderBgColor,
      }) {
    return getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor);
//    return Column(
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        Offstage(
//          offstage: !(model.isShowSuspension == true),
//          child: getSusItem(context, model.getSuspensionTag(),
//              susHeight: susHeight),
//        ),
//        getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor),
//      ],
//    );
  }

  static Widget getWeChatItem(
      BuildContext context,
      ContactInfo model, {
        Color? defHeaderBgColor,
      }) {
    DecorationImage? image;
   // if (model.img != null && model.img.isNotEmpty) {
   //   image = DecorationImage(
   //     image: CachedNetworkImageProvider(model.img),
   //     fit: BoxFit.contain,
   //   );
   // }
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,),
      color: Colors.white,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10,bottom: 10,),child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4.0),
                  color: model.bgColor ?? defHeaderBgColor,
                  image: image,
                ),
                child: model.iconData == null
                    ? null
                    : Icon(
                  model.iconData,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              SizedBox(width: 15,),
              Expanded(child: Text(model.name,style: TextStyle(fontSize: 16),),),
            ],
          ),),
          Divider(height: 1,indent: 45,),
        ],
      ),
    );
    return ListTile(
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0),
          color: model.bgColor ?? defHeaderBgColor,
          image: image,
        ),
        child: model.iconData == null
            ? null
            : Icon(
          model.iconData,
          color: Colors.white,
          size: 16,
        ),
      ),
      title: Text(model.name,style: TextStyle(fontSize: 16),),
      onTap: () {
        Utils.showSnackBar(context, 'onItemClick : ${model.name}');
      },
    );
  }
}