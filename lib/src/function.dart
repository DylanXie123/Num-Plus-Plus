import 'package:function_tree/function_tree.dart';

class MyFunction {
  
  final String funcExpression;
  MyFunction(this.funcExpression);

  num calc(num x) {
    var f = FunctionOfX(funcExpression);
    return f(x);
  }
}