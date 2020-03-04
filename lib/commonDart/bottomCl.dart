import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget bottomCl(processingFunction) {
  return Container(
    margin: EdgeInsets.only(top: ScreenUtil().setSp(28)), //容器外补白
    width: ScreenUtil().setWidth(600),
    height: ScreenUtil().setHeight(100),
    child: RaisedButton(
      color: Color.fromRGBO(0, 101, 105, 1),
      highlightColor: Colors.blue[700],
      colorBrightness: Brightness.dark,
      splashColor: Colors.grey,
      child: Text(
        "保存",
        style: TextStyle(fontSize: ScreenUtil().setSp(38)),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        processingFunction();
        
      },
    ),
  );
}
