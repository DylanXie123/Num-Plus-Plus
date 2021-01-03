import React, { useContext } from "react";
import { ExpContext } from "../models/expression";
import Controller from '../models/controller';
import MathView from "react-math-view";

export default function MathBox() {
  const exp = useContext(ExpContext);
  const controller = new Controller();

  return (
    <MathView
      virtualKeyboardMode='off'
      onContentDidChange={(mf) => exp.update(mf.getValue("latex-expanded"))}
      ref={(mfe) => {
        if (mfe) {
          controller.setController(mfe!);
          window.add = controller.add;
          window.backspace = controller.backspace;
          window.clear = controller.clear;
        }
      }}
    />
  );
}