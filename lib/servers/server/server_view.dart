import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ServerView extends StatefulWidget {
  const ServerView({Key key, this.serverName}) : super(key: key);
  final String serverName;

  @override
  _ServerViewState createState() => _ServerViewState();
}

class _ServerViewState extends State<ServerView> {
  ServerState _serverState;

  Widget _item({String title, String value}) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 20,
        height: MediaQuery.of(context).size.width / 2 - 20,
        child: Stack(
          children: [
            Positioned(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
              left: 0,
              right: 0,
            ),
            Center(
              child: Text(
                value,
                textScaleFactor: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigItem({String title, List<double> values}) {
    List<CpuLoad> _createData() {
      final List<CpuLoad> data = [];
      for (int i = 0; i < values.length; i++) {
        data.add(CpuLoad(values[i], i));
      }
      return data;
    }

    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.width / 2 - 20,
        child: Center(
          child: SfCartesianChart(
            title: ChartTitle(text: title),
            primaryXAxis: NumericAxis(interval: 1, majorGridLines: MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(majorTickLines: MajorTickLines(color: Colors.transparent), axisLine: AxisLine(width: 0), minimum: 0, maximum: 100),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <SplineAreaSeries<CpuLoad, int>>[
              SplineAreaSeries<CpuLoad, int>(
                dataSource: _createData(),
                xValueMapper: (CpuLoad cpuLoad, _) => cpuLoad.position,
                yValueMapper: (CpuLoad cpuLoad, _) => cpuLoad.value,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(Server server) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(title: 'Температура процессора', value: server.cpuTemp.toString()),
            _item(title: 'Скорость куллера процессора', value: server.cpuFan.toString()),
          ],
        ),
        _bigItem(title: 'Загруженность процессора', values: server.cpuLoads),
      ],
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
      appBar: AppBar(),
      body: Observer(
        builder: (_) => _buildBody(
          _serverState.servers[widget.serverName],
        ),
      ),
    );
  }
}

class CpuLoad {
  CpuLoad(this.value, this.position);
  final double value;
  final int position;
}
