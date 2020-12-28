import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/main/server_card.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/server/server_view.dart';
import 'package:server_monitor/servers/server_edit_view.dart';
import 'package:server_monitor/servers/state/server_state.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  ServerState _serverState;

  void _addServer() {
    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) => ServerEditView()));
  }

  void _openServer(Server server) {
    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) => ServerView(serverName: server.name)));
  }

  void _editServer(DismissDirection direction) {
    //if()
  }

  Future<bool> test(DismissDirection direction) async {
    return false;
  }

  Widget _buildServerCard(BuildContext context, int index) {
    final String key = _serverState.servers.keys.toList()[index];
    final Server server = _serverState.servers[key];
    return Dismissible(
      confirmDismiss: test,
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: const Text('Удалить хост'),
      ),
      secondaryBackground: Container(color: Colors.lightBlueAccent),
      key: Key('dismissible $index'),
      onDismissed: _editServer,
      child: ServerCard(
        title: server?.name ?? 'Имя сервера не найдено',
        isOnline: DateTime.now().toUtc().difference(server.createTimes.last) < const Duration(seconds: 10),
        host: server.host,
        onPressed: () => _openServer(server),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serverState = Provider.of<ServerState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addServer,
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          padding: const EdgeInsets.all(10),
          itemBuilder: _buildServerCard,
          itemCount: _serverState.count,
        ),
      ),
    );
  }
}
