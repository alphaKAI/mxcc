module mxcc.parser;
import mxcc.instanceof,
       mxcc.value;
import std.regex,
       std.conv;

enum nrgx = ctRegex!"[0-9]";

static size_t nextBracket(string code) {
  size_t index,
         leftCount = 1,
         rightCount;

  while (leftCount != rightCount) {
    if (code[index] == '(') { leftCount++; }
    if (code[index] == ')') { rightCount++; }
    index++;
  }

  return index;
}

Value[] parse(string code) {
  Value[] ret;

  for (size_t i; i < code.length; i++) {
    dchar ch = code[i];

    if (ch == ' ') {
      continue;
    }

    if (ch == '(') {
      size_t j = nextBracket(code[i+1..$]);

      ret ~= new Array(parse(code[i+1..i+j]));

      i+=j;
      continue;
    }

    if (ch == ')') {
      return ret;
    }

    if (ch.to!string.match(nrgx) ||
        (i + 1 < code.length && ch == '-' && code[i + 1].to!string.match(nrgx))) {
      string tmp;
      size_t j = i;

      do {
        tmp ~= code[j];
        j++;
      } while (
          j < code.length &&
          (code[j] != ' ' && code[j].to!string.match(nrgx)));

      ret ~= new Integer(tmp.to!int);

      i = j - 1;
      continue;
    }

    if (ch == '\'' || ch == '\"') {
      if (ch == '\'' && i + 1 > code.length && code[i + 1] == '(') {
        size_t j = nextBracket(code[i + 2..$]) + 1;

        ret ~= new Array(parse(code[i+2..j+i]));

        i += j;
        continue;
      } else {
        string tmp;
        size_t j = i + 1;

        while (j < code.length && code[j] != ch) {
          if (j < code.length) {
            tmp ~= code[j];
          } else {
            throw new Error("Syntax Error");
          }

          j++;
        }

        ret ~= new String(tmp);
        i = j;
        continue;
      }
    }


    {// else

      string tmp;
      size_t j = i;

      while (
          j < code.length && code[j] != '\"' && code[j] != '\'' &&
          code[j] != '(' && code[j] != ')' && code[j] != ' '
      ) {
        tmp ~= code[j];
        ++j;
      }

      ret ~= new Symbol(tmp);
      i = j;
      continue;
    }
  }

  return ret;
}
