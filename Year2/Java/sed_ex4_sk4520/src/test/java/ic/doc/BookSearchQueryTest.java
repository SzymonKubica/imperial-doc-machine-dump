package ic.doc;

import java.util.List;

import ic.doc.catalogues.LibraryCatalogue;
import org.jmock.Expectations;
import org.jmock.integration.junit4.JUnitRuleMockery;
import org.junit.Rule;
import org.junit.Test;

public class BookSearchQueryTest {

  @Rule
  public JUnitRuleMockery context = new JUnitRuleMockery();

  LibraryCatalogue catalogue = context.mock(LibraryCatalogue.class);


  @Test
  public void searchesForBooksInLibraryCatalogueByAuthorSurname() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("LASTNAME='dickens' ");
    }});

    List<Book> books = new BookSearchQueryBuilder().withName2("dickens").build().execute(catalogue);
  }

  @Test
  public void searchesForBooksInLibraryCatalogueByAuthorFirstname() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("FIRSTNAME='Jane' ");
    }});

    List<Book> books = new BookSearchQueryBuilder().withName1("Jane").build().execute(catalogue);

  }

  @Test
  public void searchesForBooksInLibraryCatalogueByTitle() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("TITLECONTAINS(Two Cities) ");
    }});
    List<Book> books =
            new BookSearchQueryBuilder().withTitle("Two Cities").build().execute(catalogue);

  }

  @Test
  public void searchesForBooksInLibraryCatalogueBeforeGivenPublicationYear() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("PUBLISHEDBEFORE(1700) ");
    }});

    List<Book> books =
            new BookSearchQueryBuilder().withDate2(1700).build().execute(catalogue);
  }

  @Test
  public void searchesForBooksInLibraryCatalogueAfterGivenPublicationYear() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("PUBLISHEDAFTER(1950) ");
    }});

    List<Book> books =
            new BookSearchQueryBuilder().withDate1(1950).build().execute(catalogue);
  }

  @Test
  public void searchesForBooksInLibraryCatalogueWithCombinationOfParameters() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("LASTNAME='dickens' PUBLISHEDBEFORE(1840) ");
    }});

    List<Book> books = new BookSearchQueryBuilder().withName2("dickens")
                                                   .withDate2(1840)
                                                   .build()
                                                   .execute(catalogue);

  }

  @Test
  public void searchesForBooksInLibraryCatalogueWithCombinationOfTitleAndOtherParameters() {

    context.checking(new Expectations() {{
      oneOf(catalogue).searchFor("TITLECONTAINS(of) PUBLISHEDAFTER(1800) PUBLISHEDBEFORE(2000) ");
    }});

    List<Book> books = new BookSearchQueryBuilder().withTitle("of")
                                                   .withDate1(1800)
                                                   .withDate2(2000)
                                                   .build()
                                                   .execute(catalogue);
  }
}
