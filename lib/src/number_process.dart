int factorial(String a) {
  int v = int.tryParse(a);
  if (v < 0) {
    throw "Can't do factorial! Input is smaller than 0";
  }
  num result = 1;
  while (v > 1) {
    result *= v;
    v--;
    if (result < 0) {
      throw "Out of range";
    }
  }
  return result;
}

num intCheck(num a) {
  if (a.ceil() == a.floor()) {
    return a.toInt();
  } else {
    return a;
  }
}

List<int> deci2frac(num a) {
  double esp = 1e-10;
  List<int> res = [];
  for (var i = 0; i < 50; i++) {
    int t = a.toInt();
    res.add(t);
    a = a - t;
    while(t > 0) {
      t = t~/10;
      esp *= 10;
    }
    if (a.abs() < esp) {
      return _contfrac2frac(res);
    } else if ((1-a).abs() < esp) {
      res.last += 1;
      return _contfrac2frac(res);
    } else {
      a = 1 / a;
    }
  }
  throw 'Unable to tranfer decimal to frac';
}

List<int> _contfrac2frac(List<int> cont){
  List<int> res = [1, 1];
  res.first = cont.last;
  cont.removeLast();
  for (var i = cont.length; i > 0; i--) {
    res = res.reversed.toList();
    res.first = res.first + res.last * cont.last;
    cont.removeLast();
  }
  return res;
}