package ic.doc.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;

public class PDFResultPage implements Page {

    private final String query;
    private final String answer;
    private final Map<String, String> suggestions;

  public PDFResultPage(String query, String answer, Map<String, String> suggestions) {
      this.query = query;
      this.answer = answer;
      this.suggestions = suggestions;
    }

  public void writeTo(HttpServletResponse resp) throws IOException {
    resp.setContentType("application/pdf");
    resp.addHeader("content-disposition", "attachment; filename=\"request.pdf\"");

    File tempFile = File.createTempFile("request", ".md");
    FileWriter fileWriter = new FileWriter(tempFile);
    PrintWriter printWriter = new PrintWriter(fileWriter);

    if (answer.isEmpty()) {
      if (suggestions.isEmpty()) {
        printWriter.printf("Sorry, there were no results for: *%s*.\n\n", query);
      } else {
        printWriter.printf("## Sorry\n\n", query);
        printWriter.printf("Sorry, we didn't understand: *%s*. Maybe these links will help: \n\n", query);
        for (String name : this.suggestions.keySet()) {
          printWriter.printf("- [%s](%s)\n", name, this.suggestions.get(name));
        }
      }
    } else {
      printWriter.printf("# %s\n\n", query);
      printWriter.printf("%s", answer.replace("\n", "\n\n"));
    }

    printWriter.close();
    fileWriter.close();

    Process pandocProcess =  new ProcessBuilder("pandoc", tempFile.getAbsolutePath(),
        "--pdf-engine=xelatex", "-o", "request.pdf").start();

    try {
      System.out.println(pandocProcess.waitFor());
    } catch (InterruptedException e) {
      System.out.println(e);
    }

    tempFile.delete();
    File pdfFile = new File("request.pdf");

    InputStream inStream = new FileInputStream(pdfFile);
    OutputStream outStream = resp.getOutputStream();
    outStream.write(inStream.readAllBytes());

    inStream.close();
    outStream.close();
    pdfFile.delete();
  }
}
