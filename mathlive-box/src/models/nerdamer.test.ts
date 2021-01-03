import nerdamer from 'nerdamer';
const nerdamerAll = require('nerdamer/all');

let expStr = '';

test('basic', () => {

  const testSample: Map<string, number> = new Map([
    ['1+2', 3],
    ['1-2', -1],
    ['1\\cdot 2', 2],
    ['1\\times 2', 2],
    ['1/2', 0.5],
    ['3/4/5', 0.15],
    ['\\sin 2', Math.sin(2)],
    ['\\cos 2', Math.cos(2)],
    ['\\tan 2', Math.tan(2)],
    ['\\asin 0.2', Math.asin(0.2)],
    ['\\acos 0.2', Math.acos(0.2)],
    ['\\atan 0.2', Math.atan(0.2)],
    ['e^2', Math.exp(2)],
    ['\\log 2', Math.log(2)],
    ['\\sqrt{2}', Math.sqrt(2)],
  ]);

  testSample.forEach((result, expStr) => {
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let calcResult = Number(expression.evaluate().text());
    expect(calcResult).toBeCloseTo(result);
  })

})

test('symbolic output', () => {
  
  const testSample: Map<string, string> = new Map([
    ['e+1-1', 'e'],
    ['\\sin{pi/3}', '(1/2)*sqrt(3)'],
    ['4/6', '2/3'],
  ]);

  testSample.forEach((result, expStr) => {
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let calcResult = expression.text('fractions');
    expect(calcResult).toBe(result);
  })

})

describe('function calc', () => {

  test('int', () => {
    expStr = 'x^2';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let integration = nerdamer.integrate(expression, 'x');
    let calcResult = integration.evaluate().text('fractions');
    expect(calcResult).toBe('(1/3)*x^3');
  })

  test('diff', () => {
    expStr = 'x^2';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let integration = nerdamer.diff(expression, 'x');
    let calcResult = integration.evaluate().text('fractions');
    expect(calcResult).toBe('2*x');
  })

  test('defint', () => {
    expStr = 'x^2';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let integration = nerdamerAll(`defint(${expression.evaluate().text()}, 0, 2)`) as nerdamer.Expression;
    let calcResult = integration.evaluate().text('fractions');
    expect(calcResult).toBe('8/3');
  })

  test('simplify', () => {
    expStr = 'a*b+a*c';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let simplify = nerdamerAll(`simplify(${expression.evaluate().text()})`) as nerdamer.Expression;
    let calcResult = simplify.evaluate().text('fractions');
    expect(calcResult).toBe('(b+c)*a');
  })

})

describe('solve', () => {

  test('polynomial', () => {
    expStr = 'x^2+3*x+5';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let calcResult = expression.solveFor('x');
    expect(calcResult.toString()).toBe('(1/2)*i*sqrt(11)-3/2,(-1/2)*i*sqrt(11)-3/2');
  })

})

describe('complex calc', () => {

  test('plus & minus', () => {
    expStr = '1+i+5+i-9-7*i';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let calcResult = expression.evaluate().text();
    expect(calcResult.toString()).toBe('-3-5*i');
  })

  test('times & divide', () => {
    expStr = '(1+2*i)*(4+3*i)/(6+4*i)';
    let expression = nerdamerAll.convertFromLaTeX(expStr) as nerdamer.Expression;
    let calcResult = expression.evaluate().text();
    expect(calcResult.toString()).toBe('(1+2*i)*(3*i+4)*(4*i+6)^(-1)');
  })

})