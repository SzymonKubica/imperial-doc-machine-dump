package ic.doc.templatemethod;

public class TriangularNumbersSequence extends NumbersSequence {
  @Override
  public int ithPositiveTerm(int i) {
    if (i < 1) {
      return 1;
    }
    return (i + 1) * (i + 2) / 2;
  }
}
