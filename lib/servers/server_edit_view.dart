import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/state/server_edit_state.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:server_monitor/widgets/buttons.dart';
import 'package:server_monitor/widgets/modals.dart';

class ServerEditView extends StatefulWidget {
  @override
  _ServerEditViewState createState() => _ServerEditViewState();
}

class _ServerEditViewState extends State<ServerEditView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  ServerEditState _serverEditState;
  ServerState _serverState;

  Future<void> _addHost() async {
    final result = await _serverEditState.addHost();
    if (result == true) {
      Navigator.of(context).pop();
    } else if (result == false) {
      await showDialog<void>(
        context: context,
        builder: (_) => CustomDialog(
          title: 'Ошибка',
          description: 'Неправильный адрес хоста или пароль',
          actions: [
            FlatButton(onPressed: () => Navigator.pop(context), child: const Text('Понятно')),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _serverState = Provider.of<ServerState>(context, listen: false);
    _serverEditState = ServerEditState(serverState: _serverState);
    _addressController.addListener(() => _serverEditState.addressInput(_addressController.text));
    _nameController.addListener(() => _serverEditState.nameInput(_nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Observer(
          builder: (_) => Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                physics: const BouncingScrollPhysics(),
                children: [
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      errorText: _serverEditState.addressErrorText,
                      labelText: 'Адрес хоста',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _nameController,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: _serverEditState.passwordErrorText,
                      labelText: 'Пароль',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                    title: 'Добавить хост',
                    onPressed: _addHost,
                  ),
                ],
              ),
              if (_serverEditState.isLoading)
                Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.5),
                  child: const CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
