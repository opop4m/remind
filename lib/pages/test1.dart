import 'package:client/provider/service/im.dart';
import 'package:client/tools/library.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _test createState() => _test();
}

class _test extends State<Test> {
  TextEditingController inputC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: inputC,
          onChanged: (String text) {},
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Enter your uid'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => event("test"),
              child: Text("test"),
            ),
          ],
        )
      ],
    );
  }

  void event(String act) {
    switch (act) {
      case "test":
        Im.get().requestSystem(API.actChatUser, {
          "uids": [inputC.text]
        });
        break;
    }
  }
}
