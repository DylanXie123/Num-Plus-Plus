import React from 'react';
import MathBox from './components/MathBox';
import ResultBox from './components/ResultBox';
import { ExpContext, expStore } from './models/expression';

export default function App() {
  return (
    <ExpContext.Provider value={expStore}>
      <MathBox />
      <ResultBox />
      <button onClick={() => window.add('\\left[\\begin{matrix} 2 & 3 \\\\ 4 & 7 \\end{matrix}\\right]')}>Test</button>
    </ExpContext.Provider>
  );
}
