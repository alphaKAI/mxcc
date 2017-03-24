module mxcc.value;
import mxcc.instanceof,
       mxcc.operator.ioperator;
import std.algorithm,
       std.format,
       std.string;

interface Value {
  string toString();
}

class Array : Value {
  Value[] value;
  this () {}

  this (Value[] value) {
    this.value = value;
  }

  Value opIndex(size_t idx) {
    if (!(idx < this.value.length)) {
      throw new Error("Out of index of the Array, orded - %d but length of the array is %d".format(idx, this.value.length));
    }

    return this.value[idx];
  }

  override string toString() { return "<Array:[%s]>".format(this.value.map!(x => x.toString).join(", ")); }
}

class Integer : Value {
  int value;
  this (int value) {
    this.value = value;
  }

  override string toString() { return "<Integer:%d>".format(this.value); }

  override int opCmp(Object _value) {
    if ((cast(Integer)_value) is null) {
      throw new Error("Can not compare between incompatibility values");
    }

    if ((cast(Integer)_value).value == this.value) { return 0; }
    if ((cast(Integer)_value).value < this.value) { return -1; }
    return 1;
  }

  override bool opEquals(Object _value) {
    if ((cast(Integer)_value) is null) {
      throw new Error("Can not compare between incompatibility values");
    }

    return (cast(Integer)_value).value == this.value;
  }
}

class Operator : Value {
  IOperator value;
  this (IOperator value) {
    this.value = value;
  }
  override string toString() { return "<Operator:%s>".format(value.stringof); }
}

class String : Value {
  string value;
  this (string value) {
    this.value = value;
  }

  override string toString() { return "<String:%s>".format(this.value); }

  override bool opEquals(Object _value) {
    if ((cast(String)_value) is null) {
      throw new Error("Can not compare between incompatibility values");
    }

    return (cast(String)_value).value == this.value;
  }
}

class Symbol : Value {
  string value;
  this (string value) {
    this.value = value;
  }

  override string toString() { return "<Symbol:%s>".format(this.value); }

  override bool opEquals(Object _value) {
    if ((cast(Symbol)_value) is null) {
      throw new Error("Can not compare between incompatibility values");
    }

    return (cast(Symbol)_value).value == this.value;
  }
}

static string getTypeName(Value value) {
  if (instanceof!(Integer, value)) {
    return "<Integer>";
  } else if (instanceof!(Array, value)) {
    return "<Array>";
  } else if (instanceof!(String, value)) {
    return "<String>";
  } else if (instanceof!(Symbol, value)) {
    return "<Symbol>";
  } else if (instanceof!(Operator, value)) {
    return "<Operator>";
  } else {
    return "<Unknown>";
  }
}

static T getValue(T)(Value value) {
  if (value is null) {
    throw new Error("given value is null");
  }

  static if (is(T == int)) {
    if (instanceof!(Integer, value)) {
      mixin(caseof!(value, Integer, "ret"));
      return ret;
    } else {
      throw new Error("Error, expected type is %s but actual type is %s".format("int", getTypeName(value)));      
    }
  }

  static if (is(T == string)) {
    if (instanceof!(String, value)) {
      mixin(caseof!(value, String, "ret"));
      return ret;
    } else if (instanceof!(Symbol, value)) {
      mixin(caseof!(value, Symbol, "ret"));
      return ret;
    } else {
      throw new Error("Error, expected type is %s but actual type is %s".format("string", getTypeName(value)));
    }
  }

  static if (is(T == Value[])) {
    if (instanceof!(Array, value)) {
      mixin(caseof!(value, Array, "ret"));
      return ret;
    } else {
      throw new Error("Error, expected type is %s but actual type is %s".format("Array", getTypeName(value)));      
    }
  }

  static if (is(T == IOperator)) {
    if (instanceof!(Operator, value)) {
      mixin(caseof!(value, Operator, "ret"));
      return ret;
    } else {
      throw new Error("Error, expected type is %s but actual type is %s".format("IOperator", getTypeName(value)));      
    }
  }
}
