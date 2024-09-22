package Q1;

import java.util.List;

public class HttpRequest {

  private final String url;
  private final String body;
  private final List<String> params;
  private final Method method;
  private final List<String> headers;

  public HttpRequest(String url, Method method, List<String> params, List<String> headers, String body) {
    this.url = url;
    this.body = body;
    this.params = params;
    this.method = method;
    this.headers = headers;
  }

  public enum Method {
    GET,
    PUT,
    POST,
    HEAD,
    DELETE
  }

  // more code here - not relevant for exam question

}

