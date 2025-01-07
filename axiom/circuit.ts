import {
  CircuitValue,
  CircuitValue256,
  constant,
  add,
  sub,
  mul,
  or,
  checkLessThan,
  div,
  getHeader,
  addToCallback
} from "@axiom-crypto/client";
export interface CircuitInputs {
  startBlock: CircuitValue,
  endBlock: CircuitValue,
  numSamples: CircuitValue
};

export const feeAverage = async ({
  startBlock,
  endBlock,
  numSamples
}: CircuitInputs) => {

  checkLessThan(startBlock, endBlock);

  let totalBlocks = add(sub(endBlock, startBlock), 1);

  checkLessThan(numSamples, totalBlocks);
  checkLessThan(constant(0), numSamples);

  let total = constant(0);

  let _numSamples = numSamples.number();
  const sampleRate = div(totalBlocks, numSamples);

  for (let i = 0; i <= _numSamples; i++) {
    const targetBlock = add(startBlock, mul(i, sampleRate));
    const fee = (await getHeader(targetBlock).baseFeePerGas()).toCircuitValue();
    total = add(total, fee);
  }

  const avg = div(total, numSamples);
  addToCallback(avg);
  addToCallback(startBlock);
  addToCallback(endBlock);
  addToCallback(numSamples);
};
