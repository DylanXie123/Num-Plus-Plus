import { observer } from "mobx-react-lite";
import React, { useContext, useEffect, useState } from "react";
import { ExpContext, Mode } from "../models/expression";
import MathView from 'react-math-view';
import Plot from "./plot";

const ResultBox = observer(() => {
  const exp = useContext(ExpContext);

  switch (exp.mode) {
    case Mode.Eval:
      return (<EvalResultBox />);
    case Mode.Var:
      return (<SymResultBox />);
    case Mode.Matrix:
      return (<MatrixResultBox />);
    default:
      return (<EvalResultBox />);
  }
});

const EvalResultBox = observer(() => {
  const exp = useContext(ExpContext);
  const evalResult = exp.eval;
  const textResult = exp.text;

  if (evalResult === undefined) {
    return <div></div>;
  }

  if (evalResult === textResult) {
    return (<InfoBox content={`=${evalResult}`} />);
  }

  return (<div>
    <InfoBox content={`=${evalResult}`} />
    <InfoBox content={`=${textResult}`} />
  </div>);
});

const MatrixResultBox = observer(() => {
  const exp = useContext(ExpContext);

  useEffect(() => window.invertMatrix = exp.invertMatrix);

  if (exp.text === undefined) {
    return <div></div>;
  }

  return (<InfoBox content={`=${exp.text}`} />);
});

enum SymMode {
  Int,
  Diff,
  Simplify,
  Plot,
}

const SymResultBox = observer(() => {
  const exp = useContext(ExpContext);
  const [mode, setMode] = useState<SymMode>();

  useEffect(() => {
    window.doIntegrate = () => { setMode(SymMode.Int); }
    window.doDiff = () => { setMode(SymMode.Diff); }
    window.doPlot = () => { setMode(SymMode.Plot); }
  }, []);

  if (mode === SymMode.Int) {
    return <InfoBox content={`=${exp.integrate}`} />;
  }

  if (mode === SymMode.Diff) {
    return <InfoBox content={`=${exp.diff}`} />;
  }

  if (mode === SymMode.Plot) {
    return <Plot />;
  }

  return (<div />);
});

interface InfoBoxProp {
  content: string,
  hideAdd?: boolean,
}

// TODO: Auto hide button when content is empty
function InfoBox(prop: InfoBoxProp) {
  return (
    <div style={{ display: 'flex' }}>
      <MathView
        value={prop.content}
        readOnly={true}
        style={{ outline: 0 }}
      >
      </MathView>
      <button
        hidden={prop.hideAdd}
        style={{ height: '50%', marginLeft: '20pt' }}
        onClick={() => {
          window.clear();
          window.add(prop.content.substr(1));
        }}>
        +</button>
    </div>
  );
}

export default ResultBox;