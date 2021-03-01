package com.yunxin.websitebox.website;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import springfox.documentation.oas.annotations.EnableOpenApi;


@EnableOpenApi
@SpringBootApplication(scanBasePackages = {"com.yunxin.websitebox"})
public class WebsiteApplication {

	public static void main(String[] args) {

		SpringApplication.run(WebsiteApplication.class, args);
	}



}
