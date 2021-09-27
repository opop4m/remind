import 'package:client/tools/utils.dart';
import 'package:flutter/material.dart';

import 'package:client/tools/library.dart';

class ImageView extends StatelessWidget {
  final String img;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isRadius;

  ImageView({
    required this.img,
    this.height,
    required this.width,
    this.fit,
    this.isRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetWorkImg(img)) {
      image = new CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        fit: fit,
        cacheManager: cacheManager,
      );
    } else if (isAssetsImg(img)) {
      image = new Image.asset(
        img,
        width: width,
        height: height,
        fit: width != null && height != null ? BoxFit.fill : fit,
      );
    } else if (!PlatformUtils.isWeb && File(img).existsSync()) {
      image = new Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      image = new Container(
        decoration: BoxDecoration(
            color: Colors.black26.withOpacity(0.1),
            border:
                Border.all(color: Colors.black.withOpacity(0.2), width: 0.3)),
        child: new Image.asset(
          defIcon,
          width: width == null ? null : (width! - 1),
          height: height != null ? height! - 1 : 0,
          fit: width != null && height != null ? BoxFit.fill : fit,
        ),
      );
    }
    if (isRadius) {
      return new ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        child: image,
      );
    }
    return image;
  }
}

Widget getImageWidget(String img,
    {double? width, double? height, BoxFit? fit}) {
  Widget image;
  if (isNetWorkImg(img)) {
    image = new CachedNetworkImage(
      imageUrl: img,
      width: width,
      height: height,
      fit: fit,
      cacheManager: cacheManager,
    );
  } else if (isAssetsImg(img)) {
    image = new Image.asset(
      img,
      width: width,
      height: height,
      fit: width != null && height != null ? BoxFit.fill : fit,
    );
  } else {
    // } else if (!PlatformUtils.isWeb && File(img).existsSync()) {
    image = new Image.file(
      File(img),
      width: width,
      height: height,
      fit: fit,
    );
  }

  return image;
}
