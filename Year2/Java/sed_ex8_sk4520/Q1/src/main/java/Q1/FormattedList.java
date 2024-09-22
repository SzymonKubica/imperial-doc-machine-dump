package Q1;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FormattedList {

  private List<String> content = new ArrayList<>();
  private ElementFormatter formatter;

  public FormattedList(ElementFormatter formatter, String... items) {
    content.addAll(Arrays.asList(items));
    this.formatter = formatter;
  }

  public void add(String item) {
    content.add(item);
  }

  public void print() {
    System.out.println(formatter.formatHeader());
    for (String item : content) {
      System.out.println(formatter.formatItem(item));
    }
    System.out.println(formatter.formatFooter());
  }
}

