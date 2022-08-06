import 'dart:async';

import 'package:alma/services/server_api.dart';
import 'package:web_socket_channel/io.dart';

class ApiWebSocket{
  static final ApiWebSocket _instance = ApiWebSocket._();
  late IOWebSocketChannel _websocket;
  final StreamController<dynamic> _recipientCtrl = StreamController<dynamic>();
  final StreamController<dynamic> _sentCtrl = StreamController<dynamic>();
  final StreamController<String> _connected = StreamController<String>();

  final delay = 10;

  get stream => _recipientCtrl.stream;
  get sink => _sentCtrl.sink;
  get connected => _connected.stream;

  ApiWebSocket._(){
    stream.listen(onMessage);
    _sentCtrl.stream.listen((event) {
      _websocket.sink.add(event);
    });
  }

  void Init(){
    _connect();
  }

  void _connect() {
    _websocket = IOWebSocketChannel.connect('ws://189.76.193.24:20240', headers: {
      'Authorization': 'Bearer ${ServerApi.getInstance().token}',
    });
    _websocket.stream.listen((event) {
      _recipientCtrl.add(event);
      sink.add("Ok");
    }, onError: (e) async {
      _recipientCtrl.addError(e);
      await Future.delayed(Duration(seconds: delay));
      _connect();
    }, onDone: () async {
      await Future.delayed(Duration(seconds: delay));
      _connect();
    }, cancelOnError: true);
  }

  void onMessage(dynamic message) {
    if(message is String){
      String str = message.toString();
      if(str.contains("ConnID: ")){
        _connected.add(str.replaceFirst("ConnID: ", ""));
      }else{
        print(str);
      }
    }
  }

  static ApiWebSocket getInstance(){
    return _instance;
  }


}