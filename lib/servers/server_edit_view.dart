import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/state/server_edit_state.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:server_monitor/widgets/buttons.dart';

class ServerEditView extends StatefulWidget {
  @override
  _ServerEditViewState createState() => _ServerEditViewState();
}

class _ServerEditViewState extends State<ServerEditView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  ServerEditState _serverEditState;
  ServerState _serverState;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(() => _serverEditState.addressInput(_addressController.text));
    _nameController.addListener(() => _serverEditState.nameInput(_nameController.text));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serverState = Provider.of<ServerState>(context);
    _serverEditState = ServerEditState(serverState: _serverState);
    _serverEditState.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Observer(
          builder: (_) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            physics: const BouncingScrollPhysics(),
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  errorText: _serverEditState.addressErrorText,
                  labelText: 'Адрес сервера',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  errorText: _serverEditState.nameErrorText,
                  labelText: 'Пароль',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              MyButton(
                title: 'Добавить сервер',
                onPressed: _serverEditState.addServer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
