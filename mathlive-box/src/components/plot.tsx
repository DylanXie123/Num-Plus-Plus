import React, { useContext, useEffect, useRef } from 'react'
import functionPlot from 'function-plot';
import { ExpContext } from '../models/expression';
import { observer } from 'mobx-react';

const Plot = observer(() => {
  const fn = useContext(ExpContext);
  const rootEl = useRef(null);
  const options = {
    target: "",
    width: 800,
    height: 500,
    yAxis: { domain: [-1.2, 1.2] },
    grid: true,
    data: [{
      fn: fn?.text,
    }]
  };

  useEffect(() => {
    try {
      functionPlot(Object.assign({}, options, { target: rootEl.current }))
    } catch (e) { }
  })

  return (<div ref={rootEl} />)
})

export default Plot;