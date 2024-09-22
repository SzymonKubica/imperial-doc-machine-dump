package com.dailymail;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * DO NOT CHANGE THE CODE IN THIS FILE - TAKE IT AS A 3RD PARTY LIBRARY
 */
@SuppressWarnings("deprecation")
public class DailyMail {

  private static final DailyMailArticle article1 = new DailyMailArticle(new Date(2018, 03, 14), "Article 1");
  private static final DailyMailArticle article2 = new DailyMailArticle(new Date(2018, 02, 14), "Article 2");

  public static List<DailyMailArticle> getArticles() {
    return Arrays.asList(article1, article2);
  }
}
