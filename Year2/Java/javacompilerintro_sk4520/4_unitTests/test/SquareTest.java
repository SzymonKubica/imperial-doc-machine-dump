import org.junit.Test;

import static org.junit.Assert.*;

public class SquareTest {

  @Test
  public void testZero() {
    assertEquals(  0, Square.getSquare(  0));
  }

  @Test
  public void testPositive() {
    assertEquals(  1, Square.getSquare(  1));
    assertEquals(  4, Square.getSquare(  2));
    assertEquals( 16, Square.getSquare(  4));
    assertEquals(100, Square.getSquare( 10));
  }

  @Test
  public void testNegative() {
    assertEquals(  1, Square.getSquare( -1));
    assertEquals(  4, Square.getSquare( -2));
    assertEquals( 16, Square.getSquare( -4));
    assertEquals(100, Square.getSquare(-10));
  }

}
