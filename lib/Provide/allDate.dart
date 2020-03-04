import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xiaocaiflutter/detail.dart';
import 'package:provider/provider.dart';

class AllDate with ChangeNotifier {
  var ip = "http://localhost:4000/";
  var userId;
  var detail;
  var gdtype;
  // AllDate(this.userId, this.detail);
  changeId(val) {
    userId = val;
    print(userId);
    notifyListeners();
  }

  changeDetail(val, type) {
    detail = val;
    gdtype = type;
    print(detail);
    print(gdtype);
    print('详情');
    notifyListeners();
  }
}
