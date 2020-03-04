import 'dart:convert';
// import 'package:provide/provide.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Provide/allDate.dart';
import 'package:flutter/material.dart';
import './InspectionProcessing.dart';
import './service/service_method.dart';
import './auxiliaryEquipment.dart';

class detail extends StatefulWidget {
  _detailState createState() => new _detailState();
}

class _detailState extends State<detail> {
  var detailList = {};
  //跳转处理页面
  void trunInspectionProcessing() {
    var gdtype = Provider.of<AllDate>(context, listen: false).gdtype;
    if (gdtype == 0) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new InspectionProcessing()));
    } else {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new auxiliaryEquipment()));
    }
  }

  void initState() {
    var detail = Provider.of<AllDate>(context, listen: false).detail;
    var gdtype = Provider.of<AllDate>(context, listen: false).gdtype;
    requestDetail({'id': detail['id'], 'type': gdtype},
        'inspector-infos/get-order-details');
    super.initState();
  }

//请求详情
  void requestDetail(value, url) async {
    await get(value, url).then((val) {
      var data = json.decode(val.toString());
      switch (data['content']['taskType']) {
        case 0:
          {
            data['content']['taskType'] = '巡视任务';
          }
          break;
        case 1:
          {
            data['content']['taskType'] = '检修任务';
          }
          break;
        case 2:
          {
            data['content']['taskType'] = '抢修任务';
          }
          break;
      }
      setState(() {
        detailList = data['content'];
      });
      print(data['content']);
    });
  }

  List<Map> detailTemplate = [
    {'name': '任务发起人', 'prop': 'initiator'},
    {'name': '任务性质', 'prop': 'taskType'},
    {'name': '发起时间', 'prop': 'createTime'},
    {'name': '站点名称', 'prop': 'substationName'},
    {'name': '联系人', 'prop': 'contact'},
    {'name': '任务描述', 'prop': 'description'},
    {'name': '危险点及安全措施', 'prop': 'dangerousMeasure'}
  ];
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('工单详情'),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(0, 101, 105, 1)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: ListView.separated(
              shrinkWrap: true,
              itemCount: detailTemplate.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    //上下左右各添加16像素补白
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("${detailTemplate[index]['name']}：",
                            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                        Text(
                            detailList[detailTemplate[index]['prop']]
                                        .toString() ==
                                    "null"
                                ? '无'
                                : detailList[detailTemplate[index]['prop']]
                                    .toString(),
                            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                      ],
                    ));
                // ListTile(title: Text("${detailTemplate[index]['name']}"));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: Color.fromRGBO(153, 153, 153, 0.63));
              },
            )),
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
                  trunInspectionProcessing();
                },
              ),
            ),
          ],
        ));
  }
}
