package ic.doc;

public class Book {

  private final String title;
  private final String author;
  private final int published;

  public Book(String title, String author, int published) {
    this.title = title;
    this.author = author;
    this.published = published;
  }

  public boolean matchesAuthor(String author) {
    return author == null || (this.author.toLowerCase().contains(author.toLowerCase()));
  }

  public boolean publishedBefore(Integer year) {
    return year == null || (this.published < year);
  }

  public boolean publishedSince(Integer year) {
    return year == null || (this.published > year);
  }

  public boolean matchesTitle(String title) {
    return title == null || (this.title.toLowerCase().contains(title.toLowerCase()));
  }

  @Override
  public String toString() {
    return String.format("%s, by %s, published %d", title, author, published);
  }
}
