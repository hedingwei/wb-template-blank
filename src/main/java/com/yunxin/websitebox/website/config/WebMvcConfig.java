package com.yunxin.websitebox.website.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**")//括号里是精彩资源存放的位置名字是自己的，可能一致也可能不一致
                .addResourceLocations("/static/")
                .setCacheControl(CacheControl.noCache())
                .setCachePeriod(0);//表示缓存的时间（秒）
    }
}
