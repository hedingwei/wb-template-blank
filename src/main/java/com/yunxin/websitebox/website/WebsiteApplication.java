package com.yunxin.websitebox.website;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.ApplicationPidFileWriter;
import springfox.documentation.oas.annotations.EnableOpenApi;


@EnableOpenApi
@SpringBootApplication(scanBasePackages = {"com.yunxin.websitebox"})
public class WebsiteApplication {

	public static void main(String[] args) {

		SpringApplication sa = new SpringApplication(WebsiteApplication.class);
		sa.addListeners(new ApplicationPidFileWriter());
		sa.run(args);

	}



}
