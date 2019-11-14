import 'package:flutter_test/flutter_test.dart';
import 'package:linalg/linalg.dart';

import 'package:num_plus_plus/src/backend/latex.dart';

void main() {
  test('Parser Test', () {
    const matrixString1 = r'\begin{bmatrix}1&2\\3&4\end{bmatrix}\begin{bmatrix}1&2\\3&4\end{bmatrix}';
    MatrixParser mp = MatrixParser(matrixString1);
    Matrix res = mp.parse();
    print(res);

    const matrixString2 = r'\begin{bmatrix}1&2\\3&4\end{bmatrix}\div\begin{bmatrix}1&2\\3&4\end{bmatrix}';
    mp = MatrixParser(matrixString2);
    res = mp.parse();
    print(res);
  });
  test('Test', () {
    final matrix = Matrix([
      [1.0, 2.0, 3.0, 4.0],
      [5.0, 6.0, 7.0, 8.0],
      [9.0, .0, -2.0, -3.0],
    ]);
    print(matrix);
  });

}
