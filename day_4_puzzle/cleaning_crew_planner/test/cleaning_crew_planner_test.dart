import 'dart:io';
import 'package:test/test.dart';
import 'package:cleaning_crew_planner/cleaning_crew_planner.dart';

void main() {
  test(
      'processes the cleaning assignments and get the number of fully-overlapping assignments [test]',
      () {
    final dataMapFile = File("./cleaning_crew_assignments_test.txt");
    List<String> crewAssignments = dataMapFile.readAsLinesSync();

    CleaningCrewPlanner cleaningCrewPlanner =
        CleaningCrewPlanner(crewAssignments);

    expect(cleaningCrewPlanner.numberOfFullyOverlappedAssignments, 2);
  });
  test(
      'processes the cleaning assignments and get the number of fully-overlapping assignments [full]',
      () {
    final dataMapFile = File("./cleaning_crew_assignments_full.txt");
    List<String> crewAssignments = dataMapFile.readAsLinesSync();

    CleaningCrewPlanner cleaningCrewPlanner =
        CleaningCrewPlanner(crewAssignments);

    expect(cleaningCrewPlanner.numberOfFullyOverlappedAssignments, 588);
  });
  test(
      'processes the cleaning assignments and get the number of overlapping assignments [test]',
      () {
    final dataMapFile = File("./cleaning_crew_assignments_test.txt");
    List<String> crewAssignments = dataMapFile.readAsLinesSync();

    CleaningCrewPlanner cleaningCrewPlanner =
        CleaningCrewPlanner(crewAssignments);

    expect(cleaningCrewPlanner.numberOfOverlappedAssignments, 4);
  });
  test(
      'processes the cleaning assignments and get the number of overlapping assignments [full]',
      () {
    final dataMapFile = File("./cleaning_crew_assignments_full.txt");
    List<String> crewAssignments = dataMapFile.readAsLinesSync();

    CleaningCrewPlanner cleaningCrewPlanner =
        CleaningCrewPlanner(crewAssignments);

    expect(cleaningCrewPlanner.numberOfOverlappedAssignments, 588);
  });
}
