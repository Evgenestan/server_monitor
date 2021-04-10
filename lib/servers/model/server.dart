class Server {
  String name = '';
  List<double> cpuTemps = [];
  List<double> cpuFans = [];
  List<double> gpuTemps = [];
  List<double> gpuFans = [];
  List<double> motherFans = [];
  List<double> cpuLoads = [];
  List<double> gpuLoads = [];
  List<DateTime> createTimes = [];

  int cpuTemp = 0;
  int gpuTemp = 0;
  int cpuFan = 0;
  int gpuFan = 0;
  int motherFan = 0;
  int cpuLoad = 0;
  int gpuLoad = 0;

  String host = '';
}
