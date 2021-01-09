import { observer } from "mobx-react-lite";
import React, { useContext, useEffect, useState } from "react";
import { ExpContext } from "../models/expression";
import MathView from 'react-math-view';

enum DisplayMode {
  Eval,
  Symbolic,
  Plot,
}

const ResultBox = observer(() => {
  const exp = useContext(ExpContext);
  const [display, setDisplay] = useState<DisplayMode>(DisplayMode.Eval);

  useEffect(() => {
    if (exp.variable) {
      setDisplay(DisplayMode.Eval);
    }
  }, [exp.variable]);

  useEffect(() => {
    window.doEvalCalc = () => { setDisplay(DisplayMode.Eval); };
    window.doSymCalc = () => { setDisplay(DisplayMode.Symbolic); };
    window.doPlot = () => { setDisplay(DisplayMode.Plot); };
    console.log('run hook');
  }, []);

  switch (display) {
    case DisplayMode.Eval:
      return (<EvalResultBox />);
    case DisplayMode.Symbolic:
      return (<SymResultBox />);
    case DisplayMode.Plot:
      return (<PlotResultBox />);
    default:
      throw Error('Unknown type');
  }
});

const EvalResultBox = observer(() => {
  const exp = useContext(ExpContext);
  const evalResult = exp.eval;
  const textResult = exp.text;

  if (evalResult === textResult) {
    return (<InfoBox content={`=${evalResult}`} />);
  }

  return (<div>
    <InfoBox content={`=${exp.eval}`} />
    <InfoBox content={`=${exp.text}`} />
  </div>);
});

const SymResultBox = observer(() => {
  const exp = useContext(ExpContext);

  return (<div>
    <InfoBox content={`=${exp.integrate}`} />
    <InfoBox content={`=${exp.diff}`} />
  </div>);
});

const PlotResultBox = observer(() => {
  throw Error('Not implemented yet');
});

interface InfoBoxProp {
  content: string,
}

function InfoBox(prop: InfoBoxProp) {
  return (<MathView
    value={prop.content}
    readOnly={true}
  />);
}

export default ResultBox;