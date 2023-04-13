mixin IPrincipal {
  //指userId
  String get openId;

//指登录账号
  String get openCode;

  String get nickName;

  String get realName;

  String get avatar;

  String get introduce;

  int get status;
}
mixin ILocalPrincipalVisitor {
  //在IPrincipalService的构造中初始化
  IPrincipal get(String person);

  String current();
}
mixin ILocalPrincipal implements ILocalPrincipalVisitor {
  void setVisitor(ILocalPrincipalVisitor visitor);
}

class DefaultPrincipal implements IPrincipal{
  @override
  // TODO: implement avatar
  String get avatar => '/sss/sss/1.jpg';

  @override
  // TODO: implement introduce
  String get introduce => '你说啥好呢';

  @override
  // TODO: implement nickName
  String get nickName => 'andrew joes';

  @override
  // TODO: implement openCode
  String get openCode => throw UnimplementedError();

  @override
  // TODO: implement openId
  String get openId => '829iu23989283';

  @override
  // TODO: implement realName
  String get realName => '赵向彬';

  @override
  // TODO: implement status
  int get status => 1;

}
