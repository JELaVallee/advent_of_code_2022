class Tree {
  int columnIdx = -1;
  int rowIdx = -1;
  int height = 0;
  bool isHiddenToLeft = false;
  bool isHiddenToRight = false;
  bool isHiddenToAbove = false;
  bool isHiddenToBelow = false;

  Tree(this.columnIdx, this.rowIdx, this.height);

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
