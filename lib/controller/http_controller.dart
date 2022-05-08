import 'dart:convert';
import 'dart:io';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/model/login/login.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/model/util/multipart_requset.dart';
import 'package:heathee/widget/dialog.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/key.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class HttpController extends GetxController {
  static HttpController get to => Get.find();

  double _progress = 0;
  get progress => _progress;

  setProgress(double progress) {
    _progress = progress;
    update();
  }

  StartUploading(String method, String url,
      {List<File> uploadFiles, Map<String, String> fields}) async {
    uploadDialog();
    var response;
    Uri addressUri = Uri.parse(url);
    List<http.MultipartFile> files = new List<http.MultipartFile>();
    if (uploadFiles != null) {
      for (int i = 0; i < uploadFiles.length; i++) {
        var mimeTypeData =
        lookupMimeType(uploadFiles[i].path, headerBytes: [0xFF, 0xD8])
            .split('/');

        final file = await http.MultipartFile.fromPath(
            'files', uploadFiles[i].path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
        files.add(file);
      }
    }
    var fileUploadRequest;

    fileUploadRequest = MultipartReques(method, addressUri,
        onProgress: ((int bytes, int total) async {
          double progress = (bytes / total).toDouble();
          HttpController.to.setProgress(progress);
        }));
    fields.forEach((key, value) {
      fileUploadRequest.fields["$key"] = value;
    });
    (files != null) ? fileUploadRequest.files.addAll(files) : null;
    fileUploadRequest.headers.addAll(AccountController.to.postHeader);

    // 공용
    _progress = null;
    update();
    _progress = 0;
    update();

    final streamedResponse = await fileUploadRequest.send();

    response = await http.Response.fromStream(streamedResponse);
    Get.back();
    return checkError(response, url);
    ;
  }

  startDownloading(String url, String filename, {directory}) async {
    _progress = null;
    update();
    String uri = url + filename;
    final request = Request('GET', Uri.parse(uri));
    request.headers.addAll(AccountController.to.getHeader);
    final StreamedResponse response = await Client().send(request);
    //TODO url => buffer로 대체하고  file writeAsBytes(buffer)를 넣어주기
    final contentLength = response.contentLength;
    _progress = 0;
    update();
    List<int> bytes = [];
    final file = await _getFile(filename);
    response.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
      final downloadedLength = bytes.length;
      _progress = downloadedLength / contentLength;
      update();
    }, onDone: () async {
      update();
      await file.writeAsBytes(bytes);
      Get.back();
      Get.snackbar("다운로드 완료", "$filename 다운로드 완료되었습니다");
    }, onError: (e) {
      print(e);
    }, cancelOnError: true);
  }

  Future<File> _getFile(String fileName, {directory}) async {
    Directory externalDir = await getExternalStorageDirectory();
    String dir;
    if (directory == null) {
      dir = externalDir.path;
    }
    File file = new File('$dir/$fileName');
    return file;
  }

  httpManeger(String method, String url, [Map<String, dynamic> body]) async {
    var response;

    switch (method) {
      case "GET":
        response = await http.get(url, headers: AccountController.to.getHeader);
        break;
      case "DELETE":
        response =
        await http.delete(url, headers: AccountController.to.getHeader);
        break;
      case "POST":
        if (url.endsWith("login") || url.endsWith("register"))
          response = await http.post(url,
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
        else
          response = await http.post(url,
              headers: AccountController.to.postHeader, body: body);
        break;
      case "PATCH":
        response = await http.patch(url,
            headers: AccountController.to.postHeader, body: body);
        break;
      case "PUT":
        response = await http.put(url,
            headers: AccountController.to.postHeader, body: body);
        break;
    }
    return await checkError(response, url);
  }

  checkError(response, url) async {
    String header = response.headers['set-cookie'];
    if (header != null) {
      //저장저장
      cookieStoring(header);
    }
    switch (response.statusCode)  {
      case 200:
      //반환반환
        var responseData = jsonDecode(response.body);
        return responseData;
        break;
      case 204:
      // 정상 로그아웃
        break;
      case 401:
      // 강제 로그아웃
        if (url.endsWith("login"))
          return "signup";
        else {
          await Login().logout();
          Get.offAllNamed('/signin');
          return;
        }
        break;
      case 403:
        return "Black";
      case 404:
        return "Not Found";
      case 406:
      // 블라인드 게시글
        return "blind";
        break;
      case 409:
        return "duplicate";
    // 중복 신고
      case 500:
        return "Error";
    }
  }

  cookieStoring(String header) async {
    print('asd $String header');
    List<String> tokens = Uri.decodeComponent(header).split(";");
    var at = tokens[0].split("=");
    var rt = tokens[4].split("=");
    print('토큰 체크1');
    print(at[1]);
    print(rt[1]);
    Map<String, String> token = {KEYACCESSTOKEN: at[1], KEYREFRESHTOKEN: rt[1]};
    AccountController.to.setHeader(token);
  }
}