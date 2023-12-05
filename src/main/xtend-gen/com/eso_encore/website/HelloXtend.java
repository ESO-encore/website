package com.eso_encore.website;

import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.InputOutput;

@SuppressWarnings("all")
public class HelloXtend {
  public static void main(final String[] args) {
    InputOutput.<CharSequence>println(HelloXtend.getMessage());
  }

  public static CharSequence getMessage() {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("Hello Xtend!");
    return _builder;
  }
}
