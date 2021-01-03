import { Mathfield } from 'mathlive/dist/public/mathfield'

export default class Controller {
  private mfController!: Mathfield;

  setController = (mf: Mathfield) => {
    this.mfController = mf;
    this.focus();
  }

  add = (expression: string) => this.mfController.insert(expression, { focus: true, format: "latex" });

  backspace = () => {
    this.mfController.executeCommand("deletePreviousChar");
    this.focus();
  }

  clear = () => {
    this.mfController.executeCommand("deleteAll");
    this.focus();
  }

  private focus = () => {
    if (this.mfController && this.mfController.focus) {
      this.mfController.focus!();
    }
  }
}