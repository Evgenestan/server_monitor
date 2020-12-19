import 'package:mobx/mobx.dart';
import 'package:server_monitor/servers/client/server_client.dart';
import 'package:server_monitor/servers/model/server.dart';

part 'server_state.g.dart';

class ServerState = _ServerStateBase with _$ServerState;

abstract class _ServerStateBase with Store {
  final ServerClient _serverClient = ServerClient();

  @observable
  int count = 0;

  @observable
  ObservableMap<String, Server> servers = ObservableMap();

  @action
  Future<void> getData() async {
    final Server _server = await _serverClient.getData();
    servers[_server.name] = _server;
    count = servers.length;
  }
}
