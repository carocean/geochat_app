import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class DiscoveriesPage extends StatefulWidget {
  final PageContext context;

  const DiscoveriesPage({Key? key, required this.context}) : super(key: key);

  @override
  State<DiscoveriesPage> createState() => _DiscoveriesPageState();
}

class _DiscoveriesPageState extends State<DiscoveriesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return BallisticSingleChildScrollView(
      parentContext: context,
      appBarHeight: 80+34,
      navBarHeight: 50,
      display: Padding(
        padding: EdgeInsets.only(left: 5,right: 5),
        child: Column(
          children: [
            SimpleCardView(
              items: [
                SimpleCardViewItem(
                  title: '扫一扫',
                  icon: const Icon(
                    IconData(
                      0xe8b5,
                      fontFamily: 'discoveries',
                    ),
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
                  title: '街市',
                  icon: const Icon(
                    IconData(
                      0xe623,
                      fontFamily: 'discoveries',
                    ),
                    size: 24,
                    color: Colors.green,
                  ),
                ),
                SimpleCardViewItem(
                  title: '说说',
                  icon: const Icon(
                    IconData(
                      0xe648,
                      fontFamily: 'discoveries',
                    ),
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
                SimpleCardViewItem(
                  title: '话题',
                  icon: const Icon(
                    IconData(
                      0xe665,
                      fontFamily: 'discoveries',
                    ),
                    color: Colors.deepOrangeAccent,
                    size: 24,
                  ),
                ),
                SimpleCardViewItem(
                  title: '投稿',
                  icon: const Icon(
                    IconData(
                      0xe688,
                      fontFamily: 'discoveries',
                    ),
                    size: 24,
                    color: Colors.indigo,
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
                  title: '小程序',
                  icon: const Icon(
                    IconData(
                      0xe649,
                      fontFamily: 'discoveries',
                    ),
                    size: 24,
                    color: Colors.lightGreen,
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
                  title: '设备账号',
                  icon: Icon(
                    const IconData(
                      0xe652,
                      fontFamily: 'discoveries',
                    ),
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
