package Q1;

import java.util.List;

public class HttpRequestBuilder {
    private String url;
    private HttpRequest.Method method;
    private List<String> params;
    private List<String> headers;
    private String body;

    public HttpRequestBuilder withUrl(String url) {
        this.url = url;
        return this;
    }

    public HttpRequestBuilder withMethod(HttpRequest.Method method) {
        this.method = method;
        return this;
    }

    public HttpRequestBuilder withParams(List<String> params) {
        this.params = params;
        return this;
    }

    public HttpRequestBuilder withHeaders(List<String> headers) {
        this.headers = headers;
        return this;
    }

    public HttpRequestBuilder withBody(String body) {
        this.body = body;
        return this;
    }

    public HttpRequest createHttpRequest() {
        return new HttpRequest(url, method, params, headers, body);
    }
}