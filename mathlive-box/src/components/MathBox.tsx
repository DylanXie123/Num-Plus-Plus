import React, { useContext } from "react";
import { ExpContext } from "../models/expression";
import { ControllerContext } from '../models/controller';
import MathView from "react-math-view";

export default function MathBox() {
  const exp = useContext(ExpContext);
  const controller = useContext(ControllerContext);

  return (
    <MathView
      virtualKeyboardMode='off'
      onContentDidChange={(mf) => exp.update(mf.getValue("latex-expanded"))}
      ref={(mfe) => {
        if (mfe) {
          controller.setController(mfe!);
        }
      }}
    />
  );
}