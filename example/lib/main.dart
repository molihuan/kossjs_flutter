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
  late String version;
  int? inst;
  TextEditingController codeController = TextEditingController(
    text:
        """
(async function() {
    var r = await fetch('https://example.com', '{}');
    var text = await r.text()
    console.log(text)
    return 'status=' + r.status + ', ok=' + r.ok;
})()
  """
            .trim(),
  );

  String tips = "";

  void updateTips(String tips) {
    setState(() {
      this.tips = tips;
    });
  }

  void destroyKossjs() {
    if (inst != null) {
      kossjs_flutter.destroy(inst!);
      print("销毁kossJs instance :${inst}");
    }
  }

  int? createKossjs() {
    try {
      destroyKossjs();
      int inst = kossjs_flutter.create();
      print("kossJs instance pointer :${inst}");
      updateTips("koss_create success");
      return inst;
    } catch (e) {
      updateTips("$e");
    }
    return null;
  }

  void _runCode(int? inst, String code) async {
    if (inst == null) {
      updateTips("请先执行koss_create");
      return;
    }
    updateTips("执行中,请稍后...");
    try {
      String result = await kossjs_flutter.runAsync(inst, code, timeout: 5000);
      print("result: ${result}");
      updateTips("result: ${result}");
    } catch (e) {
      updateTips("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    version = kossjs_flutter.version();
    print("version: $version");
  }

  @override
  void dispose() {
    destroyKossjs();
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
                      inst = createKossjs();
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
                    onPressed: () async {
                      _runCode(inst, codeController.text);
                    },
                    child: const Text("koss_eval"),
                  ),
                  spacerSmall,
                  Text("提示:${tips}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
