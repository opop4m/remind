import 'package:client/provider/global_cache.dart';
import 'package:client/provider/service/imDb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/global_model.dart';

class JoinMessage extends StatelessWidget {
  final ChatMsg data;

  JoinMessage(this.data);

  @override
  Widget build(BuildContext context) {
    final globalModel = Provider.of<GlobalModel>(context);

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: new Text(
        data.content!,
        style:
            TextStyle(color: Color.fromRGBO(108, 108, 108, 0.8), fontSize: 11),
      ),
    );
  }
}
