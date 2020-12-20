import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
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
  String nameErrorText;

  String _address = '';
  String _name = '';

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
      _address = value ?? '';
      if (_address == 'fff') {
        _address = 'https://projecttest0.000webhostapp.com/api/get';
      }
    }
  }

  @action
  void nameInput(String value) {
    if (value?.isNotEmpty ?? false) {
      nameErrorText = _validation(value);
      _name = value ?? '';
    }
  }

  @action
  bool _finalValidation() {
    bool error = true;
    if (nameErrorText != null || addressErrorText != null) {
      error = false;
    }
    if (_name.isEmpty) {
      nameErrorText = 'Пароль - обязательное поле';
      error = false;
    }
    if (_address.isEmpty) {
      addressErrorText = 'Адрес сервера - обязательное поле';
      error = false;
    }
    return error;
  }

  @action
  Future<bool> addServer() async {
    if (_finalValidation()) {
      //ToDo: проверка на бэке
      final bool result = true; //ToDo: проверка на бэке
      if (result) {
        serverState.endpoint = _address;
        await _sharedPreferences.setString('address', _address);
      }
      return false;
    }
    return null;
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
