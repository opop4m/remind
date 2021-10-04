import 'package:client/tools/library.dart';
import 'package:client/ui/view/edit_view.dart';
import 'package:flutter/material.dart';

OverlayEntry showInputDialog(
  BuildContext context,
  String label,
  String hint, {
  Key? key,
  String? btnTextA,
  String? btnTextB,
  Callback? cb,
}) {
  var inputDialog = InputDialog(
    label,
    hint,
    key: key,
    btnTextA: btnTextA,
    btnTextB: btnTextB,
    cb: cb,
  );
  OverlayEntry overlayEntry = new OverlayEntry(builder: (content) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - 80,
      left: MediaQuery.of(context).size.width * 0.1,
      child: inputDialog,
    );
  });
  Overlay.of(context)!.insert(overlayEntry);

  return overlayEntry;
}

class InputDialog extends StatelessWidget {
  TextEditingController textC = TextEditingController();
  FocusNode focusNode = FocusNode();

  String label;
  String hint;
  String? btnTextA, btnTextB; //confirm
  Callback? cb;
  InputDialog(
    this.label,
    this.hint, {
    Key? key,
    this.btnTextA,
    this.btnTextB,
    this.cb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: winWidth(context) * 0.8,
          // height: 160,
          // padding: EdgeInsets.only(top: 20),
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey[300]!,
                )
              ]),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 18)),
                    TextField(
                      style: TextStyle(textBaseline: TextBaseline.alphabetic),
                      controller: textC,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          hintText: hint, border: InputBorder.none),
                    ),
                  ],
                ),
              ),
              Divider(height: 10, thickness: 1, color: Colors.grey[300]),
              Container(
                alignment: Alignment(0, 0),
                padding: EdgeInsets.only(top: 5, bottom: 20),
                child: TextButton(
                  onPressed: () => cb?.call(1),
                  child: Text(btnTextA ?? "confirm"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
