import 'package:function_tree/function_tree.dart';
// Add function support after rewrite parser
class MyFunction {
  
  final String funcExpression;
  MyFunction(this.funcExpression);

  num calc(num x) {
    var f = FunctionOfX(funcExpression);
    return f(x);
  }

  num nsolve() {
    num x0 = 0;
    num x1 = 1;
    num x2 = 1;
    for (var i = 0; i < 100; i++) {
      x2 = x1 - calc(x1)*(x1-x0)/(calc(x1)-calc(x0));
      x0 = x1;
      x1 = x2;
      if ((x2-x1).abs() < 1e-6) {
        print('x1: ' + x1.toString());
        print('x2: ' + x2.toString());
        break;
      }
    }
    return x2;
  }
}