import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:web_socket_channel/io.dart';

class ServerClient {
  String serverGetEndpoint = 'https://projecttest0.000webhostapp.com/api/get';

  static Future<String> checkHost(String host, String password) async {
    try {
      final Response<dynamic> response = await Dio().get<dynamic>(host, queryParameters: <String, String>{'password': password});
      final key = response.data.toString();
      if (key.length == 5) {
        return key;
      }
    } catch (e) {
      print(e);
      return '';
    }
    return '';
  }

  void connectToSocket(Function(ServerDate) onUpdate) {
    final channel = IOWebSocketChannel.connect('ws://192.168.31.214:8080/ws');
    //channel.sink.add('server monitor');
    channel.stream.listen((dynamic event) {
      final dynamic item = jsonDecode(event);
      final name = item['name'].toString().isEmpty ? 'MyServer' : item['name'].toString();
      final _server = ServerDate();
      _server.name = name;
      _server.createTime = DateTime.tryParse(item['createTime'] ?? '') ?? DateTime.now();
      _server.cpuTemp = item['cpuTemp'];
      _server.gpuTemp = item['gpuTemp'];
      _server.cpuFan = item['cpuFan'];
      _server.gpuFan = item['gpuFan'];
      _server.motherFan = item['motherFan'];
      _server.cpuLoad = item['cpuLoad'];
      _server.gpuLoad = item['gpuLoad'];
      _server.host = Uri.parse('endpoint').host;
      onUpdate(_server);
    });
  }

  Future<Map<String, ServerDate>> getData(List<String> endpoints) async {
    //return null;
    if (endpoints.isNotEmpty && endpoints.every((element) => element.contains('http'))) {
      final Map<String, ServerDate> _servers = {};
      for (String endpoint in endpoints) {
        try {
          final Response<dynamic> response = await Dio().get<dynamic>(endpoint);
          final List<dynamic> json = jsonDecode(response.data);
          for (dynamic item in json) {
            String name;
            name = item['name'].toString().isEmpty ? 'MyServer' : item['name'].toString();
            _servers[name] ??= ServerDate();
            _servers[name]!.name = name;
            // _servers[name]!.cpuTemps.add(double.parse(item['cpuTemp']));
            // _servers[name]!.cpuFans.add(double.parse(item['cpuFan']));
            // _servers[name]!.gpuTemps.add(double.parse(item['gpuTemp']));
            // _servers[name]!.gpuFans.add(double.parse(item['gpuFan']));
            // _servers[name]!.motherFans.add(double.parse(item['motherFan']));
            // _servers[name]!.cpuLoads.add(double.parse(item['cpuLoad']));
            // _servers[name]!.gpuLoads.add(double.parse(item['gpuLoad']));
            // _servers[name]!.createTimes.add(DateTime.parse(item['createTime']));
            // _servers[name]!.cpuTemp = _servers[name]!.cpuTemps.last.toInt();
            // _servers[name]!.gpuTemp = _servers[name]!.gpuTemps.last.toInt();
            // _servers[name]!.cpuFan = _servers[name]!.cpuFans.last.toInt();
            // _servers[name]!.gpuFan = _servers[name]!.gpuFans.last.toInt();
            // _servers[name]!.motherFan = _servers[name]!.motherFans.last.toInt();
            // _servers[name]!.cpuLoad = _servers[name]!.cpuLoads.last.toInt();
            // _servers[name]!.gpuLoad = _servers[name]!.gpuLoads.last.toInt();
            // _servers[name]!.host = Uri.parse(endpoint).host;
          }
        } catch (e) {
          print('Request to $endpoint ended with error');
          print(e);
        }
      }
      return _servers;
    }
    return {};
  }
}
