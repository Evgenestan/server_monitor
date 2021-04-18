class ServerDate {
  String name = '';
  int cpuTemp = 0;
  int gpuTemp = 0;
  int cpuFan = 0;
  int gpuFan = 0;
  int motherFan = 0;
  int cpuLoad = 0;
  int gpuLoad = 0;
  DateTime createTime = DateTime.fromMicrosecondsSinceEpoch(0);

  String host = '';
}
