// const serviceUrl= 'http://localhost:4000/';//此端口针对于正版用户开放，可自行fiddle获取。
import 'dart:developer';

const serviceUrl = 'http://183.252.1.140:81/api/';
// const serviceUrl = 'http://192.168.1.162:9898/';
// const serviceUrl = 'http://ops.xmrtc.com/api/';
const servicePath = {
  'login': serviceUrl + 'login', // 登录
  'getList': serviceUrl + 'inspector-infos/getList',
  'dealwith': serviceUrl + 'feedback-tables',
};
