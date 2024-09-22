package ic.doc;

import java.util.HashMap;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Scanner;

public class QueryProcessor {

    public String process(String query) throws IOException {
        StringBuilder results = new StringBuilder();
        if (query.toLowerCase().contains("shakespeare")) {
            results.append("William Shakespeare (26 April 1564 - 23 April 1616) was an\n" +
                "English poet, playwright, and actor, widely regarded as the greatest\n" +
                "writer in the English language and the world's pre-eminent dramatist. \n");
            results.append(System.lineSeparator());
        } else if (query.toLowerCase().contains("asimov")) {
            results.append("Isaac Asimov (2 January 1920 - 6 April 1992) was an\n" +
                "American writer and professor of Biochemistry, famous for\n" +
                "his works of hard science fiction and popular science. \n");
            results.append(System.lineSeparator());
        } else if (query.toLowerCase().contains("rowling")) {
            results.append("Joanne Rowling, (born 31 July 1965), known by her pen name " +
                "J. K. Rowling, is a British author, philanthropist, film producer, and screenwriter. \n"
                +
                " She is the author of the Harry Potter series, " +
                "which has won multiple awards and sold more than 500 million copies as of 2018 \n");
            results.append(System.lineSeparator());
        }

        return results.toString();
    }

    public Map<String, String> suggestions(String query) throws IOException {
        Map<String, String> results = new HashMap<>();

        // TODO: search wikipedia and return first 5 links
        // example: https://en.wikipedia.org/w/api.php?action=opensearch&search=London&limit=10&format=json
        URL url
          = new URL("https://en.wikipedia.org/w/api.php?action=opensearch&search="
          + query + "&limit=10&format=json");

        Scanner scanner = new Scanner(url.openStream());

        String jsonString = scanner.nextLine();

        System.out.println(jsonString);

        JSONArray jsonArray = new JSONArray(jsonString);

        JSONArray linksArray = (JSONArray) jsonArray.get(3);
        JSONArray namesArray = (JSONArray) jsonArray.get(1);

        for (int i = 0; i < linksArray.length(); i++) {
            results.put((String) namesArray.get(i), (String) linksArray.get(i));
        }

        return results;
    }
}
