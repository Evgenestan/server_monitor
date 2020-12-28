import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:server_monitor/servers/model/server.dart';

class ServerClient {
  String serverGetEndpoint = 'https://projecttest0.000webhostapp.com/api/get';

  static Future<bool> checkHost(String host, String password) async {
    try {
      final Response<dynamic> response = await Dio().get<dynamic>(host);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<Map<String, Server>> getData(List<String> endpoints) async {
    if (endpoints != null && endpoints.isNotEmpty && endpoints.every((element) => element.contains('http'))) {
      try {
        final Map<String, Server> _servers = {};
        for (String endpoint in endpoints) {
          final Response<dynamic> response = await Dio().get<dynamic>(endpoint);
          final List<dynamic> json = jsonDecode(response.data);
          final Server _server = Server();
          for (dynamic item in json) {
            _server.name = item['name'].toString().isEmpty ? 'MyServer' : item['name'];
            _server.cpuTemps.add(double.parse(item['cpuTemp']));
            _server.cpuFans.add(double.parse(item['cpuFan']));
            _server.gpuTemps.add(double.parse(item['gpuTemp']));
            _server.gpuFans.add(double.parse(item['gpuFan']));
            _server.motherFans.add(double.parse(item['motherFan']));
            _server.cpuLoads.add(double.parse(item['cpuLoad']));
            _server.gpuLoads.add(double.parse(item['gpuLoad']));
            _server.createTimes.add(DateTime.parse(item['createTime']));
          }
          _server.cpuTemp = _server.cpuTemps.last.toInt();
          _server.gpuTemp = _server.gpuTemps.last.toInt();
          _server.cpuFan = _server.cpuFans.last.toInt();
          _server.gpuFan = _server.gpuFans.last.toInt();
          _server.motherFan = _server.motherFans.last.toInt();
          _server.cpuLoad = _server.cpuLoads.last.toInt();
          _server.gpuLoad = _server.gpuLoads.last.toInt();
          _server.host = Uri.parse(endpoint).host;
          _servers[_server.name] = _server;
        }
        return _servers;
      } catch (e) {
        print(e);
      }
      return null;
    }
    return null;
  }
}
