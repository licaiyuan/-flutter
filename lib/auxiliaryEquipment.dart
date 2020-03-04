import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Provide/allDate.dart';
import 'package:flutter/material.dart';
import './dataImport/auxiliaryData.dart';
import './service/service_method.dart';
import './commonDart/bottomCl.dart';
import './commonDart/Toast.dart';
import 'dart:ui';

class auxiliaryEquipment extends StatefulWidget {
  final List recommendList;
  auxiliaryEquipment({Key key, this.recommendList}) : super(key: key);
  _auxiliaryEquipment createState() => new _auxiliaryEquipment();
}

class _auxiliaryEquipment extends State<auxiliaryEquipment> {
  var saveData = {};

  Future requestEquipment(value, url) async {
    var val = await get(value, url);
    var detail = Provider.of<AllDate>(context, listen: false).detail;
    var data = json.decode(val.toString());
    List<Map> newGoodsList = (data['content'] as List).cast();

    if (detail['processeState'] != '0') {
      newGoodsList.forEach((item) {
        saveData[item['zd']] = {};
        List<Map> newGoodsList2 = (item['dataArray'] as List).cast();
        newGoodsList2.forEach((item2) {
          saveData[item['zd']][item2['name']] = {
            'name': item2['name'],
            'problem': '',
            'state': ''
          };
        });
      });
    }
    // allDatas.addAll(newGoodsList);

    if (mounted) {
      print('开始渲染');
      // setState(() {
      //   allDatas = newGoodsList;
      // });
    }

    // print(allDatas);
    return val;
  }

  String title = '安全工器具柜';
  int xzint = 0; //初始Index
  int zng = 0;
  // List<Map> ceterData = [];
  // List<Map> allDatas = [];
  var zsygd;
  //处理
  void cl() {
    var proveders = Provider.of<AllDate>(context, listen: false);
    post({
      'content': saveData,
      'type': proveders.gdtype,
      'workOrderId': proveders.detail['id']
    }, 'inspection-equipments/saveInspectionEquipmentData')
        .then((val) {
      print(val);
      Toast.toast(context, msg: "保存成功", position: ToastPostion.center);
    });
  }

  var futureBuilderFuture;
  void initState() {
    //初始化状态

    print(window.physicalSize.height - 600);
    setState(() {
      zsygd = window.physicalSize.height - 1350;
    });
    var detail = Provider.of<AllDate>(context, listen: false).detail;
    futureBuilderFuture = requestEquipment(
        {'substationId': detail['substationId']},
        'inspection-equipments/getEquipmentName');
    requestEquipment({'substationId': detail['substationId']},
        'inspection-equipments/getEquipmentName');
    // print("initState");
    if (detail['processeState'] == '0') {
      getSaveData({'id': detail['id']},
          'inspection-equipments/getInspectionEquipmentData');
    }
    super.initState();
  }

  //获取保存的数据
  getSaveData(data, url) {
    get(data, url).then((val) {
      var data = json.decode(val.toString());
      setState(() {
        saveData = data['content'];
      });

      print(data['content']['safetyToolCabinet']);
    });
  }

//修改文本框值
  void changeText(zd, xd, text) {
    saveData[zd][xd]['problem'] = text;
    print(saveData);
  }

//修改单选框
  void changeRadio(zd, xd, text) {
    saveData[zd][xd]['state'] = text;
    print(saveData);
  }

  @override
  Widget build(BuildContext context) {
    var detail = Provider.of<AllDate>(context, listen: false).detail;

    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(0, 101, 105, 1)),
        body: new SingleChildScrollView(
            child: Column(
          children: <Widget>[
            dbtb(),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: double.infinity, //宽度尽可能大
                  maxHeight: zsygd //最小高度为50像素
                  ),
              child: FutureBuilder(
                builder: _buildFuture,
                future: futureBuilderFuture,
              ),
            ),
            
            bottomCl(cl)
          ],
        )));
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    // List allDatas = snapshot.data['content'];
    print(snapshot.data);

    var data = json.decode(snapshot.data.toString());
    List<Map> allDatas = (data['content'] as List).cast();
    // return ListView.builder(
    //   itemBuilder: (context, index) => _itemBuilder(context, index, movies),
    //   itemCount: movies.length * 2,
    // );
    return Container(
        child: ListView.separated(
      shrinkWrap: true,
      itemCount: allDatas[zng]['dataArray'].length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            //上下左右各添加16像素补白
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${allDatas[zng]['dataArray'][index]['name']}",
                        style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                        Widget>[
                      Radio<String>(
                          activeColor: Color.fromRGBO(0, 101, 105, 1),
                          value: allDatas[zng]['dataArray'][index]['dxk'][0]
                              ['name'],
                          //当前Radio 所在组的值
                          //只有value 与groupValue 值一至时才会被选中
                          groupValue: saveData[allDatas[zng]['zd']]
                                  [allDatas[zng]['dataArray'][index]['name']]
                              ['state'],
                          onChanged: (value) {
                            changeRadio(
                                allDatas[zng]['zd'],
                                allDatas[zng]['dataArray'][index]['name'],
                                value);
                            setState(() {
                              allDatas[zng]['dataArray'][index]['dxk'][0]
                                  ['value'] = value;
                            });
                          }),
                      Text(allDatas[zng]['dataArray'][index]['dxk'][0]['name']),
                      Radio<String>(
                          activeColor: Color.fromRGBO(0, 101, 105, 1),
                          value: allDatas[zng]['dataArray'][index]['dxk'][1]
                              ['name'],
                          //当前Radio 所在组的值
                          //只有value 与groupValue 值一至时才会被选中
                          groupValue: saveData[allDatas[zng]['zd']]
                                  [allDatas[zng]['dataArray'][index]['name']]
                              ['state'],
                          onChanged: (value) {
                            changeRadio(
                                allDatas[zng]['zd'],
                                allDatas[zng]['dataArray'][index]['name'],
                                value);
                            setState(() {
                              allDatas[zng]['dataArray'][index]['dxk'][0]
                                  ['value'] = value;
                            });
                          }),
                      Text(allDatas[zng]['dataArray'][index]['dxk'][1]['name']),
                    ])
                  ],
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "存在问题",
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                    ),
                    Expanded(
                        child: Padding(
                            //上下左右各添加16像素补白
                            padding:
                                EdgeInsets.only(left: ScreenUtil().setSp(20)),
                            child: TextField(
                                controller: new TextEditingController(
                                    text: saveData[allDatas[zng]['zd']][
                                        allDatas[zng]['dataArray'][index]
                                            ['name']]['problem']),
                                onChanged: (text) {
                                  print(text);
                                  changeText(
                                      allDatas[zng]['zd'],
                                      allDatas[zng]['dataArray'][index]['name'],
                                      text);
                                },
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(30)),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      '请输入${allDatas[zng]['dataArray'][index]['name']}存在的问题',
                                  hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(28)),
                                )))),
                  ],
                ))
              ],
            ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Color.fromRGBO(153, 153, 153, 0.63));
      },
    ));
  }

  // Widget lbbody() {
  //   return Container(
  //       child: ListView.separated(
  //     shrinkWrap: true,
  //     itemCount: allDatas[zng]['dataArray'].length,
  //     itemBuilder: (BuildContext context, int index) {
  //       return Padding(
  //           //上下左右各添加16像素补白
  //           padding: EdgeInsets.all(8.0),
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   Text("${allDatas[zng]['dataArray'][index]['name']}",
  //                       style: TextStyle(fontSize: ScreenUtil().setSp(28))),
  //                   Row(mainAxisAlignment: MainAxisAlignment.start, children: <
  //                       Widget>[
  //                     Radio<String>(
  //                         activeColor: Color.fromRGBO(0, 101, 105, 1),
  //                         value: allDatas[zng]['dataArray'][index]['dxk'][0]
  //                             ['name'],
  //                         //当前Radio 所在组的值
  //                         //只有value 与groupValue 值一至时才会被选中
  //                         groupValue: saveData[allDatas[zng]['zd']]
  //                                 [allDatas[zng]['dataArray'][index]['name']]
  //                             ['state'],
  //                         onChanged: (value) {
  //                           changeRadio(
  //                               allDatas[zng]['zd'],
  //                               allDatas[zng]['dataArray'][index]['name'],
  //                               value);
  //                           setState(() {
  //                             allDatas[zng]['dataArray'][index]['dxk'][0]
  //                                 ['value'] = value;
  //                           });
  //                         }),
  //                     Text(allDatas[zng]['dataArray'][index]['dxk'][0]['name']),
  //                     Radio<String>(
  //                         activeColor: Color.fromRGBO(0, 101, 105, 1),
  //                         value: allDatas[zng]['dataArray'][index]['dxk'][1]
  //                             ['name'],
  //                         //当前Radio 所在组的值
  //                         //只有value 与groupValue 值一至时才会被选中
  //                         groupValue: saveData[allDatas[zng]['zd']]
  //                                 [allDatas[zng]['dataArray'][index]['name']]
  //                             ['state'],
  //                         onChanged: (value) {
  //                           changeRadio(
  //                               allDatas[zng]['zd'],
  //                               allDatas[zng]['dataArray'][index]['name'],
  //                               value);
  //                           setState(() {
  //                             allDatas[zng]['dataArray'][index]['dxk'][0]
  //                                 ['value'] = value;
  //                           });
  //                         }),
  //                     Text(allDatas[zng]['dataArray'][index]['dxk'][1]['name']),
  //                   ])
  //                 ],
  //               ),
  //               Container(
  //                   child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   Text(
  //                     "存在问题",
  //                     style: TextStyle(fontSize: ScreenUtil().setSp(28)),
  //                   ),
  //                   Expanded(
  //                       child: Padding(
  //                           //上下左右各添加16像素补白
  //                           padding:
  //                               EdgeInsets.only(left: ScreenUtil().setSp(20)),
  //                           child: TextField(
  //                               controller: new TextEditingController(
  //                                   text: saveData[allDatas[zng]['zd']][
  //                                       allDatas[zng]['dataArray'][index]
  //                                           ['name']]['problem']),
  //                               onChanged: (text) {
  //                                 print(text);
  //                                 changeText(
  //                                     allDatas[zng]['zd'],
  //                                     allDatas[zng]['dataArray'][index]['name'],
  //                                     text);
  //                               },
  //                               style:
  //                                   TextStyle(fontSize: ScreenUtil().setSp(30)),
  //                               decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 hintText:
  //                                     '请输入${allDatas[zng]['dataArray'][index]['name']}存在的问题',
  //                                 hintStyle: TextStyle(
  //                                     fontSize: ScreenUtil().setSp(28)),
  //                               )))),
  //                 ],
  //               ))
  //             ],
  //           ));
  //     },
  //     separatorBuilder: (BuildContext context, int index) {
  //       return Divider(color: Color.fromRGBO(153, 153, 153, 0.63));
  //     },
  //   ));
  // }
  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print('done');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _createListView(context, snapshot);
      default:
        return null;
    }
  }

  // Widget zjbf() {
  //   List<Widget> tiles2 = [];
  //   if (mounted) {
  //     for (int i = 0; i < allDatas[zng]['dataArray'].length; i++) {
  //       tiles2.add(Column(
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text("${allDatas[zng]['dataArray'][i]['name']}",
  //                   style: TextStyle(fontSize: ScreenUtil().setSp(28))),
  //               Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     Radio<String>(
  //                         activeColor: Color.fromRGBO(0, 101, 105, 1),
  //                         value: allDatas[zng]['dataArray'][i]['dxk'][0]
  //                             ['name'],
  //                         //当前Radio 所在组的值
  //                         //只有value 与groupValue 值一至时才会被选中
  //                         groupValue: saveData[allDatas[zng]['zd']]
  //                             [allDatas[zng]['dataArray'][i]['name']]['state'],
  //                         onChanged: (value) {
  //                           changeRadio(allDatas[zng]['zd'],
  //                               allDatas[zng]['dataArray'][i]['name'], value);
  //                           setState(() {
  //                             allDatas[zng]['dataArray'][i]['dxk'][0]['value'] =
  //                                 value;
  //                           });
  //                         }),
  //                     Text(allDatas[zng]['dataArray'][i]['dxk'][0]['name']),
  //                     Radio<String>(
  //                         activeColor: Color.fromRGBO(0, 101, 105, 1),
  //                         value: allDatas[zng]['dataArray'][i]['dxk'][1]
  //                             ['name'],
  //                         //当前Radio 所在组的值
  //                         //只有value 与groupValue 值一至时才会被选中
  //                         groupValue: saveData[allDatas[zng]['zd']]
  //                             [allDatas[zng]['dataArray'][i]['name']]['state'],
  //                         onChanged: (value) {
  //                           changeRadio(allDatas[zng]['zd'],
  //                               allDatas[zng]['dataArray'][i]['name'], value);
  //                           setState(() {
  //                             allDatas[zng]['dataArray'][i]['dxk'][0]['value'] =
  //                                 value;
  //                           });
  //                         }),
  //                     Text(allDatas[zng]['dataArray'][i]['dxk'][1]['name']),
  //                   ])
  //             ],
  //           ),
  //           Container(
  //               child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 "存在问题",
  //                 style: TextStyle(fontSize: ScreenUtil().setSp(28)),
  //               ),
  //               Expanded(
  //                   child: Padding(
  //                       //上下左右各添加16像素补白
  //                       padding: EdgeInsets.only(left: ScreenUtil().setSp(20)),
  //                       child: TextField(
  //                           controller: new TextEditingController(
  //                               text: saveData[allDatas[zng]['zd']]
  //                                       [allDatas[zng]['dataArray'][i]['name']]
  //                                   ['problem']),
  //                           onChanged: (text) {
  //                             print(text);
  //                             changeText(allDatas[zng]['zd'],
  //                                 allDatas[zng]['dataArray'][i]['name'], text);
  //                           },
  //                           style: TextStyle(fontSize: ScreenUtil().setSp(30)),
  //                           decoration: InputDecoration(
  //                             border: InputBorder.none,
  //                             hintText:
  //                                 '请输入${allDatas[zng]['dataArray'][i]['name']}存在的问题',
  //                             hintStyle:
  //                                 TextStyle(fontSize: ScreenUtil().setSp(28)),
  //                           )))),
  //             ],
  //           ))
  //         ],
  //       ));
  //     }

  //     Widget content2;
  //     content2 = new Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: Column(
  //           children: tiles2,
  //         ));
  //     return content2;
  //   }
  // }

  Widget dbtb() {
    List<Widget> tiles = [];
    Widget content;
    for (int i = 0; i < equipmentTemplate.length; i++) {
      if (equipmentTemplate[i]['zt'] == 'image') {
        tiles.add(new GestureDetector(
            onTap: () {
              setState(() {
                xzint = i;
                zng = equipmentTemplate[i]['zng'];
                title = equipmentTemplate[i]['name'];
              });

              // print(allDatas[zng]);
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage(
                          "images/${i <= xzint ? equipmentTemplate[i]['yxz'] : equipmentTemplate[i]['wxz']}"),
                      width: ScreenUtil().setSp(55)),
                  Text(
                    equipmentTemplate[i]['name'],
                    style: TextStyle(
                        color: i <= xzint
                            ? Color.fromRGBO(5, 130, 135, 1)
                            : Colors.black),
                  )
                ])));
      } else {
        tiles.add(new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setSp(45)),
                  child: Text(
                    equipmentTemplate[i]['name'],
                    style: TextStyle(
                        color: i <= xzint
                            ? Color.fromRGBO(5, 130, 135, 1)
                            : Colors.black),
                  ))
            ]));
      }
    }
    content = new Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(16.0)),
        child: Row(
            children: tiles,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center));

    return content;
  }
}
