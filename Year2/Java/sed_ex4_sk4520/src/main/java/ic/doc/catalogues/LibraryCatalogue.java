package ic.doc.catalogues;

import ic.doc.Book;

import java.util.List;

public interface LibraryCatalogue {
    public List<Book> searchFor(String query);
}
