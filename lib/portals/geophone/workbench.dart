import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:geochat_app/portals/geophone/pages/desktop.dart';
import 'package:geochat_app/portals/geophone/parts/dock_bar.dart';
import 'package:geochat_app/portals/geophone/parts/nav_bar.dart';
import 'package:geochat_app/portals/geophone/stores/desktop/services/desktop_service.dart';

import 'stores/desktop/i_desktop_service.dart';
import 'stores/desktop/ol/desktop_ol.dart';

class GeophoneWorkbenchPage extends StatefulWidget {
  const GeophoneWorkbenchPage({Key? key}) : super(key: key);

  @override
  State<GeophoneWorkbenchPage> createState() => _GeophoneWorkbenchPageState();
}

class _GeophoneWorkbenchPageState extends State<GeophoneWorkbenchPage> {
  PageController? _pageController;
   List<DeskFolderOL> _folders=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);
    _load();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  _load() async {
    IDesktopService desktopService = DesktopService();
    _folders = await desktopService.listRootFolder();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/portals/geophone/images/wallpaper-glass.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth,
                    maxHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          allowImplicitScrolling: true,
                          controller: _pageController,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          children: _renderFolders(),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          NavBar(controller: _pageController!,count: _folders.length),
                          SizedBox(
                            height: 30,
                          ),
                          DockerBar(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _renderFolders() {
    var desktops = <Widget>[];
    var $=Pageis.of(context)?.$;
    for (var folder in _folders) {
      desktops.add(
        $!.part('/desktop', context,arguments: {
          'desktopNotifier': DesktopNotifier(
            folder: folder,
          ),
        })!,
      );
    }
    return desktops;
  }
}
