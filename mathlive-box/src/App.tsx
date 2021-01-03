import React from 'react';
import MathBox from './components/MathBox';
import ResultBox from './components/ResultBox';
import { ExpContext, expStore } from './models/expression';

export default function App() {
  return (
    <ExpContext.Provider value={expStore}>
      <MathBox />
      <ResultBox />
    </ExpContext.Provider>
  );
}
