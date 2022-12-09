import 'package:visible_trees/models/grove.dart';
import 'package:test/test.dart';

void main() {
  test('grove tree visibility', () {
    final dataMap = [
      [3, 0, 3, 7, 3],
      [2, 5, 5, 1, 2],
      [6, 5, 3, 3, 2],
      [3, 3, 5, 4, 9],
      [3, 5, 3, 9, 0],
    ];

    // Initialize a Grove with the provided datamap
    final treeGrove = Grove(dataMap);
    expect(treeGrove.visibleTrees.length, 21);
    expect(treeGrove.hiddenTrees.length, 4);
  });
}
