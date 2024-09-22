package Q1;

import com.dailymail.DailyMailArticle;

import java.util.List;

public class DailyMailArticleAdapter implements Article{
    private final DailyMailArticle article;

    public DailyMailArticleAdapter(DailyMailArticle article) {
       this.article = article;
    }

    @Override
    public String hline() {
        return article.hline();
    }

    @Override
    public Long timestamp() {
        return article.timestamp();
    }

    @Override
    public String author() {
        return article.author();
    }

    @Override
    public List<String> body() {
        return article.body();
    }
}
