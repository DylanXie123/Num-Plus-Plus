import { expStore } from './expression';

describe('function test', () => {

  test('sin', () => {
    expStore.update('\\sin(2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.sin(2));

    // expStore.update('\\sin(45\\degree)');
    // expect(Number(expStore.eval)).toBeCloseTo(Math.sin(Math.PI / 4));
  })

  test('cos', () => {
    expStore.update('\\cos(2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.cos(2));
  })

  test('tan', () => {
    expStore.update('\\tan(2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.tan(2));
  })

  test('arcsin', () => {
    expStore.update('\\arcsin(0.2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.asin(0.2));
  })

  test('arccos', () => {
    expStore.update('\\arccos(0.2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.acos(0.2));
  })

  test('arctan', () => {
    expStore.update('\\arctan(0.2)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.atan(0.2));
  })

  test('ln', () => {
    expStore.update('\\log(e+10)');
    expect(Number(expStore.eval)).toBeCloseTo(Math.log(Math.E + 10));

    // expStore.update('\\ln(e+10)');
    // expect(Number(expStore.eval)).toBeCloseTo(Math.log(Math.E + 10));
  })

  test('lg', () => {
    // expStore.update('\\lg(e+10)');
    // expect(Number(expStore.eval)).toBeCloseTo(Math.log10(Math.E + 10));
  })

  test('sqrt', () => {
    expStore.update('\\sqrt{5}');
    expect(Number(expStore.eval)).toBeCloseTo(Math.sqrt(5));

    // expStore.update('\\sqrt[]{5}');
    // expect(Number(expStore.eval)).toBeCloseTo(Math.sqrt(5));
  })

})

describe('operation test', () => {

  test('plus', () => {
    expStore.update('1+2');
    expect(Number(expStore.eval)).toBeCloseTo(3);
  })

  test('minus', () => {
    expStore.update('1-2');
    expect(Number(expStore.eval)).toBeCloseTo(-1);
  })

  test('times', () => {
    expStore.update('1*2');
    expect(Number(expStore.eval)).toBeCloseTo(2);
    // expStore.update('1\\times 2');
    // expect(Number(expStore.eval)).toBeCloseTo(2);
    expStore.update('1\\cdot 2');
    expect(Number(expStore.eval)).toBeCloseTo(2);
  })

  test('divide', () => {
    expStore.update('\\frac{1}{2}');
    expect(Number(expStore.eval)).toBeCloseTo(1 / 2);
    expStore.update('1/2');
    expect(Number(expStore.eval)).toBeCloseTo(1 / 2);
    // expStore.update('1÷2');
    // expect(Number(expStore.eval)).toBeCloseTo(1 / 2);
  })

  test('exp', () => {
    expStore.update('e^{2}');
    expect(Number(expStore.eval)).toBeCloseTo(Math.pow(Math.E, 2));
  })

})

test('general test', () => {

  expStore.update('e^{2+\\sin(23)}-\\log(\\cos(pi/4))*\\pi+0.1');
  expect(Number(expStore.eval)).toBeCloseTo(4.3589);

  expStore.update('e^{e-2*\\sin(23/\\log(5))}');
  expect(Number(expStore.eval)).toBeCloseTo(2.0997);

  expStore.update('\\sin(e^{pi/3+1}+\\cos(4/4))');
  expect(Number(expStore.eval)).toBeCloseTo(0.9079);

  // expStore.update('3/4/5');
  // expect(Number(expStore.eval)).toBeCloseTo(0.15);

})
