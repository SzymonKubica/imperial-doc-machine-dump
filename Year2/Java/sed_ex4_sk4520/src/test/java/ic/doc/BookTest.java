package ic.doc;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class BookTest {

  final Book oliverTwist = new Book("Oliver Twist", "Charles Dickens", 1859);

  @Test
  public void supportsCaseInsensitiveAuthorQuery() {
    assertTrue(oliverTwist.matchesAuthor("Dickens"));
    assertTrue(oliverTwist.matchesAuthor("dickens"));
    assertTrue(oliverTwist.matchesAuthor("charles"));
    assertFalse(oliverTwist.matchesAuthor("Shakespeare"));
    assertTrue(oliverTwist.matchesAuthor(null));
  }

  @Test
  public void supportsCaseInsensitiveTitleQuery() {
    assertTrue(oliverTwist.matchesTitle("Twist"));
    assertTrue(oliverTwist.matchesTitle("twist"));
    assertFalse(oliverTwist.matchesTitle("Cities"));
    assertTrue(oliverTwist.matchesTitle(null));
  }

  @Test
  public void supportsPublicationDataQuery() {
    assertTrue(oliverTwist.publishedBefore(1900));
    assertTrue(oliverTwist.publishedSince(1800));
    assertFalse(oliverTwist.publishedBefore(1800));
    assertFalse(oliverTwist.publishedSince(1900));
  }

  @Test
  public void convertsToFormattedStringOfTitleAndAuthor() {
    assertThat(oliverTwist.toString(), is("Oliver Twist, by Charles Dickens, published 1859"));
  }

}