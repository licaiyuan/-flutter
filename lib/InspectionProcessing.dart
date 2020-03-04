import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Provide/allDate.dart';
import 'package:flutter/material.dart';
import './flutter_datetime_picker.dart';
import './service/service_method.dart';
import './commonDart/Toast.dart';

class InspectionProcessing extends StatefulWidget {
  _InspectionProcessing createState() => new _InspectionProcessing();
}

class _InspectionProcessing extends State<InspectionProcessing> {
  void chooseTime() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        setState(() {
          time = date.toString();
          FeedBackData['executionTime'] = date.toString();
        });
        print(time);
      },
    );
  }

  var FeedBackData = {};
  var textEditingControllers = <TextEditingController>[];

  void initState() {
    var detail = Provider.of<AllDate>(context, listen: false).detail;
    var gdtype = Provider.of<AllDate>(context, listen: false).gdtype;
    if (detail['processeState'] == '0') {
      getFeedBackData({'id': detail['id'], 'type': gdtype},
          'feedback-tables/getFeedBackData');
    } else {
      renderData();
    }
    super.initState();
  }

//渲染数据
  renderData() {
    print('渲染数据开始');
    detailTemplate.forEach((item) {
      FeedBackData[item['prop']] = '';
    });
  }

//获取数据
  Future getFeedBackData(value, url) async {
    print(url);
    await get(value, url).then((val) {
      var data = json.decode(val.toString());
      print(data);
      setState(() {
        FeedBackData = data['content'];
        time = data['content']['executionTime'];
      });
      // detailTemplate.forEach((item) {
      //   var textEditingController;

      //   print(item['prop']);
      //   print(FeedBackData);
      //   print(FeedBackData[item['prop']]);

      //   textEditingController =
      //       new TextEditingController(text: data['content'][item['prop']]);

      //   textEditingControllers.add(textEditingController);
      // });

      return FeedBackData;
    });
  }

//处理
  void ticketProcessing(value) async {
    // var detail = Provider.of<AllDate>(context, listen: false).detail;

    print(value);
    Toast.toast(context, msg: "保存成功", position: ToastPostion.center);
    await dealwith(value).then((val) {
      print(val);
    });
  }

  void changeContent(value, prop) {
    FeedBackData[prop] = value;
  }

  List<Map> detailTemplate = [
    {'name': '任务执行人', 'prop': 'inspector', 'hint': '请输入任务执行人姓名'},
    {'name': '执行时间', 'prop': 'executionTime', 'hint': '请选择时间'},
    {'name': '问题反馈', 'prop': 'problemFeedback', 'hint': '请输入问题反馈'},
    {'name': '任务终结及验收', 'prop': 'taskSummaryAcceptance', 'hint': '请输入任务终结及验收'},
    {'name': '任务评价', 'prop': 'taskEvaluation', 'hint': '请输入任务评价'},
  ];

  String time = '请选择时间';
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('工单处理'),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(0, 101, 105, 1)),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0), //容器内补白

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detailTemplate.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (detailTemplate[index]['name'] == '任务执行人') {
                      return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffe5e5e5)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${detailTemplate[index]['name']}:",
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              Expanded(
                                  child: TextField(
                                      // controller: textEditingControllers[index],
                                      onChanged: (text) {
                                        //内容改变的回调
                                        changeContent(text,
                                            detailTemplate[index]['prop']);
                                        print('change $text');
                                      },
                                      controller: new TextEditingController(
                                          text: FeedBackData[
                                              detailTemplate[index]['prop']]),
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(32)),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: detailTemplate[index]['hint'],
                                      ))),
                            ],
                          ));
                    } else if (detailTemplate[index]['name'] == '执行时间') {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${detailTemplate[index]['name']}:",
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setSp(8)),
                                      child: GestureDetector(
                                          onTap: () {
                                            chooseTime();
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(32),
                                                  ),
                                                ),
                                                Image(
                                                    image: AssetImage(
                                                        "images/turndown.png"),
                                                    width: ScreenUtil()
                                                        .setWidth(40))
                                              ]))))
                            ],
                          ));
                    } else
                      return Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${detailTemplate[index]['name']}:",
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              TextField(
                                  // controller: textEditingControllers[index],
                                  onChanged: (text) {
                                    //内容改变的回调
                                    changeContent(
                                        text, detailTemplate[index]['prop']);
                                    print('change $text');
                                  },
                                  controller: new TextEditingController(
                                      text: FeedBackData[detailTemplate[index]
                                          ['prop']]),
                                  maxLength: 500,
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(32)),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5),
                                    border: InputBorder.none,
                                    hintText: detailTemplate[index]['hint'],
                                    enabledBorder: OutlineInputBorder(
                                      /*边角*/
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10), //边角为30
                                      ),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(
                                            153, 153, 153, 0.63), //边线颜色为黄色
                                        width: 1, //边线宽度为2
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Color.fromRGBO(
                                          153, 153, 153, 0.63), //边框颜色为绿色
                                      width: 1, //宽度为5
                                    )),
                                  )),
                            ],
                          ));
                    // ListTile(title: Text("${detailTemplate[index]['name']}"));
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setSp(28)), //容器外补白
                  width: ScreenUtil().setWidth(600),
                  height: ScreenUtil().setHeight(100),
                  child: RaisedButton(
                    color: Color.fromRGBO(0, 101, 105, 1),
                    highlightColor: Colors.blue[700],
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text(
                      "处理",
                      style: TextStyle(fontSize: ScreenUtil().setSp(38)),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      ticketProcessing(FeedBackData);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
