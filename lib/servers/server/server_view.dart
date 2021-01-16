import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/server/schedule_view.dart';
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

  Widget _item({String title, String value, ScheduleType scheduleType}) {
    void _openScheduleOfValues() {
      if (scheduleType != null) {
        Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) => ScheduleView(serverName: widget.serverName, scheduleType: scheduleType)));
      }
    }

    return Card(
      child: InkWell(
        onTap: _openScheduleOfValues,
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 20,
          height: MediaQuery.of(context).size.width / 2 - 20,
          padding: const EdgeInsets.all(5),
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
      ),
    );
  }

  Widget _bigItem({String title, List<double> values}) {
    List<Value> _createData() {
      final List<Value> data = [];
      for (int i = 0; i < values.length; i++) {
        data.add(Value(values[i], i));
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
            series: <SplineAreaSeries<Value, int>>[
              SplineAreaSeries<Value, int>(
                dataSource: _createData(),
                xValueMapper: (Value cpuLoad, _) => cpuLoad.position,
                yValueMapper: (Value cpuLoad, _) => cpuLoad.value,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(Server server) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(title: 'Температура CPU', value: server.cpuTemp.toString(), scheduleType: ScheduleType.cpuTemps),
            _item(title: 'Скорость вращения вентилятора системы охлаждения CPU', value: server.cpuFan.toString()),
          ],
        ),
        _bigItem(title: 'Загруженность CPU', values: server.cpuLoads),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _item(title: 'Температура GPU', value: server.gpuTemp.toString(), scheduleType: ScheduleType.gpuTemps),
            _item(title: 'Скорость вращения вентилятора системы охлаждения GPU', value: server.gpuFan.toString()),
          ],
        ),
        _bigItem(title: 'Загруженность GPU', values: server.gpuLoads),
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

class Value {
  Value(this.value, this.position);
  final double value;
  final int position;
}
