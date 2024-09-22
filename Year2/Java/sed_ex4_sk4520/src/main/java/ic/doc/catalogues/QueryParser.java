package ic.doc.catalogues;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

class QueryParser {

  static Integer publishedAfterFrom(String query) {
    Matcher matcher = Pattern.compile("PUBLISHEDAFTER\\((\\d+)\\)").matcher(query);
    if (matcher.find()) {
      return Integer.parseInt(matcher.group(1));
    }
    return null;
  }

  static Integer publishedBeforeFrom(String query) {
    Matcher matcher = Pattern.compile("PUBLISHEDBEFORE\\((\\d+)\\)").matcher(query);
    if (matcher.find()) {
      return Integer.parseInt(matcher.group(1));
    }
    return null;
  }

  static String titleFrom(String query) {
    Matcher matcher = Pattern.compile("TITLECONTAINS\\((.+?)\\)").matcher(query);
    if (matcher.find()) {
      return matcher.group(1);
    }
    return null;
  }

  static String firstNameFrom(String query) {
    Matcher matcher = Pattern.compile("FIRSTNAME='(\\w+)'").matcher(query);
    if (matcher.find()) {
      return matcher.group(1);
    }
    return null;
  }

  static String lastNameFrom(String query) {
    Matcher matcher = Pattern.compile("LASTNAME='(\\w+)'").matcher(query);
    if (matcher.find()) {
      return matcher.group(1);
    }
    return null;
  }
}
