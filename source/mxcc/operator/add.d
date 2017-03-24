module mxcc.operator.add;
import mxcc.operator.ioperator,
       mxcc.instanceof,
       mxcc.engine,
       mxcc.value;

class AddOperator : IOperator {
  Value call(Engine engine, Value[] args) {
    int tmp;

    foreach (arg; args) {
      Value eargs = engine.eval(arg);
      mixin(caseof!(eargs, Integer, "elem"));
      tmp += elem;
    }

    return new Integer(tmp);
  }
}
