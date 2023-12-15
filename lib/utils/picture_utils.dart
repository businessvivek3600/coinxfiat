import 'package:cached_network_image/cached_network_image.dart';
import '/constants/constants_index.dart';
import 'utils_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

Widget assetSvg(String path,
        {BoxFit? fit,
        bool fullPath = false,
        Color? color,
        double? width,
        double? height}) =>
    SvgPicture.asset(
      fullPath ? path : 'assets/svgs/$path',
      fit: fit ?? BoxFit.contain,
      color: color,
      width: width,
      height: height,
    );
// Widget assetRive(String path, {BoxFit? fit, bool fullPath = false}) =>
//     RiveAnimation.asset(
//       fullPath ? path : 'assets/rive/$path',
//       fit: fit ?? BoxFit.contain,
//     );
LottieBuilder assetLottie(String path,
        {BoxFit? fit,
        bool fullPath = false,
        double? width,
        double? height,
        LottieDelegates? delegates}) =>
    Lottie.asset(
      fullPath ? path : 'assets/lottie/$path',
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
      delegates: delegates,
    );

Image assetImages(String path,
        {BoxFit? fit,
        bool fullPath = false,
        Color? color,
        double? width,
        double? height}) =>
    Image.asset(
      fullPath ? path : 'assets/images/$path',
      fit: fit ?? BoxFit.contain,
      color: color,
      width: width,
      height: height,
    );

ImageProvider assetImageProvider(String path,
        {BoxFit? fit, bool fullPath = false}) =>
    AssetImage(fullPath ? path : 'assets/images/$path');

ImageProvider netImageProvider(String path,
        {BoxFit? fit, Color? color, double? width, double? height}) =>
    NetworkImage(path);

Widget buildCachedNetworkImage(String image,
    {double? h,
    double? w,
    double? borderRadius,
    BoxFit? fit,
    bool fullPath = false,
    String? placeholder}) {
  return LayoutBuilder(builder: (context, bound) {
    w ??= bound.maxWidth;
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit ?? BoxFit.cover,
      imageBuilder: (context, image) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Container(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: image, fit: fit ?? BoxFit.cover))),
      ),
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: h ?? 50,
          width: w ?? 100,
          child: Center(
              child: CircularProgressIndicator(
            color: getTheme(context).textTheme.bodyText1?.color,
          )),
        ),
      ),
      errorWidget: (context, url, error) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: SizedBox(
            height: h ?? 50,
            width: w ?? 100,
            child: Center(child: assetImages(placeholder ?? MyPng.logo))),
      ),
      cacheManager: null,
    );
  });
}

int inKB(int bytes) => (bytes / 1024).round();
int inMB(int bytes) => (bytes / (1024 * 1024)).round();
