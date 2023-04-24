import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

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
    return BallisticCustomScrollView(
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
          child: const Text(
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
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: 70,
                      height: 70,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'lib/system/images/avatar2.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      '大道至简',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '地微号：+86@138-8328-3228',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
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
                const SizedBox(
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
                            children: const [
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
                            children: const [
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
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: Column(
              children: [
                SimpleCardView(
                  items: [
                    SimpleCardViewItem(
                      title: '服务',
                      icon: const Icon(
                        IconData(
                          0xe61c,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFb41703),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SimpleCardView(
                  items: [
                    SimpleCardViewItem(
                      title: '收付款',
                      icon: const Icon(
                        IconData(
                          0xe647,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFb36644),
                        size: 24,
                      ),
                    ),
                    SimpleCardViewItem(
                      title: '钱包',
                      icon: const Icon(
                        IconData(
                          0xe649,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF515151),
                        size: 24,
                      ),
                    ),
                    SimpleCardViewItem(
                      title: '券包',
                      icon: const Icon(
                        IconData(
                          0xe6c2,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF11b01e),
                        size: 24,
                      ),
                    ),
                    SimpleCardViewItem(
                      title: '账单',
                      icon: const Icon(
                        IconData(
                          0xe736,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF3d4ca1),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SimpleCardView(
                  items: [
                    SimpleCardViewItem(
                      title: '收藏',
                      icon: const Icon(
                        IconData(
                          0xe8b9,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFF515151),
                        size: 24,
                      ),
                    ),
                    SimpleCardViewItem(
                      title: '表情',
                      icon: const Icon(
                        IconData(
                          0xe659,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFd28b23),
                        size: 24,
                      ),
                    ),
                    SimpleCardViewItem(
                      title: '地微风格',
                      icon: const Icon(
                        IconData(
                          0xee33,
                          fontFamily: 'mines',
                        ),
                        color: Color(0xFFc94586),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SimpleCardView(
                  items: [
                    SimpleCardViewItem(
                      title: '设置',
                      icon: const Icon(
                        Icons.settings,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 76,
          ),
        ],
      ),
    );
  }

}
