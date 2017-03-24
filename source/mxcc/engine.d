module mxcc.engine;
import mxcc.operator.ioperator,
       mxcc.instanceof,
       mxcc.value;
import mxcc.operator.println,
       mxcc.operator.add;
import std.format;

class Engine {
  Value[string] table;

  this () {
    this.table["+"] = new Operator(new AddOperator);
    this.table["println"] = new Operator(new PrintlnOperator);
  }

  Value eval(Value script) {
    if (instanceof!(Integer, script)) {
      return script;
    } else if (instanceof!(String, script)) {
      return script;
    } else if (instanceof!(Symbol, script)) {
      mixin(caseof!(script, Symbol, "symbol"));

      if (symbol !in this.table) {
        throw new Error("No such a function ore variable - %s".format(symbol));
      }

      return this.table[symbol];
    } else if (instanceof!(Array, script)) {
      Value[] scriptList = script.getValue!(Value[]);

      if (scriptList.length == 0) {
        return new Array;
      }

      if ((cast(Array)scriptList[0]) !is null) {
        string symbol = scriptList[0].getValue!(Value[])[0].getValue!string;

        IOperator operator = this.table[symbol].getValue!IOperator;
        Value[]   args = scriptList[0].getValue!(Value[])[1..$];

        return operator.call(this, args);
      }

      if (scriptList[0].getValue!string in this.table) {
        string symbol = scriptList[0].getValue!string;

        IOperator operator = this.table[symbol].getValue!IOperator;
        Value[]   args = scriptList[1..$];

        return operator.call(this, args);
      }
    }

    throw new Error("Error - script %s".format(script));
  }
}
