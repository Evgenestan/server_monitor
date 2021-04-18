import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:server_monitor/servers/model/server.dart';
import 'package:server_monitor/servers/state/server_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ScheduleType { cpuTemps, gpuTemps }

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key, required this.scheduleType, required this.serverName}) : super(key: key);
  final ScheduleType scheduleType;
  final String serverName;

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late final ServerState _serverState;

  Widget _bigItem({required String title, required List<int> values}) {
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
            primaryXAxis: NumericAxis(interval: 1, majorGridLines: const MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(majorTickLines: const MajorTickLines(color: Colors.transparent), axisLine: const AxisLine(width: 0), minimum: 0, maximum: 100),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <SplineSeries<CpuLoad, int>>[
              SplineSeries<CpuLoad, int>(
                dataSource: _createData(),
                animationDuration: 0,
                xValueMapper: (CpuLoad cpuLoad, _) => cpuLoad.position,
                yValueMapper: (CpuLoad cpuLoad, _) => cpuLoad.value,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ServerDate server) {
    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: widget.scheduleType == ScheduleType.cpuTemps
            ? _bigItem(title: 'Температура CPU', values: _serverState.getServer(server.name).map((e) => e.cpuTemp).toList(growable: false))
            : _bigItem(title: 'Температура GPU', values: _serverState.getServer(server.name).map((e) => e.gpuTemp).toList(growable: false)));
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
        builder: (_) => _buildBody(_serverState.servers[widget.serverName]!.last),
      ),
    );
  }
}

class CpuLoad {
  CpuLoad(this.value, this.position);
  final int value;
  final int position;
}
