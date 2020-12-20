import 'package:charts_flutter/flutter.dart' as charts;
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
    List<charts.Series<Test, double>> _createSampleData() {
      final List<Test> data = [];
      for (int i = 0; i < values.length; i++) {
        data.add(Test(values[i], i));
      }
      return [
        charts.Series<Test, double>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (Test sales, _) => sales.position.toDouble(),
          measureFn: (Test sales, _) => sales.value,
          data: data,
        )
      ];
    }

    List<Test> _createData() {
      final List<Test> data = [];
      for (int i = 0; i < values.length; i++) {
        data.add(Test(values[i], i));
      }
      return data;
    }

    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: MediaQuery.of(context).size.width / 2 - 20,
        child: Stack(
          children: [
            Center(
              //child: charts.LineChart(_createSampleData()),
              child: SfCartesianChart(
                //primaryXAxis: CategoryAxis(),
                //title: ChartTitle(text: 'Half yearly sales analysis'),
                // Enable legend
                primaryXAxis: NumericAxis(interval: 1, majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(majorTickLines: MajorTickLines(color: Colors.transparent), axisLine: AxisLine(width: 0), minimum: 0, maximum: 100),
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <SplineAreaSeries<Test, int>>[
                  SplineAreaSeries<Test, int>(
                    dataSource: _createData(),
                    xValueMapper: (Test test, _) => test.position,
                    yValueMapper: (Test test, _) => test.value,
                    // Enable data label
                    //dataLabelSettings: DataLabelSettings(isVisible: false),
                  )
                ],
              ),
            ),
            Positioned(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
              left: 0,
              right: 0,
            ),
          ],
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _serverState = Provider.of<ServerState>(context);
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

class Test {
  Test(this.value, this.position);
  final double value;
  final int position;
}
