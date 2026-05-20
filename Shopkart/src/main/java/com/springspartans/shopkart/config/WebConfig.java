package com.springspartans.shopkart.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	private final String uploadPath;

	public WebConfig(@Qualifier("uploadPath") String uploadPath) {
		this.uploadPath = uploadPath;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		String root = uploadPath.replace("\\", "/");
		if (!root.endsWith("/")) {
			root = root + "/";
		}
		registry.addResourceHandler("/uploads/**").addResourceLocations("file:" + root);
	}
}