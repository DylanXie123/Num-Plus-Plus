import 'package:flutter_test/flutter_test.dart';
import 'package:num_plus_plus/src/latex.dart';
import 'package:ml_linalg/linalg.dart';

void main() {
  test('Parser Test', () {
    const matrixString = r'\begin{bmatrix}1&2\\3&4\end{bmatrix}\div2';
    MatrixParser mp = MatrixParser(matrixString);
    Iterable res = mp.parse();
    print(res);
  });
  test('Test', () {
    final matrix = Matrix.fromList([
      [1.0, 2.0, 3.0, 4.0],
      [5.0, 6.0, 7.0, 8.0],
      [9.0, .0, -2.0, -3.0],
    ]);
    var temp = matrix.toList();
    List rows = List(temp.length);
    for (var i = 0; i < temp.length; i++) {
      rows[i] = temp[i].join('&');
    }
    print(rows);
  });

}
