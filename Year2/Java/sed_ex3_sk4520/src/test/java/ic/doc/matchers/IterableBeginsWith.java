package ic.doc.matchers;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeDiagnosingMatcher;

/**
 * Custom Hamcrest matcher to match the beginning elements of a possibly infinite iterable.
 *
 * We use this in some of the tests for the Re-use exercise.
 *
 * ##### You should not need to edit this class. #####
 */
public class IterableBeginsWith<T> extends TypeSafeDiagnosingMatcher<Iterable<T>> {

  private final List<T> target;

  @SuppressWarnings(value = "unchecked")
  public IterableBeginsWith(T... elems) {
    target = Arrays.asList(elems);
  }

  @SuppressWarnings(value = "unchecked")
  public static <T> Matcher<? super Iterable<T>> beginsWith(final T... elems) {
    return new IterableBeginsWith<T>(elems);
  }

  @Override
  public void describeTo(Description description) {
    description.appendText("Iterable beginning with: ").appendValue(target);
  }

  @Override
  protected boolean matchesSafely(Iterable<T> iterable, Description mismatchDescription) {
    Iterator<T> iterator = iterable.iterator();
    for (int i = 0; i < target.size(); i++) {
      if (!iterator.hasNext()) {
        mismatchDescription.appendText("not enough items");
        return false;
      }
      T value = iterator.next();
      if (!value.equals(target.get(i))) {
        describeMismatch(mismatchDescription, i, value);
        return false;
      }
    }

    return true;
  }

  private void describeMismatch(Description mismatchDescription, int i, T value) {
    mismatchDescription.appendText("found item ").appendValue(value)
        .appendText(" instead of ").appendValue(target.get(i))
        .appendText(" at position ").appendValue(i);
  }
}
