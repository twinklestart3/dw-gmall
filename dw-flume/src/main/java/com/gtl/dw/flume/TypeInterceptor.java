package com.gtl.dw.flume;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

public class TypeInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    /**
     * 根据日志类型添加headers，分类topic
     * @param event
     * @return
     */
    @Override
    public Event intercept(Event event) {
        Map<String, String> headers = event.getHeaders();
        String s = new String(event.getBody(), Charset.forName("utf-8"));

        if (s.contains("\"en\":\"start\"")) {
            headers.put("topic","topic_start");
        } else {
            headers.put("topic","topic_event");
        }
        return event;
    }

    @Override
    public List<Event> intercept(List<Event> events) {
        for (Event event : events) {
            intercept(event);
        }
        return events;
    }

    @Override
    public void close() {

    }

    public static class Builder implements Interceptor.Builder{

        @Override
        public Interceptor build() {
            return new TypeInterceptor();
        }

        @Override
        public void configure(Context context) {

        }
    }
}
