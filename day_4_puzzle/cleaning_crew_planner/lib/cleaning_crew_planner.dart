class CleaningCrewPlanner {
  List<String> crewAssignments;
  List<CrewPair> crewPairs = [];

  CleaningCrewPlanner(this.crewAssignments) {
    parseAssignments();
  }

  int get numberOfFullyOverlappedAssignments {
    return crewPairs.where((pair) => pair.inclusive).length;
  }

  int get numberOfOverlappedAssignments {
    return crewPairs.where((pair) => pair.overlapping).length;
  }

  void parseAssignments() {
    crewAssignments.forEach((assignmentListing) {
      crewPairs.add(CrewPair(assignmentListing));
    });
  }
}

class CrewPair {
  final String assignmentListing;
  final SectionRange crew1Section = SectionRange(0, 0);
  final SectionRange crew2Section = SectionRange(0, 0);
  bool _isOverlapping = false;
  bool _isInclusive = false;

  CrewPair(this.assignmentListing) {
    parseAssignmentListing();
  }

  bool get overlapping {
    return _isOverlapping;
  }

  bool get inclusive {
    return _isInclusive;
  }

  void parseAssignmentListing() {
    final crewRangeIds = assignmentListing.split(",");
    final crewRange1Start = int.parse(crewRangeIds[0].split("-")[0]);
    final crewRange1End = int.parse(crewRangeIds[0].split("-")[1]);
    final crewRange2Start = int.parse(crewRangeIds[1].split("-")[0]);
    final crewRange2End = int.parse(crewRangeIds[1].split("-")[1]);
    crew1Section.start = crewRange1Start;
    crew1Section.end = crewRange1End;
    crew2Section.start = crewRange2Start;
    crew2Section.end = crewRange2End;
    updateRangeFlags();
  }

  void updateRangeFlags() {
    _isInclusive |= crew1Section.start <= crew2Section.start &&
        crew1Section.end >= crew2Section.end;
    _isInclusive |= crew2Section.start <= crew1Section.start &&
        crew2Section.end >= crew1Section.end;
    _isOverlapping |= _isInclusive ||
        (crew1Section.start <= crew2Section.end &&
            crew1Section.end >= crew2Section.start);
    _isOverlapping |= _isInclusive ||
        (crew2Section.start <= crew1Section.end &&
            crew2Section.end >= crew1Section.start);
  }
}

class SectionRange {
  int start = 0;
  int end = 0;

  SectionRange(this.start, this.end);
}
