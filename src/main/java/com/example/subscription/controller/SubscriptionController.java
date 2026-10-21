package com.example.subscription.controller;

import com.example.subscription.dto.SubscriptionDTO;
import com.example.subscription.model.Subscription;
import com.example.subscription.model.User;
import com.example.subscription.repository.SubscriptionRepository;
import com.example.subscription.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class SubscriptionController {

    @Autowired
    private SubscriptionRepository subscriptionRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String email = credentials.get("email");
        String password = credentials.get("password");

        Optional<User> userOpt = userRepository.findById(email);

        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("email", email);
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(401).body("Invalid credentials! Try admin@test.com / password123");
    }


    @PostMapping("/subscriptions")
    public ResponseEntity<?> createSubscription(@RequestBody SubscriptionDTO dto) {

        // [CHECK CONSTRAINT 1] Validare preț maxim permis
        if (dto.getPrice() != null && dto.getPrice() >= 250.00) {
            return ResponseEntity.badRequest().body("Eroare DB: Constrangere CHECK violata. Pretul e prea mare!");
        }

        // [CHECK CONSTRAINT 2] Validare ciclu de facturare permis
        if (!dto.getBillingCycle().equals("monthly") && !dto.getBillingCycle().equals("annually")) {
            return ResponseEntity.badRequest().body("Eroare DB: Constrangere CHECK violata. Ciclu invalid!");
        }

        // [PRIMARY KEY CONSTRAINT] Verifică unicitatea ID-ului de abonament
        if (subscriptionRepository.existsById(dto.getSubscriptionId())) {
            return ResponseEntity.badRequest().body("Eroare DB: Cheie primara duplicata!");
        }

        // [FOREIGN KEY CONSTRAINT]
        if (userRepository.findById(dto.getEmail()).isEmpty()) {
            return ResponseEntity.badRequest().body("Eroare DB: Foreign Key Violation. Utilizatorul asociat nu exista!");
        }

        Subscription sub = new Subscription();
        sub.setSubscriptionId(dto.getSubscriptionId());
        sub.setServiceName(dto.getServiceName());
        sub.setPrice(dto.getPrice());
        sub.setBillingCycle(dto.getBillingCycle());
        sub.setUserEmail(dto.getEmail());

        subscriptionRepository.save(sub);
        return ResponseEntity.ok("Salvare reusita!");
    }
}