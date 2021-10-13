import 'package:flutter/material.dart';

Future<T?> showSimpleBottomOptions<T>(BuildContext ctx, List<String> options,
    {String? cancelText}) {
  List<Widget> list = [];
  options.asMap().forEach((i, op) {
    var btn = Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () => _handleAct(ctx, op), child: Text(op)),
          )
        ],
      ),
    );
    list.add(btn);
    if (i == options.length - 1) return;
    if (options.length > 1) {
      list.add(Divider(
        thickness: 1,
        height: 1,
      ));
    }
  });

  return showModalBottomSheet<T>(
      context: ctx,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // color: Colors.white,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: list,
              ),
            ),
            Container(
              // color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () => _handleAct(context, null),
                            child: Text(cancelText ?? "cancel",
                                style: TextStyle(color: Colors.red))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      });
}

void _handleAct(BuildContext context, String? act) {
  Navigator.of(context).pop(act);
}
