package ic.doc;

import ic.doc.web.HTMLResultPage;
import ic.doc.web.IndexPage;
import ic.doc.web.PDFResultPage;
import ic.doc.web.Page;
import java.util.Map;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.servlet.ServletHolder;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class WebServer {

    public WebServer() throws Exception {
        Server server = new Server(Integer.valueOf(System.getenv("PORT")));

        ServletHandler handler = new ServletHandler();
        handler.addServletWithMapping(new ServletHolder(new Website()), "/*");
        server.setHandler(handler);

        server.start();
    }

    static class Website extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
            String query = req.getParameter("q");
            if (query == null) {
                new IndexPage().writeTo(resp);
            } else {
                String type = req.getParameter("type");
                String answer = new QueryProcessor().process(query);
                Map<String, String> suggestions = new QueryProcessor().suggestions(query);
                Page resultPage = (type.equals("PDF"))
                        ? new PDFResultPage(query, answer, suggestions)
                        : new HTMLResultPage(query, answer, suggestions);
                resultPage.writeTo(resp);
            }
        }
    }

    public static void main(String[] args) throws Exception {
        new WebServer();
    }
}

