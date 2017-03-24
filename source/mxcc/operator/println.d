module mxcc.operator.println;
import mxcc.operator.ioperator,
       mxcc.instanceof,
       mxcc.engine,
       mxcc.value;
import std.algorithm,
       std.string;
import std.stdio;

class PrintlnOperator : IOperator {
  public Value call(Engine engine, Value[] args) {
    foreach (arg; args) {
      Value item = engine.eval(arg);

      if (instanceof!(Array, item)) {
        write("(");
        write(item.getValue!(Value[]).map!(e => e.toString).join(" "));
        write(")");
      } else {
        write(item.toString());
      }
    }

    writeln;

    return new Integer(0);
  }
}
