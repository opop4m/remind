import 'package:client/http/api.dart';
import 'package:client/pages/mine/code_page.dart';
import 'package:client/tools/adapter/imagePickerApi.dart';
import 'package:client/tools/library.dart';
import 'package:client/tools/mimeType.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:client/pages/mine/change_name_page.dart';
import 'package:client/provider/global_model.dart';

import 'package:client/ui/orther/label_row.dart';

final _log = Logger("PersonalInfoPage");

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  action(v) {
    if (v == '二维码名片') {
      routePush(new CodePage());
    } else {
      print(v);
    }
  }

  _openGallery({type = ImageSource.gallery}) async {
    var avatarImgBytes = await UcImagePicker.image();
    if (avatarImgBytes == null) {
      _log.info("did not choose any file");
      return;
    }
    var mime = lookupMimeType('', headerBytes: avatarImgBytes.sublist(0, 10));
    if (mime == null) {
      _log.info("unknow file type");
      return;
    }
    var ext = findExtFromMime(mime);
    _log.info("mime type: $mime, ext: $ext");
    var avatarPath = await uploadMediaApi(avatarImgBytes, ext, "avatar");
    if (strNoEmpty(avatarPath)) {
      await _model.logic.updateUser({"avatar": avatarPath});
      if (mounted) setState(() {});
    }
    // final model = Provider.of<GlobalModel>(context, listen: false);
    // var ip = ImagePicker();
    // XFile? imageFile = await ip.pickImage(source: type);
    // if (imageFile == null) return;
    // List<int> imageBytes = await compressFile(File(imageFile.path));
    // if (imageFile != null) {
    //   String base64Img = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';
    //   uploadImgApi(context, base64Img, (v) {
    //     if (v == null) {
    //       showToast(context, '上传头像失败,请换张图像再试');
    //       return;
    //     }

    //     setUsersProfileMethod(
    //       context,
    //       avatarStr: v,
    //       nickNameStr: model.nickName,
    //       callback: (data) {
    //         if (data.toString().contains('ucc')) {
    //           showToast(context, '设置头像成功');
    //           model.avatar = v;
    //           model.refresh();
    //         } else {
    //           showToast(context, '设置头像失败');
    //         }
    //       },
    //     );
    //   });
    // }
  }

  Widget dynamicAvatar(avatar, {size}) {
    if (isNetWorkImg(avatar)) {
      return new CachedNetworkImage(
          imageUrl: avatar,
          cacheManager: cacheManager,
          width: size ?? null,
          height: size ?? null,
          fit: BoxFit.fill);
    } else {
      return new Image.asset(avatar,
          fit: BoxFit.fill, width: size ?? null, height: size ?? null);
    }
  }

  Widget body(GlobalModel model) {
    List data = [
      {'label': '微信号', 'value': Global.get().curUser.account},
      {'label': '二维码名片', 'value': ''},
      {'label': '更多', 'value': ''},
      {'label': '我的地址', 'value': ''},
    ];

    var content = [
      new LabelRow(
        label: '头像',
        isLine: true,
        isRight: true,
        rightW: new SizedBox(
          width: 55.0,
          height: 55.0,
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: strNoEmpty(Global.get().curUser.avatar)
                ? dynamicAvatar(getAvatarUrl(Global.get().curUser.avatar))
                : new Image.asset(defIcon, fit: BoxFit.cover),
          ),
        ),
        onPressed: () => _openGallery(),
      ),
      new LabelRow(
        label: '昵称',
        isLine: true,
        isRight: true,
        rValue: Global.get().curUser.nickName,
        onPressed: () =>
            routePush(new ChangeNamePage(Global.get().curUser.nickName)),
      ),
      new Column(
        children: data.map((item) => buildContent(item, model)).toList(),
      ),
    ];

    return new Column(children: content);
  }

  Widget buildContent(item, GlobalModel model) {
    return new LabelRow(
      label: item['label'],
      rValue: item['value'],
      isLine: item['label'] == '我的地址' || item['label'] == '更多' ? false : true,
      isRight: item['label'] == '微信号' ? false : true,
      margin: EdgeInsets.only(bottom: item['label'] == '更多' ? 10.0 : 0.0),
      rightW: item['label'] == '二维码名片'
          ? new Image.asset('assets/images/mine/ic_small_code.png',
              color: mainTextColor.withOpacity(0.7))
          : new Container(),
      onPressed: () => action(item['label']),
    );
  }

  late GlobalModel _model;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<GlobalModel>(context);

    return new Scaffold(
      backgroundColor: appBarColor,
      appBar: new ComMomBar(title: '个人信息'),
      body: new SingleChildScrollView(child: body(_model)),
    );
  }
}
