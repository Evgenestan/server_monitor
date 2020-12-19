import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:server_monitor/servers/model/server.dart';

class ServerClient {
  String serverGetEndpoint = 'https://projecttest0.000webhostapp.com/api/get';

  Future<Server> getData() async {
    try {
      final Response<dynamic> response = await Dio().get<dynamic>(serverGetEndpoint);
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
      return _server;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
