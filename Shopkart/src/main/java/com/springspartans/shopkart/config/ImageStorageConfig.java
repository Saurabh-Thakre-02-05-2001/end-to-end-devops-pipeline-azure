package com.springspartans.shopkart.config;

import java.nio.file.Path;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ImageStorageConfig {

	@Value("${file.project-path}")
	private String projectPath;

	@Value("${file.image-path}")
	private String imagePath;

	@Bean(name = "uploadPath")
	String uploadPath() {
		return Path.of(projectPath.trim(), imagePath.trim()).toAbsolutePath().normalize().toString();
	}
}
