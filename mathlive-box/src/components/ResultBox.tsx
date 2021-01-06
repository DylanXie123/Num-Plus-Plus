import { observer } from "mobx-react-lite";
import React, { useContext } from "react";
import { ExpContext } from "../models/expression";
import MathView from 'react-math-view';

const ResultBox = observer(() => {
  const exp = useContext(ExpContext);
  console.log(exp.latex);

  return (<div>
    <InfoBox
      title={'Eval'}
      content={exp.eval}
    />
    <InfoBox
      title={'Text'}
      content={exp.text}
    />
    <InfoBox
      title={'Roots'}
      content={exp.solve}
    />
    <InfoBox
      title={'Int'}
      content={exp.integrate}
    />
    <InfoBox
      title={'Diff'}
      content={exp.diff}
    />
  </div>);
});

interface InfoBoxProp {
  title: string,
  content: string,
}

function InfoBox(prop: InfoBoxProp) {
  return (<div>
    <p>{prop.title}</p>
    <MathView
      value={prop.content}
      readOnly={true}
    />
  </div>);

}

export default ResultBox;