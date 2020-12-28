import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:server_monitor/servers/client/server_client.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'server_edit_state.g.dart';

class ServerEditState = _ServerEditState with _$ServerEditState;

abstract class _ServerEditState with Store {
  _ServerEditState({@required this.serverState});

  @protected
  final ServerState serverState;

  SharedPreferences _sharedPreferences;

  @observable
  String addressErrorText;

  @observable
  String passwordErrorText;

  String _host = '';
  String _password = '';

  String _validation(String value) {
    if (value.contains(' ')) {
      return 'Поле не может содержать пробел';
    }
    return null;
  }

  @action
  void addressInput(String value) {
    if (value?.isNotEmpty ?? false) {
      addressErrorText = _validation(value);
      _host = value ?? '';
      if (_host == 'fff') {
        _host = 'https://projecttest0.000webhostapp.com/api/get';
      }
    }
  }

  @action
  void nameInput(String value) {
    if (value?.isNotEmpty ?? false) {
      passwordErrorText = _validation(value);
      _password = value ?? '';
    }
  }

  @action
  bool _finalValidation() {
    bool error = true;
    if (passwordErrorText != null || addressErrorText != null) {
      error = false;
    }
    if (_password.isEmpty) {
      passwordErrorText = 'Пароль - обязательное поле';
      error = false;
    }
    if (_host.isEmpty) {
      addressErrorText = 'Адрес сервера - обязательное поле';
      error = false;
    }
    if (serverState.endpoints.contains(_host)) {
      addressErrorText = 'Такой адрес уже существует';
      error = false;
    }
    if (!_host.contains('http')) {
      addressErrorText = 'Некоректный адрес';
      error = false;
    }
    return error;
  }

  @action
  Future<bool> addHost() async {
    if (_finalValidation()) {
      //ToDo: проверка на бэке
      final bool result = await ServerClient.checkHost(_host, _password);
      if (result) {
        serverState.endpoints.add(_host);
        await _sharedPreferences.setStringList('hosts', serverState.endpoints);
        return true;
      }
      return false;
    }
    return null;
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
