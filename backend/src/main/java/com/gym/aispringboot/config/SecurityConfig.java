package com.gym.aispringboot.config;

import cn.hutool.core.text.AntPathMatcher;
import com.gym.aispringboot.util.JwtAuthenticationFilter;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    private static final AntPathMatcher antPathMatcher = new AntPathMatcher();

    private static final String[] PUBLIC_PATHS = {
            "/",
            "/api/test",
            "/api/user/login",
            "/api/user/add"
    };

    public static Boolean isPublicPath(String requestUri) {
        for (String publicPath : PUBLIC_PATHS) {
            if (antPathMatcher.match(publicPath, requestUri)) {
                return true;
            }
        }
        return false;
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
        http
                // forbidden CSRF protection (b.c API service)
                .csrf(AbstractHttpConfigurer::disable)
                // configure the session to be stateless (for JWT)
                .sessionManagement(session-> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // configure rules for authorization
                .authorizeHttpRequests(auth->auth
                    // allow async re-dispatch (SSE/streaming responses) and error dispatch
                    // to pass without re-authentication — they were already authorized on the
                    // initial REQUEST dispatch, and the stateless SecurityContext is empty here
                    .dispatcherTypeMatchers(DispatcherType.ASYNC, DispatcherType.ERROR).permitAll()
                    // public path (no need to be authenticated/login)
                    .requestMatchers(PUBLIC_PATHS).permitAll()
                    // all other paths (except a public path) need to be authenticated
                    .anyRequest().authenticated()
                )
                // add JWT filter
                .addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);
        return http.build();

    }

}
