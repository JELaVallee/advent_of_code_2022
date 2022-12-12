class ClimbPathFinder {
  final List<String> topologyMapData;
  ClimbPathFinder(this.topologyMapData);

  ClimbPath get optimalPath {
    return ClimbPath();
  }
}

class ClimbPath {
  int get numberOfSteps {
    return 0;
  }
}

class PathSteps {}
