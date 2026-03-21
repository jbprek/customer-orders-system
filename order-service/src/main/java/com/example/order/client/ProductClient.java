package com.example.order.client;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class ProductClient {

    private final RestTemplate restTemplate;

    @Value("${services.product-service.url:http://localhost:8082}")
    private String productServiceUrl;

    @SuppressWarnings("unchecked")
    public ProductInfo getProduct(Long productId) {
        String url = productServiceUrl + "/api/products/" + productId;
        Map<String, Object> response = restTemplate.getForObject(url, Map.class);
        if (response == null) {
            throw new IllegalStateException("Product not found: " + productId);
        }
        return new ProductInfo(
                productId,
                (String) response.get("name"),
                new BigDecimal(response.get("price").toString()),
                (Integer) response.get("stock")
        );
    }

    public record ProductInfo(Long id, String name, BigDecimal price, Integer stock) {}
}
