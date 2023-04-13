import 'package:framework/core_lib/_portal.dart';
import 'package:framework/core_lib/_ultimate.dart';
import 'package:geochat_app/portals/geophone/geophone.dart';
import 'package:geochat_app/portals/geotalk/geotalk.dart';

///引用函数形式无法使用hot reload即时生效，添加新页后需hot restart，因此改用使用类来定义portal
List<BuildPortal> buildPortals(IServiceProvider site) {
  return <BuildPortal>[
    GeotalkPortal().buildPortal,
    GeophonePortal().buildPortal,
  ];
}
