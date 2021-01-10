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
  private latex: string = '';

  @observable
  private expression!: nerdamer.Expression;

  @action
  update = (latex: string) => {
    this.latex = latex;
    dis2calc.forEach((v, k) => latex = latex.replace(new RegExp(k, 'g'), v));
    try {
      this.expression = nerdamerAll.convertFromLaTeX(latex) as nerdamer.Expression;
    } catch (error) {
      this.expression = nerdamer('');
    }
  }

  @computed get eval(): string {
    try {
      return this.expression.evaluate().text();
    } catch (error) {
      return 'error';
    }
  }

  @computed get text(): string {
    try {
      // TODO: Implement only here, find a better way to implement to all method
      let result = this.expression.toTeX();
      calc2dis.forEach((v, k) => result = result.replace(new RegExp(k, 'g'), v));
      return result;
    } catch (error) {
      return 'error';
    }
  }

  @computed get mode(): Mode {
    try {
      if (this.latex.search('int') > 0) {
        return Mode.Defint;
      } else if (this.latex.search('limit') > 0) {
        return Mode.Limit;
      } else if (this.latex.search('matrix') > 0) {
        return Mode.Matrix;
      } else if (this.expression.variables().length !== 0) {
        return Mode.Var;
      } else {
        return Mode.Eval;
      }
    } catch (error) {
      return Mode.Eval;
    }
  }

  @computed get solve(): string {
    try {
      return this.expression.solveFor('x').toString();
    } catch (error) {
      return 'error';
    }
  }

  @computed get integrate(): string {
    try {
      return nerdamer.integrate(this.expression, 'x').evaluate().text('fractions');
    } catch (error) {
      return 'error';
    }
  }

  @computed get diff(): string {
    try {
      return nerdamer.diff(this.expression, 'x').evaluate().text('fractions');
    } catch (error) {
      return 'error';
    }
  }
}

export const expStore = new Expression();
export const ExpContext = React.createContext<Expression>(expStore);

// TODO: Need a better way to handle display and calc conversion
// use regexp now
const dis2calc = new Map<string, string>([
  ['\\\\times', '*'],
]);

const calc2dis = new Map<string, string>([
  ['\\\\cdot', '\\times'],
]);

autorun(() => {
  window.variable.postMessage(expStore.mode.valueOf().toString());
})
