import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framework/framework.dart';

List<Style> buildGreyStyles(IServiceProvider site) {
  return <Style>[
    Style(
      url: '/message/test.text',
      get: () {
        return  const TextStyle(
          fontSize: 14,
          color: Colors.amber,
        );
      },
    ),
  ];
}
