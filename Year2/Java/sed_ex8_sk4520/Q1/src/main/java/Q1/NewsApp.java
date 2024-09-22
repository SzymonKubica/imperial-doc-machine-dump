package Q1;

import java.util.List;

import static java.util.Comparator.comparing;

public class NewsApp {

  public static void main(String[] args) {
    new NewsApp().latestStories().forEach(a -> System.out.println(a.hline()));
  }

  public List<Article> latestStories () {

    List<Article> articles = new DailyMailAdapter().getArticles();

    articles.sort(comparing(Article::timestamp).reversed());

    return articles;
  }
}


