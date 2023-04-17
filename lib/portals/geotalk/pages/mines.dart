import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/core_lib/_page_context.dart';
import 'package:geochat_app/common/ballistic_layout.dart';

class MinesPage extends StatefulWidget {
  final PageContext context;

  const MinesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<MinesPage> createState() => _MinesPageState();
}

class _MinesPageState extends State<MinesPage>
    with AutomaticKeepAliveClientMixin {
  double _opacity = 0.0;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BallisticSliverLayoutWidget(
      parentContext: context,
      opacityListener: OpacityListener(
        opacityEvent: (opacity) {
          if (mounted) {
            setState(() {
              _opacity = opacity;
              print('******${_opacity}');
            });
          }
        },
        scrollHeight: 150,
        startEdgeSize: 100,
        endEdgeSize: 0,
        beginIsOpacity: _opacity == 0 ? true : false,
      ),
      appBar: SliverAppBar(
        pinned: true,
        floating: true,
        elevation: 0,
        title: Opacity(
          opacity: _opacity,
          child: Text(
            '大道至简',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: _opacity > 0.3
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.transparent,
      ),
      display: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'lib/system/images/avatar2.jpg',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '大道至简',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '地微号：+86@138-8328-3228',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '微信  ',
                            children: [
                              TextSpan(
                                text: '已绑定',
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: '支付宝  ',
                            children: [
                              TextSpan(
                                text: '已绑定',
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                _renderPanel(
                  items: [
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe61c,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFb41703),
                        size: 24,
                      ),
                      title: Text(
                        '服务',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _renderPanel(
                  items: [
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe647,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFb36644),
                        size: 24,
                      ),
                      title: Text(
                        '收付款',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 50,
                    ),
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe649,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF515151),
                        size: 24,
                      ),
                      title: Text(
                        '钱包',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 50,
                    ),
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe6c2,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF11b01e),
                        size: 24,
                      ),
                      title: Text(
                        '券包',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 50,
                    ),
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe736,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF3d4ca1),
                        size: 24,
                      ),
                      title: Text(
                        '账单',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _renderPanel(
                  items: [
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe8b9,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF515151),
                        size: 24,
                      ),
                      title: Text(
                        '收藏',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 50,
                    ),
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xe659,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFd28b23),
                        size: 24,
                      ),
                      title: Text(
                        '表情',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 50,
                    ),
                    _renderItem(
                      image: Icon(
                        IconData(
                          0xee33,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFc94586),
                        size: 24,
                      ),
                      title: Text(
                        '地微风格',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _renderPanel(
                  items: [
                    _renderItem(
                      image: Icon(
                        Icons.settings,
                        size: 24,
                        color: Colors.grey,
                      ),
                      title: Text(
                        '设置',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 76,
          ),
        ],
      ),
    );
  }

  Widget _renderPanel({required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFefefef),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _renderItem({required Widget image, required Widget title}) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 10,
        right: 10,
      ),
      child: Row(
        children: [
          image,
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: title,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFc3c3c4),
          ),
        ],
      ),
    );
  }
}
