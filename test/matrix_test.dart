import 'package:flutter_test/flutter_test.dart';
import 'package:num_plus_plus/src/latex.dart';

void main() {
  test('Test', () {
    final str = r'\begin{bmatrix}4+5&2\\\sin\left(86\right)&6\end{bmatrix}';
    final mp = MatrixParser(str);
    print(mp.parse());
    // List<double> l = [0.5,0.0,0.0,0.0,0.0,0.3333333432674408,0.0,0.0,0.0,0.0,0.25,0.0,0.0,0.0,0.0,1.0];
    // Matrix4 t = Matrix4.fromList(l);
    // print(Matrix4.inverted(t));
  });

}
