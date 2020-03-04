import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './service/service_method.dart';
import 'Provide/allDate.dart';
// import 'package:provide/provide.dart';
import 'package:provider/provider.dart';
import './detail.dart';

class Home extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  @override
  ScrollController _controller = new ScrollController();
  static Color jhgdbj = Colors.white;
  static Color jhgdzt = Color.fromRGBO(0, 101, 105, 1);
  static Color rwgdbj = Color.fromRGBO(0, 101, 105, 1);
  static Color rwgdzt = Colors.white;
  int gdtype = 0;
  int pageNo = 1;
  int pages = 0;
  var _items = new List<Map>();
//计划工单列表
  void jhgdlb() {
    setState(() {
      gdtype = 0;
    });
    print('计划工单');
    _onRefresh();
  }

//任务工单列表
  void rwgdlb() {
    setState(() {
      gdtype = 1;
    });
    print('任务工单');
    _onRefresh();
  }

  void initState() {
    qqlb();
    super.initState();
  }

  void didChangeDependencies() {
    _controller.addListener(() {
      //判断是否滑动到了页面的最底部
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print('+++');
        print(pageNo);
        print(pages);
        //如果不是最后一页数据，则生成新的数据添加到list里面
        if (pageNo < pages) {
          pageNo++;

          qqlb();
          setState(() {});
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    // await Future.delayed(Duration(seconds: 2)).then((e) {});
    setState(() {
      pageNo = 1;
      _items.clear();
    });
    qqlb();
  }

  _retrieveData() {
    // print('+++');
    // setState(() {
    //   pageNo++;
    // });
    //上拉加载新的数据

    Future.delayed(Duration(seconds: 0)).then((e) {
      qqlb();
      setState(() {});
    });
  }

  void dispose() {
    //移除监听，防止内存泄漏
    _controller.dispose();

    super.dispose();
  }

//请求列表
  qqlb() async {
    // var allDate2 = new AllDate();
    // print(Provide.value<AllDate>(context).userId);
    await getList({
      'type': gdtype,
      'userId': Provider.of<AllDate>(context, listen: false).userId,
      'page': pageNo,
      'limit': 7
    }).then((val) {
      print(val);
      var data = json.decode(val.toString());
      if (mounted) {
        setState(() {
          pages = int.parse(data['pages']);
        });
        List<Map> newGoodsList = (data['records'] as List).cast();
        _items.addAll(newGoodsList);
      }

      // print(_items);
    });
  }

//处理详情
  processingDetails(value) {
    Provider.of<AllDate>(context).changeDetail(value, gdtype);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new detail()));
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return new Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        // overflow: Overflow.visible,
        // fit: StackFit.loose,
        // child: ListBody(),
        alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
        children: <Widget>[
          Positioned(
              top: ScreenUtil().setSp(0),
              child: Image(
                  image: NetworkImage(
                      "http://ops.xmrtc.com/api/fs/files/677104712469843968/1"),
                  width: ScreenUtil().setWidth(752))),
          Positioned(
            top: ScreenUtil().setSp(44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("配电巡检",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(44),
                    )),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setSp(34)), //容器外补白
                  width: ScreenUtil().setSp(584),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    verticalDirection: VerticalDirection.up,

                    children: <Widget>[
                      RaisedButton(
                        color: gdtype == 0
                            ? Colors.white
                            : Color.fromRGBO(0, 101, 105, 1),
                        highlightColor: Colors.blue[700],
                        colorBrightness: Brightness.dark,
                        splashColor: Colors.grey,
                        child: Text(
                          "计划工单",
                          style: TextStyle(
                              inherit: false, //2.不继承默认样式
                              color: gdtype == 0
                                  ? Color.fromRGBO(0, 101, 105, 1)
                                  : Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: jhgdlb,
                      ),
                      RaisedButton(
                        color: gdtype == 1
                            ? Colors.white
                            : Color.fromRGBO(0, 101, 105, 1),
                        highlightColor: Colors.blue[700],
                        colorBrightness: Brightness.dark,
                        splashColor: Colors.grey,
                        child: Text(
                          "任务工单",
                          style: TextStyle(
                              inherit: false, //2.不继承默认样式
                              color: gdtype == 1
                                  ? Color.fromRGBO(0, 101, 105, 1)
                                  : Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: rwgdlb,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListBody(),
        ],
      ),
    )));
  }

  Widget ListBody() {
    return Container(
      width: ScreenUtil().setSp(684),
      margin: EdgeInsets.only(top: ScreenUtil().setSp(250)), //容器外补白
      // color: Colors.white,

      alignment: Alignment.topCenter,
      child: new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new ListView.builder(
            shrinkWrap: true,
            controller: _controller,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              //判断是否构建到了最后一条item
              if (index == _items.length) {
                //判断是不是最后一页
                if (pageNo < pages) {
                  //不是最后一页，返回一个loading窗
                  return new Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      width: ScreenUtil().setWidth(10),
                      // alignment: Alignment.center,
                      child: Text(
                        '加载中...',
                        style: TextStyle(color: Color.fromRGBO(0, 101, 105, 1)),
                      ));
                } else {
                  //是最后一页，显示我是有底线的
                  return new Container(
                    alignment: const Alignment(0.0, 0.0),
                    padding: _items.length < 1
                        ? EdgeInsets.only(top: 116.0)
                        : EdgeInsets.all(20),
                    child: Center(
                        child: Text(
                      _items.length < 1 ? '无任何数据' : '没有更多了',
                      style: TextStyle(color: Color.fromRGBO(0, 101, 105, 1)),
                    )),
                  );
                }
              } else {
                return Container(
                    width: ScreenUtil().setSp(684),
                    margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
                    decoration: BoxDecoration(
                        //背景装饰
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.0), //3像
                        boxShadow: [
                          //卡片阴影
                        ]),
                    // color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            //上下左右各添加16像素补白
                            padding: EdgeInsets.all(13.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color(0xffe5e5e5)))),
                                child: Padding(
                                    //上下左右各添加16像素补白
                                    padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setSp(13)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Image.asset(
                                                "images/zdmc.png",
                                                width:
                                                    ScreenUtil().setWidth(34),
                                              ),
                                              Text(
                                                  '${_items[index]['substationName']}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(30),
                                                  )),
                                            ]),
                                        Container(
                                            height: ScreenUtil().setHeight(58),
                                            width: ScreenUtil().setWidth(150),
                                            child: FlatButton(
                                                color: _items[index]
                                                            ['processeState'] ==
                                                        "0"
                                                    ? Color.fromRGBO(
                                                        8, 140, 145, 1)
                                                    : Color.fromRGBO(
                                                        249, 97, 97, 1),
                                                // highlightColor: Colors.blue[700],
                                                colorBrightness:
                                                    Brightness.dark,
                                                splashColor: Colors.grey,
                                                child: Text(
                                                  _items[index][
                                                              'processeState'] ==
                                                          "0"
                                                      ? "已处理"
                                                      : "未处理",
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(25)),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                onPressed: () {
                                                  processingDetails(
                                                      _items[index]);
                                                }))
                                      ],
                                    )))),
                        list(
                          context,
                          _items[index]['workOrderNo'],
                          _items[index]['createTime'],
                          _items[index]['taskType'],
                        )
                      ],
                    ));

                // ListTile(title: new Text('${_items[index]['id']}'));
              }
            },
            //分割线构造器
            // separatorBuilder: (context, index) {
            //   return new Divider(
            //     color: Colors.blue,
            //   );
            // },
            //_items.length + 1是为了给最后一行的加载loading留出位置
            itemCount: _items.length + 1),
      ),
    );
  }

  Widget list(BuildContext context, workOrderNo, createTime, taskType) {
    var rwxz = taskType == 0 ? "巡视任务" : taskType == 1 ? "检修任务" : "抢修任务";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            //上下左右各添加16像素补白
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(5), left: ScreenUtil().setSp(30)),
            child: Text("工单编号：${workOrderNo}",
                style: TextStyle(fontSize: ScreenUtil().setSp(28)))),
        Padding(
            //上下左右各添加16像素补白
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(5), left: ScreenUtil().setSp(30)),
            child: Text("发起时间：${createTime}",
                style: TextStyle(fontSize: ScreenUtil().setSp(28)))),
        Padding(
            //上下左右各添加16像素补白
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(5),
                bottom: ScreenUtil().setSp(25),
                left: ScreenUtil().setSp(30)),
            child: Text("任务性质：${rwxz}",
                style: TextStyle(fontSize: ScreenUtil().setSp(28)))),
      ],
    );
  }
}
