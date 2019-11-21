package com.gtl.dw.flume;

import org.apache.commons.lang.StringUtils;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.List;

public class ETLInterceptor implements Interceptor {
    @Override
    public void initialize() {

    }

    /**
     * 简单ETL：根据格式过滤
     * @param event
     * @return
     */
    @Override
    public Event intercept(Event event) {
        if (event == null) {
            return null;
        }
        String msg = new String(event.getBody(),Charset.forName("utf-8"));

        if (StringUtils.isBlank(msg)) {
            return null;
        }
        if (msg.trim().contains("\"en\":\"start\"")) {
            if (LogUtil.validateStartLog(msg.trim())) {
                return event;
            }
        } else {
            if (LogUtil.validateEventLog(msg.trim())) {
                return event;
            }
        }
        return null;
    }

    /**
     * 返回值必须是原来的list
     * 以把要拦截的event从list中移除
     * iterator可以删除集合中的元素，而for循环不能删除集合中的元素(会抛异常)
     * @param events
     * @return
     */
    @Override
    public List<Event> intercept(List<Event> events) {
        Iterator<Event> iterator = events.iterator();
        while (iterator.hasNext()) {
            Event event = iterator.next();
            if (intercept(event) == null) {
                iterator.remove();
            }
        }
        return events;
    }

    @Override
    public void close() {

    }

    public static class Builder implements Interceptor.Builder {

        @Override
        public Interceptor build() {
            return new ETLInterceptor();
        }

        @Override
        public void configure(Context context) {

        }
    }
}
