package Q1;

import com.dailymail.DailyMail;

import java.util.List;
import java.util.stream.Collectors;

public class DailyMailAdapter implements NewsProvider {

    @Override
    public List<Article> getArticles() {
        return DailyMail.getArticles().stream().map(DailyMailArticleAdapter::new).collect(Collectors.toList());
    }
}
