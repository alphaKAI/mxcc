module app;
import mxcc.engine,
       mxcc.parser,
       mxcc.value;

unittest {
  auto x = parse("(+ 1 2)");
  auto y = new Array(x);
  Engine e = new Engine;
  assert(e.eval(y) == new Integer(3));
}

void main() {
  auto x = parse("(println (+ 1 2))");
  auto y = new Array(x);
  Engine e = new Engine;
  e.eval(y);
}
