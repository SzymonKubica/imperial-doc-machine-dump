package ic.doc.templatemethod;

import static ic.doc.matchers.IterableBeginsWith.beginsWith;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.junit.Assert.fail;

import org.junit.Test;

public class FibonacciSequenceTest {

  final NumbersSequence sequence = new FibonacciSequence();

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
    try {
      sequence.term(-1);
      fail("should have thrown exception");
    } catch (IllegalArgumentException e) {
      assertThat(e.getMessage(), containsString("Not defined for indices < 0"));
    }
  }

  @Test
  public void canBeIteratedThrough() {
    assertThat(sequence, beginsWith(1, 1, 2, 3, 5));
  }

}