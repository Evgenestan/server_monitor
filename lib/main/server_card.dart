import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  const ServerCard({Key key, @required this.title, @required this.isOnline, @required this.ipAddress}) : super(key: key);
  final String title;
  final String ipAddress;
  final bool isOnline;

  Widget _buildTextWithParameter({@required String text, @required String parameter, Icon icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(parameter + ':'),
        Row(
          children: [
            if (icon != null) icon,
            Text(text),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.network('https://sun9-51.userapi.com/pMpaVr5o5RzH0WUVsUzT50P2ofKvxTqw32hXmg/r_GEx4qM1_M.jpg'),
            Expanded(
              child: Column(
                children: [
                  _buildTextWithParameter(text: title, parameter: 'Название'),
                  _buildTextWithParameter(
                    text: isOnline ? 'Онлайн' : 'Офлайн',
                    parameter: 'Статус',
                    icon: Icon(
                      Icons.online_prediction,
                      color: isOnline ? Colors.green : Colors.red,
                    ),
                  ),
                  _buildTextWithParameter(text: ipAddress, parameter: 'Ip адрес'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
