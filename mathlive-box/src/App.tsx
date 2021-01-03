import React from 'react';
import MathBox from './components/MathBox';
import ResultBox from './components/ResultBox';
import  { ControllerContext, controller } from './models/controller';
import { ExpContext, expStore } from './models/expression';

export default function App() {
  return (
    <ControllerContext.Provider value={controller}>
      <ExpContext.Provider value={expStore}>
        <MathBox />
        <ResultBox />
      </ExpContext.Provider>
    </ControllerContext.Provider>
  );
}
