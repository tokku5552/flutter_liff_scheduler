import 'package:flutter/material.dart';
import 'package:flutter_liff_scheduler/main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:duration_picker/duration_picker.dart';
import 'AffairsStore.dart';

class PageAffair extends StatefulWidget {
  PageAffair(int this.idx, {super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  int idx;
  final String title;

  @override
  State<PageAffair> createState() => _PageAffairState(idx);
}

class _PageAffairState extends State<PageAffair> {
  _PageAffairState(int this.idx);
  late DateTime localTime;
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  int idx;
  late Affair editAffair;

  @override
  initState() {
    if (idx == -1) {
      editAffair = Affair("", DateTime.now(), Duration.zero, "", "");
    } else {
      editAffair = AffairsStore().get(idx);
    }
    localTime = editAffair.time.toLocal();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("表題: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: TextField(
                    controller: TextEditingController(text: editAffair.title),
                    onChanged: (value) {
                      editAffair.title = value;
                    },
                    decoration: InputDecoration(hintText: 'ここに表題を入力してください'),
                  ),
                ),
              ]),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text("行事日時: ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(DateTime.now().year - 2, 1, 1, 0, 0),
                        maxTime:
                            DateTime(DateTime.now().year + 2, 12, 31, 23, 59),
                        onConfirm: (date) {
                      setState(() {
                        editAffair.time = date;
                        localTime = editAffair.time.toLocal();
                      });
                    }, locale: LocaleType.jp);
                  },
                  child: Text(
                      '${localTime.year}/${localTime.month}/${localTime.day} ${localTime.hour}:${localTime.minute}',
                      style: _contentStyle),
                ),
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("行事時間: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () async {
                      var resultingDuration = await showDurationPicker(
                        context: context,
                        initialTime: editAffair.period,
                      );
                      if (resultingDuration != null) {
                        setState(() {
                          editAffair.period = resultingDuration;
                        });
                      }
                    },
                    child: Text("${editAffair.period.inMinutes}分間",
                        style: _contentStyle),
                  )
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("簡単な説明:", style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: TextField(
                    controller: TextEditingController(text: editAffair.summary),
                    onChanged: (value) {
                      editAffair.summary = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'ここに簡単な説明を入力してください',
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 5),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("丁寧な説明:", style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: TextField(
                    controller:
                        TextEditingController(text: editAffair.description),
                    onChanged: (value) {
                      editAffair.description = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'ここに丁寧な説明を入力してください',
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: idx == -1 ? Text('追加') : Text('編集'),
                    onPressed: () {
                      setState(() {
                        if (idx == -1) {
                          AffairsStore().add(editAffair);
                        } else {
                          AffairsStore().set(idx, editAffair);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('キャンセル'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
