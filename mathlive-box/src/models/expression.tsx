import { action, autorun, computed, observable } from "mobx";
import React from "react";
import nerdamer from 'nerdamer';
const nerdamerAll = require('nerdamer/all');

export enum Mode {
  Eval = 0,
  Var,
  Defint,
  Limit,
  Matrix,
};

export default class Expression {
  @observable
  private latex: string = '';

  @observable
  private expression: nerdamer.Expression | undefined = undefined;

  @action
  update = (latex: string) => {
    try {
      if (latex.length === 0) {
        // empty input cause error in integrate & diff
        this.latex = '';
        this.expression = undefined;
        return;
      } else if (latex.search('matrix') >= 0) {
        this.latex = this.handleMatrix(latex);
      } else {
        this.latex = this.replaceInput(latex);
      }
      this.expression = nerdamerAll.convertFromLaTeX(latex) as nerdamer.Expression;
    } catch (error) {
      this.expression = undefined;
    }
  }

  private replaceInput(latex: string) {
    dis2calc.forEach((v, k) => latex = latex.replace(k, v));
    return latex;
  }

  private handleMatrix(latex: string) {
    latex = this.replaceInput(latex);
    let matrixList = latex.split(/\\\\|&/);
    matrixList[0] = matrixList[0].slice(15);
    matrixList[matrixList.length - 1] = matrixList[matrixList.length - 1].slice(0, matrixList[matrixList.length - 1].length - 13);
    const n = Math.sqrt(matrixList.length);
    const rows = Array.from(Array(n).keys());
    let matrixExp = rows.map((v) => `[${matrixList.slice(v * n, (v + 1) * n).join()}]`).join();
    return `matrix(${matrixExp})`;
  }

  @computed get eval() {
    try {
      return this.expression?.evaluate().text();
    } catch (error) {
      return undefined;
    }
  }

  @computed get text() {
    try {
      // TODO: Implement only here, find a better way to implement to all method
      let result = this.expression?.toTeX();
      calc2dis.forEach((v, k) => result = result?.replace(k, v));
      return result;
    } catch (error) {
      return undefined;
    }
  }

  // TODO: Move this to input part
  @computed get mode(): Mode {
    try {
      if (this.latex.search('int') >= 0) {
        return Mode.Defint;
      } else if (this.latex.search('limit') >= 0) {
        return Mode.Limit;
      } else if (this.latex.search('matrix') >= 0) {
        return Mode.Matrix;
      } else if (this.latex.search('x') >= 0) {
        return Mode.Var;
      } else {
        return Mode.Eval;
      }
    } catch (error) {
      return Mode.Eval;
    }
  }

  @computed get solve() {
    try {
      return this.expression?.solveFor('x').toTeX();
    } catch (error) {
      return undefined;
    }
  }

  @computed get integrate() {
    if (this.expression === undefined) {
      return undefined;
    }
    try {
      // take undefined input will return undefined*x
      return nerdamer.integrate(this.expression!, 'x').toTeX();
    } catch (error) {
      return undefined;
    }
  }

  @computed get diff() {
    if (this.expression === undefined) {
      return undefined;
    }
    try {
      return nerdamer.diff(this.expression!, 'x').toTeX();
    } catch (error) {
      return undefined;
    }
  }

  @action
  invertMatrix = () => {
    try {
      this.expression = nerdamerAll(`invert(${this.latex})`) as nerdamer.Expression;
    } catch (error) {
      this.expression = undefined;
    }
  }
}

export const expStore = new Expression();
export const ExpContext = React.createContext<Expression>(expStore);

// TODO: Need a better way to handle display and calc conversion
// use regexp now
const dis2calc = new Map<RegExp, string>([
  [RegExp(/\s+/g), ''],
  [RegExp('\\\\times', 'g'), '*'],
  [RegExp('\\\\div', 'g'), '/'],
  [RegExp('\\\\arcsin', 'g'), '\\asin'],
  [RegExp('\\\\arccos', 'g'), '\\acos'],
  [RegExp('\\\\arctan', 'g'), '\\atan'],
  [RegExp('\\\\sqrt\\[\\]', 'g'), '\\sqrt'],
]);

const calc2dis = new Map<RegExp, string>([
  [RegExp('\\\\cdot', 'g'), '\\times'],
]);

autorun(() => {
  window.variable.postMessage(expStore.mode.valueOf().toString());
})
