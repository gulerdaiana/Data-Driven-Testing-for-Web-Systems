package com.example.subscription;

import com.example.subscription.model.User;
import com.example.subscription.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class SubscriptionApplication {

    public static void main(String[] args) {
        SpringApplication.run(SubscriptionApplication.class, args);
    }

    @Bean
    public CommandLineRunner demo(UserRepository userRepository) {
        return (args) -> {

            if (userRepository.findById("admin@test.com").isEmpty()) {
                userRepository.save(new User("admin@test.com", "password123"));
                System.out.println(">>> Userul de test 'admin@test.com' a fost inserat cu succes in baza de date!");
            }
        };
    }
}