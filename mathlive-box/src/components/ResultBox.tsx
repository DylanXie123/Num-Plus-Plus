import { observer } from "mobx-react-lite";
import React, { useContext } from "react";
import { ExpContext } from "../models/expression";
import MathView from 'react-math-view';
import { Container, List } from "@material-ui/core";

const ResultBox = observer(() => {
  const exp = useContext(ExpContext);
  console.log(exp.latex);

  return (<List>
    <MathView
      value={exp.latex}
      readOnly={true}
    />
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
  </List>);
});

interface InfoBoxProp {
  title: string,
  content: string,
}

function InfoBox(prop: InfoBoxProp) {
  return (<Container>
    <p>{prop.title}</p>
    <MathView
      value={prop.content}
      readOnly={true}
    />
  </Container>);

}

export default ResultBox;