package com.dailymail;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * DO NOT CHANGE THE CODE IN THIS FILE - TAKE IT AS A 3RD PARTY LIBRARY
 */
public class DailyMailArticle {

  private final long time;
  private final String string;
  private final String h;
  private final List<String> paras;

  public DailyMailArticle(Date date, String headline) {
    time = date.getTime();
    string = "A Writer";
    paras = Arrays.asList("Paragraph 1", "Paragraph 2");
    h = headline;
  }

  public String hline() {
    return h;
  }

  public Long timestamp() {
    return time;
  }

  public String author() {
    return string;
  }

  public List<String> body() {
    return paras;
  }
}
