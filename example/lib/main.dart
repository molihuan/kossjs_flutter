import 'package:flutter/material.dart';
import 'package:kossjs_flutter/kossjs_flutter.dart' as kossjs_flutter;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late Future<int> sumAsyncResult;
  late String version;
  int? inst;
  TextEditingController codeController = TextEditingController(text: "1 + 2");

  String tips = "";

  void updateTips(String tips) {
    setState(() {
      this.tips = tips;
    });
  }

  @override
  void initState() {
    super.initState();
    // sumAsyncResult = kossjs_flutter.sumAsync(3, 4);
    version = kossjs_flutter.version();
    print("version: $version");
  }

  @override
  void dispose() {
    if (inst != null) {
      kossjs_flutter.destroy(inst!);
      print("销毁kossJs instance :${inst}");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('KossJS版本:${version}')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      try {
                        inst = kossjs_flutter.create();
                        print("kossJs instance pointer :${inst}");
                        updateTips("koss_create success");
                      } catch (e) {
                        updateTips("$e");
                      }
                    },
                    child: const Text("koss_create"),
                  ),
                  spacerSmall,
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 100,
                    minLines: 1,
                  ),
                  spacerSmall,
                  ElevatedButton(
                    onPressed: () {
                      if (inst == null) {
                        updateTips("请先执行koss_create");
                        return;
                      }
                      try {
                        String code = codeController.text;
                        String result = kossjs_flutter.eval(inst!, code);
                        print("result: ${result}");
                        updateTips("result: ${result}");
                      } catch (e) {
                        updateTips("$e");
                      }
                    },
                    child: const Text("koss_eval"),
                  ),
                  spacerSmall,
                  Text("提示:${tips}"),

                  // spacerSmall,
                  // FutureBuilder<int>(
                  //   future: sumAsyncResult,
                  //   builder: (BuildContext context, AsyncSnapshot<int> value) {
                  //     final displayValue = (value.hasData)
                  //         ? value.data
                  //         : 'loading';
                  //     return Text(
                  //       'await sumAsync(3, 4) = $displayValue',
                  //       style: textStyle,
                  //       textAlign: TextAlign.center,
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
