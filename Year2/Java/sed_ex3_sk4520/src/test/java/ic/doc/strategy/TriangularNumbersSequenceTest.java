package ic.doc.strategy;

import org.junit.Test;
import static ic.doc.matchers.IterableBeginsWith.beginsWith;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

public class TriangularNumbersSequenceTest {

  final TriangularNumbersSequence triangularGenerator
          = new TriangularNumbersSequence();

  final NumbersSequence sequence = new NumbersSequence(triangularGenerator);

  @Test
  public void definesFirstTermToBeOne() {

    assertThat(sequence.term(0), is(1));
  }

  // Triangular Numbers Formula for n+1 term: (n + 1) (n + 2) / 2.
  @Test
  public void definesSubsequentTermsToBeGivenByFormulaAbove() {

    assertThat(sequence.term(1), is(3));
    assertThat(sequence.term(2), is(6));
    assertThat(sequence.term(3), is(10));
    assertThat(sequence.term(4), is(15));
  }

  @Test
  public void isUndefinedForNegativeIndices() {
    SequenceTest.isUndefinedForNegativeIndices(sequence);
  }

  @Test
  public void canBeIteratedThrough() {
    assertThat(sequence, beginsWith(1, 3, 6, 10, 15));
  }

}