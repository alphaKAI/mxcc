module mxcc.operator.ioperator;
import mxcc.engine,
       mxcc.value;

interface IOperator {
  Value call(Engine engine, Value[] args);
}
