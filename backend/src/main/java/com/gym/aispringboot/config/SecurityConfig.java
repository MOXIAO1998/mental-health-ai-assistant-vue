package com.gym.aispringboot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    private static final String[] PUBLIC_PATHS = {
            "/",
            "/api/test",
            "/api/user/login",
            "/api/user/add"
    };
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
        http
                // forbidden CSRF protection (b.c API service)
                .csrf(AbstractHttpConfigurer::disable)
                // configure the session to be stateless (for JWT)
                .sessionManagement(session-> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // configure rules for authorization
                .authorizeHttpRequests(auth->auth
                    // public path (no need to be authenticated/login)
                    .requestMatchers(PUBLIC_PATHS).permitAll()
                    // all other paths (except public path) need to be authenticated
                    .anyRequest().authenticated()
                );
        return http.build();

    }

}
