package com.example.subscription.dto;

public class SubscriptionDTO {
    private String subscriptionId;
    private String email;
    private String serviceName;
    private Double price;
    private String billingCycle;

    public SubscriptionDTO() {}

    public String getSubscriptionId() { return subscriptionId; }
    public void setSubscriptionId(String subscriptionId) { this.subscriptionId = subscriptionId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getBillingCycle() { return billingCycle; }
    public void setBillingCycle(String billingCycle) { this.billingCycle = billingCycle; }
}