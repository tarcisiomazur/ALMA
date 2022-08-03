import 'dart:async';

import 'package:web_socket_channel/io.dart';

class ApiWebSocket{
  static final ApiWebSocket _instance = ApiWebSocket._();
  late IOWebSocketChannel websocket;
  final StreamController<dynamic> _recipientCtrl = StreamController<dynamic>();
  final StreamController<dynamic> _sentCtrl = StreamController<dynamic>();
  final StreamController<String> _connected = StreamController<String>();

  final delay = 10;

  get stream => _recipientCtrl.stream;
  get sink => _sentCtrl.sink;
  get connected => _connected.stream;

  ApiWebSocket._(){
    _connect();
    stream.listen(onMessage);
  }

  void Init(){

  }

  void _connect() {
    websocket = IOWebSocketChannel.connect('ws://192.168.1.5:20240');
    websocket.stream.listen((event) {
      _recipientCtrl.add(event);
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
      }
    }
  }

  static ApiWebSocket getInstance(){
    return _instance;
  }


}