package ic.doc;

public class BookSearchQueryBuilder {
    private String name1;
    private String name2;
    private String title;
    private Integer date1;
    private Integer date2;

    public BookSearchQueryBuilder withName1(String name1) {
        this.name1 = name1;
        return this;
    }

    public BookSearchQueryBuilder withName2(String name2) {
        this.name2 = name2;
        return this;
    }

    public BookSearchQueryBuilder withTitle(String title) {
        this.title = title;
        return this;
    }

    public BookSearchQueryBuilder withDate1(Integer date1) {
        this.date1 = date1;
        return this;
    }

    public BookSearchQueryBuilder withDate2(Integer date2) {
        this.date2 = date2;
        return this;
    }

    public BookSearchQuery build() {
        return new BookSearchQuery(name1, name2, title, date1, date2);
    }

}
