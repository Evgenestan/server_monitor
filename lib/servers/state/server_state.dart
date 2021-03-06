import 'package:mobx/mobx.dart';
import 'package:server_monitor/servers/client/server_client.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'server_state.g.dart';

class ServerState = _ServerStateBase with _$ServerState;

abstract class _ServerStateBase with Store {
  final ServerClient _serverClient = ServerClient();

  List<String> endpoints = ObservableList();

  @observable
  int count = 0;

  @observable
  ObservableMap<String, ObservableList<ServerDate>> servers = ObservableMap();

  List<ServerDate> getServer(String name) => servers[name] ?? [];

  late final SharedPreferences _sharedPreferences;

  @action
  void addHost(String host, String key) {
    host = '$host?key=$key';
    endpoints.add(host);
    _sharedPreferences.setStringList('hosts', endpoints);
    getData();
  }

  @action
  void deleteHost(String host) {
    endpoints.removeWhere((element) => Uri.parse(element).host == host);
    _sharedPreferences.setStringList('hosts', endpoints);
    getData();
  }

  @action
  Future<void> getData() async {
    //final Map<String, Server> _servers = await _serverClient.getData(endpoints);
    //servers.clear();
    //servers.addAll(_servers);
    //count = servers.length;
  }

  @action
  void sync(ServerDate server) {
    servers[server.name] ??= ObservableList();
    servers[server.name]?.add(server);
    if (servers[server.name]?.length == 100) {
      servers[server.name]?.removeAt(0);
    }
  }

  void connectToSocket() {
    _serverClient.connectToSocket(sync);
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
