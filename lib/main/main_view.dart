import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/main/server_card.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/server/server_view.dart';
import 'package:server_monitor/servers/server_edit_view.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:server_monitor/widgets/modals.dart';

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

  void deleteServer(Server server) {
    final host = server.host;
    _serverState.deleteHost(host);
  }

  Future<bool> remove(Server server) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: 'Вы уверены что хотите удалить хост?',
        description: 'Все связанные с ним сервера будут удалены',
        actions: [
          FlatButton(
            child: const Text(
              'Отмена',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              deleteServer(server);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return false;
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Удалить',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _buildServerCard(BuildContext context, int index) {
    final String key = _serverState.servers.keys.toList()[index];
    final Server server = _serverState.servers[key];
    return Dismissible(
      confirmDismiss: (_) => remove(server),
      background: slideLeftBackground(),
      direction: DismissDirection.endToStart,
      key: Key('dismissible $index'),
      child: ServerCard(
        title: server?.name ?? 'Имя сервера не найдено',
        isOnline: DateTime.now().toUtc().difference(server.createTimes.last) < const Duration(seconds: 10),
        host: server.host,
        onPressed: () => _openServer(server),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _serverState = Provider.of<ServerState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Server Monitor',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Stack(
          children: [
            Center(
              child: Observer(
                builder: (_) => _serverState.count > 0
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Container(),
              ),
            ),
            const Center(child: Icon(Icons.add)),
          ],
        ),
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
