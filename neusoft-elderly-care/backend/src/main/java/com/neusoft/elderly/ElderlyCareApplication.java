package com.neusoft.elderly;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class ElderlyCareApplication {

    public static void main(String[] args) {
        SpringApplication.run(ElderlyCareApplication.class, args);
    }
}
