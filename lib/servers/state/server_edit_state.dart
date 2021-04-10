import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:server_monitor/servers/client/server_client.dart';
import 'package:server_monitor/servers/state/server_state.dart';

part 'server_edit_state.g.dart';

class ServerEditState = _ServerEditState with _$ServerEditState;

abstract class _ServerEditState with Store {
  _ServerEditState({required this.serverState});

  @protected
  final ServerState serverState;

  @observable
  String addressErrorText = '';

  @observable
  String passwordErrorText = '';

  @observable
  bool isLoading = false;

  String _host = '';
  String _password = '';

  String _validation(String value) {
    if (value.contains(' ')) {
      return 'Поле не может содержать пробел';
    }
    return '';
  }

  @action
  void addressInput(String value) {
    if (value.isNotEmpty) {
      addressErrorText = _validation(value);
      _host = value;
      // if (_host == 'fff') {
      //   _host = 'https://projecttest0.000webhostapp.com/api/get';
      // }
    }
  }

  @action
  void setIsLoading(bool value) {
    isLoading = value;
  }

  @action
  void nameInput(String value) {
    if (value.isNotEmpty) {
      passwordErrorText = _validation(value);
      _password = value;
    }
  }

  @action
  bool _finalValidation() {
    bool error = true;
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
      isLoading = true;
      final String key = await ServerClient.checkHost(_host, _password);
      if (key.isNotEmpty) {
        serverState.addHost(_host, key);
        isLoading = false;
        return true;
      }
      isLoading = false;
    }
    return false;
  }

  @action
  void init() {}
}
