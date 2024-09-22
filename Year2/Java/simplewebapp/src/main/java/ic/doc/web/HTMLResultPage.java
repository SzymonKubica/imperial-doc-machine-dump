package ic.doc.web;

import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class HTMLResultPage implements Page {

    private final String query;
    private final String answer;
    private final Map<String, String> suggestions;

    public HTMLResultPage(String query, String answer, Map<String, String> suggestions) {
        this.query = query;
        this.answer = answer;
        this.suggestions = suggestions;
    }

    public void writeTo(HttpServletResponse resp) throws IOException {
        resp.setContentType("text/html");
        PrintWriter writer = resp.getWriter();

        // Header
        writer.println("<html>");
        writer.println("<head><title>" + query + "</title></head>");
        writer.println("<body>");

        // Content
        if (answer.isEmpty()) {
            if (suggestions.isEmpty()) {
              writer.println("<h1>Sorry</h1>");
              writer.println("<p>Sorry, there were no results for <em>" + query + "</em>.</p>");
            } else {
              writer.println("<h1>Sorry</h1>");
              writer.println("<p>Sorry, we couldn't find <em>" + query + "</em>. Perhaps one of " +
                  "the following links will help:</p><br><ul>");
              for (String name : this.suggestions.keySet()) {
                  writer.println("<li><a href='" + this.suggestions.get(name) + "'>" + name + "</a></li>");
              }
              writer.println("</ul>");
            }
        } else {
            writer.println("<h1>" + query + "</h1>");
            writer.println("<p>" + answer.replace("\n", "<br>") + "</p>");
        }

        writer.println("<p><a href=\"/\">Back to Search Page</a></p>");

        // Footer
        writer.println("</body>");
        writer.println("</html>");
    }
}
