package ic.doc.strategy;

import static ic.doc.matchers.IterableBeginsWith.beginsWith;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;

import org.junit.Test;

public class FibonacciSequenceTest {

  final FibonacciSequence fibonacciGenerator = new FibonacciSequence();

  final NumbersSequence sequence = new NumbersSequence(fibonacciGenerator);

  @Test
  public void definesFirstTwoTermsToBeOne() {

    assertThat(sequence.term(0), is(1));
    assertThat(sequence.term(1), is(1));
  }

  @Test
  public void definesSubsequentTermsToBeTheSumOfThePreviousTwo() {

    assertThat(sequence.term(2), is(2));
    assertThat(sequence.term(3), is(3));
    assertThat(sequence.term(4), is(5));
  }

  @Test
  public void isUndefinedForNegativeIndices() {
    SequenceTest.isUndefinedForNegativeIndices(sequence);
  }

  @Test
  public void canBeIteratedThrough() {
    assertThat(sequence, beginsWith(1, 1, 2, 3, 5));
  }

}

