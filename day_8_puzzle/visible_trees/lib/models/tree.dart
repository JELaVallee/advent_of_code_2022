class Tree {
  int columnIdx = -1;
  int rowIdx = -1;
  int height = 0;
  int visibilityScoreToLeft = 0;
  int visibilityScoreToRight = 0;
  int visibilityScoreToAbove = 0;
  int visibilityScoreToBelow = 0;
  bool isHiddenToLeft = false;
  bool isHiddenToRight = false;
  bool isHiddenToAbove = false;
  bool isHiddenToBelow = false;

  Tree(this.columnIdx, this.rowIdx, this.height);

  int get visibilityScore {
    return visibilityScoreToAbove *
        visibilityScoreToLeft *
        visibilityScoreToBelow *
        visibilityScoreToRight;
  }

  bool get isHidden {
    return isHiddenInColumn && isHiddenInRow;
  }

  bool get isHiddenInRow {
    return isHiddenToLeft && isHiddenToRight;
  }

  bool get isHiddenInColumn {
    return isHiddenToAbove && isHiddenToBelow;
  }

  bool get isVisibleFromLeft {
    return !isHiddenToLeft;
  }

  bool get isVisibleFromRight {
    return !isHiddenToRight;
  }

  bool get isVisibleFromAbove {
    return !isHiddenToAbove;
  }

  bool get isVisibleFromBelow {
    return !isHiddenToBelow;
  }

  bool get isVisible {
    return (isVisibleFromAbove || isVisibleFromBelow) ||
        (isVisibleFromLeft || isVisibleFromRight);
  }
}
