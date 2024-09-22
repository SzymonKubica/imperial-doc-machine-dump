package Q1;

public class HtmlFormatter implements ElementFormatter {

  @Override
  public String formatHeader() {
    return "<ul>";
  }

  @Override
  public String formatItem(String item) {
    return "  <li>" + item + "</li>";
  }

  @Override
  public String formatFooter() {
    return "</ul>";
  }
}
