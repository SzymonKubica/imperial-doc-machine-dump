package ic.doc.strategy;

import java.util.Iterator;

public class FibonacciSequence implements SequenceGenerator {

  public int ithPositiveTerm(int i) {
    if (i < 2) {
      return 1;
    }
    return ithPositiveTerm(i - 1) + ithPositiveTerm(i - 2);
  }

 }

