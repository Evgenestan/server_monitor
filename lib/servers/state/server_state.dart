import 'package:mobx/mobx.dart';
import 'package:server_monitor/servers/client/server_client.dart';
import 'package:server_monitor/servers/model/server.dart';

part 'server_state.g.dart';

class ServerState = _ServerStateBase with _$ServerState;

abstract class _ServerStateBase with Store {
  final ServerClient _serverClient = ServerClient();

  List<String> endpoints = [];

  @observable
  int count = 0;

  @observable
  ObservableMap<String, Server> servers = ObservableMap();

  @action
  Future<void> getData() async {
    final Map<String, Server> _servers = await _serverClient.getData(endpoints);
    if (_servers != null) {
      servers.clear();
      servers.addAll(_servers);
      count = servers.length;
    }
  }
}
