import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatBotSocket {
  late Uri uri;
  late IOWebSocketChannel _channel;
  late StreamController controller;
  late bool isOpen = false;

  late List<String> messages = [
    "",
  ];

  ChatBotSocket(String uri) {
    uri = uri;
    _channel = IOWebSocketChannel.connect(Uri.parse(uri));
  }

  ChatBotSocket.withDefaultUri() : uri = Uri.parse('${ChatBotSocket.getUri()}/chat') {
    controller = StreamController.broadcast();
    open();
  }

  IOWebSocketChannel getWebSocketChannel() {
    return _channel;
  }

  StreamController getStreamController() {
    return controller;
  }

  void close() {
    _channel.sink.close();
    isOpen = false;
  }

  void open() {
    _channel = IOWebSocketChannel.connect(uri);
    controller.addStream(_channel.stream);
    isOpen = true;
  }

  static String getUri() {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_WS']!;
    }
    if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_WS']!;
    }
    throw UnsupportedError('Platform not supported');
  } 
}