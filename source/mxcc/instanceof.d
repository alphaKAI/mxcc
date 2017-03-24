module mxcc.instanceof;
import std.algorithm,
       std.traits,
       std.format,
       std.range,
       std.array;

bool instanceof(alias Type, alias Variable)() {
  return (cast(Type)Variable) !is null;
}

string caseof(alias instance, Type, Variables...)() {
  string code =
    q{assert (instanceof!(%s, %s),
              "Type doesn't match, caseof expects that the variable `instance` is typed as %s, but given `instance` is not an instance of %s");}
    .format(Type.stringof, instance.stringof, Type.stringof, Type.stringof);
  string[] vtypes;
  string[] vnames_type;
  string[] vnames_req;

  foreach (vtype; Fields!Type) {
    vtypes ~= vtype.stringof;
  }

  foreach (vname; FieldNameTuple!Type) {
    vnames_type ~= vname;
  }

  foreach (variable; Variables) {
    vnames_req ~= variable;
  }

  foreach (vtype, vname_type, vname_req; zip(vtypes, vnames_type, vnames_req)) {
    code ~= "%s %s = (cast(%s)%s).%s;".format(vtype, vname_req, Type.stringof, instance.stringof, vname_type);
  }

  return code;
}

