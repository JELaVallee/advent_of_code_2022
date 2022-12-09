import 'package:visible_trees/models/tree.dart';

class Grove {
  List<List<int>> dataMap = [];
  List<List<Tree>> treeGridRows = [];
  List<List<Tree>> treeGridColumns = [];
  List<Tree> hiddenTrees = [];
  List<Tree> visibleTrees = [];

  Grove(this.dataMap) {
    parseDataMap();
    determineTreeVisibility();
  }

  Tree get highestVisibilityTree {
    Tree bestViewTree = treeGridRows[0][0];
    int highestVisibility = treeGridRows[0][0].visibilityScore;
    treeGridRows.forEach((treeRow) {
      treeRow.forEach((tree) {
        if (tree.visibilityScore > highestVisibility) {
          bestViewTree = tree;
          highestVisibility = tree.visibilityScore;
        }
      });
    });
    return bestViewTree;
  }

  void parseDataMap() {
    final NUMROWS = dataMap.length;
    final NUMCOLS = dataMap[0].length;

    for (int i = 0; i < NUMROWS; i++) {
      List<Tree> rowOfTrees = [];
      for (int k = 0; k < NUMCOLS; k++) {
        rowOfTrees.insert(k, Tree(k, i, dataMap[i][k]));
      }
      treeGridRows.insert(i, rowOfTrees);
    }

    for (int i = 0; i < NUMCOLS; i++) {
      List<Tree> columnOfTrees = [];
      for (int k = 0; k < NUMROWS; k++) {
        columnOfTrees.insert(k, treeGridRows[k][i]);
      }
      treeGridColumns.insert(i, columnOfTrees);
    }
  }

  void determineTreeVisibility() {
    treeGridRows.forEach((treeRow) {
      treeRow.forEach((treeInRow) {
        if (treeInRow.columnIdx == 0 ||
            treeInRow.columnIdx == treeRow.length - 1) {
          return;
        } else if (treeInRow.rowIdx == 0 ||
            treeInRow.rowIdx == treeGridRows.length - 1) {
          return;
        } else {
          // Actually figure out if this tree is hidden
          final treeColumn = treeGridColumns[treeInRow.columnIdx];
          final treesToLeft = treeRow.sublist(0, treeInRow.columnIdx);
          final treesToRight =
              treeRow.sublist(treeInRow.columnIdx + 1, treeRow.length);
          final treesToAbove = treeColumn.sublist(0, treeInRow.rowIdx);
          final treesToBelow =
              treeColumn.sublist(treeInRow.rowIdx + 1, treeColumn.length);

          treesToLeft.reversed.forEach((testTree) {
            if (!treeInRow.isHiddenToLeft) {
              treeInRow.visibilityScoreToLeft++;
            }
            if (testTree.height >= treeInRow.height) {
              treeInRow.isHiddenToLeft = true;
            }
          });
          treesToRight.forEach((testTree) {
            if (!treeInRow.isHiddenToRight) {
              treeInRow.visibilityScoreToRight++;
            }
            if (testTree.height >= treeInRow.height) {
              treeInRow.isHiddenToRight = true;
            }
          });
          treesToAbove.reversed.forEach((testTree) {
            if (!treeInRow.isHiddenToAbove) {
              treeInRow.visibilityScoreToAbove++;
            }
            if (testTree.height >= treeInRow.height) {
              treeInRow.isHiddenToAbove = true;
            }
          });
          treesToBelow.forEach((testTree) {
            if (!treeInRow.isHiddenToBelow) {
              treeInRow.visibilityScoreToBelow++;
            }
            if (testTree.height >= treeInRow.height) {
              treeInRow.isHiddenToBelow = true;
            }
          });
        }
      });
    });

    treeGridRows.forEach((treeRow) {
      treeRow.forEach((tree) {
        if (tree.isHidden) {
          hiddenTrees.add(tree);
        }
        if (tree.isVisible) {
          visibleTrees.add(tree);
        }
      });
    });
  }
}
