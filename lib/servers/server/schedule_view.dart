import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ScheduleType { cpuTemps, gpuTemps }

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key key, @required this.scheduleType, @required this.serverName}) : super(key: key);
  final ScheduleType scheduleType;
  final String serverName;

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  ServerState _serverState;

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
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: widget.scheduleType == ScheduleType.cpuTemps ? _bigItem(title: 'Температура CPU', values: server.cpuTemps) : _bigItem(title: 'Температура GPU', values: server.gpuTemps));
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
