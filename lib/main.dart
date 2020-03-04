import 'package:flutter/material.dart';
// import 'package:provide/provide.dart';
import 'package:provider/provider.dart';
import 'Provide/allDate.dart';
import './service/service_method.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import './Home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './commonDart/Toast.dart';

// void main() => runApp(MyApp());
void main() {
  // var allDate2 = AllDate();
  // var providers = Providers();
  // providers..provide(Provider<AllDate>.value(allDate 2));
  // runApp(ProviderNode(child: MyApp(), providers: providers));
  runApp(MyApp());
  // runApp(ChangeNotifierProvider(
  //   builder: (context) => AllDate(),
  //   child: MyApp(),
  // ));
  // runApp(ChangeNotifierProvider<AllDate>.value(
  //   //1
  //   // notifier: Counter(1),//2
  //   child: MyApp(),
  // ));
}

String generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  // 这里其实就是 digest.toString()
  return hex.encode(digest.bytes);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AllDate>(
        builder: (_) => AllDate(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
          localizationsDelegates: [
            //此处
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            //此处
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void login() {
    dl({'username': username.text, 'password': generateMd5(password.text)})
        .then((val) {
      print(val);
      var fhz = json.decode(val.toString());
      if (fhz['code'] == 200) {
        Provider.of<AllDate>(context).changeId(fhz['content']['id']);
        Toast.toast(context, msg: "登录成功", position: ToastPostion.center);
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => new Home()));
      }
    });
  }

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(

        //   title: Text(widget.title),
        // ),
        primary: false,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(alignment: Alignment.center,
                  // fit: StackFit.expand, //未定位widget占满Stack整个空间
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Image(
                              image: AssetImage("images/longin_bg.png"),
                              width: 100.0))
                    ]),
                    Positioned(
                      top: 98.0,
                      child: Text("配电巡检",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          )),
                    ),
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 68.0),
                      child: Container(
                        width: 328.0,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                // autofocus: true,
                                controller: username,
                                decoration: InputDecoration(
                                    // labelText: "用户名",
                                    hintText: "请输入账号",
                                    prefixIcon: Icon(Icons.person)),
                              ),
                              TextField(
                                controller: password,
                                decoration: InputDecoration(
                                    // labelText: "密码",
                                    hintText: "请输入密码",
                                    prefixIcon: Icon(Icons.lock)),
                                obscureText: true,
                              ),
                              Container(
                                  width: 328.0,
                                  decoration: new BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(0, 101, 105, 1),
                                      Color.fromRGBO(9, 153, 159, 1),
                                    ]),
                                  ),
                                  margin: EdgeInsets.only(top: 20.0), //容器外填
                                  child: MaterialButton(
                                    // color: Color.fromRGBO(0, 128, 0, 0.64),
                                    textColor: Colors.white,
                                    child: new Text('登录'),
                                    onPressed: login,
                                  ))
                            ]),
                      ),
                    ),
                  ])
            ],
          ),
        ));
  }
}
