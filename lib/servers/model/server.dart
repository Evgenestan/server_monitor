class Server {
  String name;
  List<double> cpuTemps = [];
  List<double> cpuFans = [];
  List<double> gpuTemps = [];
  List<double> gpuFans = [];
  List<double> motherFans = [];
  List<double> cpuLoads = [];
  List<double> gpuLoads = [];
  List<DateTime> createTimes = [];

  int cpuTemp;
  int gpuTemp;
  int cpuFan;
  int gpuFan;
  int motherFan;
  int cpuLoad;
  int gpuLoad;
}
