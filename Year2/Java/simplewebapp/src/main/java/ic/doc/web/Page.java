package ic.doc.web;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public interface Page {

    void writeTo(HttpServletResponse resp) throws IOException;
}
