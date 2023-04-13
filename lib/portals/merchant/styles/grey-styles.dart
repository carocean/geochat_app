import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

List<Style> buildGreyStyles(IServiceProvider site) {
  return <Style>[
    Style(
      url: '/desktop/test.text',
      get: () {
        return  const TextStyle(
          fontSize: 14,
          color: Colors.amber,
        );
      },
    ),
  ];
}
