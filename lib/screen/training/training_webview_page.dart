import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainingWebviewPage extends StatefulWidget {
  @override
  _TrainingWebviewPageState createState() => _TrainingWebviewPageState();
}

class _TrainingWebviewPageState extends State<TrainingWebviewPage> {

  InAppWebViewController wvc;
  ContextMenu contextMenu;

  String url = "https://seojaewan.github.io/web_front_health/";
  double progress = 0;
  SessionStorage sessionStorage = WebStorage().sessionStorage;

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
  }
  _checkPermissions() async {
    print(await Permission.camera.request().isGranted);
    if (Platform.isAndroid) {
      if (await Permission.camera.request().isGranted) {}
      print('왜 안돼');
      Map<Permission, PermissionStatus> statuses =
      await [Permission.camera].request();
      print(statuses[Permission.location]);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("WebviewTest Page"),
      ),body: SafeArea(
      child: InAppWebView(
              initialUrl: url,
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    useShouldInterceptFetchRequest: true
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller){
                wvc = controller;
                if(wvc.webStorage.sessionStorage.getItem(key : 'id') !=null) {
                  var id = wvc.webStorage.sessionStorage.getItem(key: 'id');
                  var name = wvc.webStorage.sessionStorage.getItem(key: 'name');
                  print('$id : $name');
                }
                print("생성끗");
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                print("onLoadStart $url");
                _checkPermissions();
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                print("onLoadStop $url");
                wvc = controller;
//                var lists= await SessionStorage(controller).getItems();
                print("세션 스토리지 내부 : ");
//                for(var item in lists){
//                  print(item.value);
//                }
//                print(lists.isEmpty);
                var lists = await wvc.webStorage.sessionStorage.getItems();

//                print(await wvc.webStorage.sessionStorage.getItem(key : 'id'));
                lists.forEach((element) {print(element.key);});
//                if(wvc.webStorage.sessionStorage.getItem(key : 'id') !=null) {
//                  var id = await wvc.webStorage.sessionStorage.getItem(key: 'id');
//                  var name = await wvc.webStorage.sessionStorage.getItem(key: 'name');
//                  print('세션스토리지 내부 출력 : ${await id} : ${await name}');
//                }
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                print("오리진" + origin);
                print(resources);
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
            ),
    ),
    );
  }
}
