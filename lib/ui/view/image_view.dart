import 'package:client/tools/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.width,
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
        cacheKey: img,
      );
    } else if (isAssetsImg(img)) {
      if (isAssetsSvg(img)) {
        image = SvgPicture.asset(
          img,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
        );
      } else {
        image = new Image.asset(
          img,
          width: width,
          height: height,
          fit: width != null && height != null ? BoxFit.fill : fit,
        );
      }
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

  // static Widget getAvatarWidget(String? avatar, int type) {
  //   double w = 48.0, h = 48.0;
  //   var path =
  //       type == typePerson ? getAvatarUrl(avatar) : getGroupAvatarUrl(avatar);
  //   Widget img;
  //   if (avatar == null) {
  //     img = Image.asset(
  //       path,
  //       height: h,
  //       width: w,
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     img = CachedNetworkImage(
  //       imageUrl: path,
  //       height: h,
  //       width: w,
  //       cacheManager: cacheManager,
  //       fit: BoxFit.cover,
  //     );
  //   }
  //   var c = ClipRRect(
  //     borderRadius: BorderRadius.all(Radius.circular(5)),
  //     child: img,
  //   );
  //   return c;
  // }
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
