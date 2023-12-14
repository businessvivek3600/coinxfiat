import 'package:coinxfiat/constants/constants_index.dart';

import '/main.dart';
import 'package:flutter/material.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ??
          (appStore.isDarkMode ? Colors.white : AppConst.defaultPrimaryColor),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(MyPng.icNoPhoto,
            height: size ?? 24, width: size ?? 24);
      },
    );
  }
}
