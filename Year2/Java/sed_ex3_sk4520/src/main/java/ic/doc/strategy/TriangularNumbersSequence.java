package ic.doc.strategy;

import java.util.Iterator;

public class TriangularNumbersSequence implements SequenceGenerator {
  public int ithPositiveTerm(int i) {
    if (i < 1) {
      return 1;
    }
    return (i + 1) * (i + 2) / 2;
  }
}
