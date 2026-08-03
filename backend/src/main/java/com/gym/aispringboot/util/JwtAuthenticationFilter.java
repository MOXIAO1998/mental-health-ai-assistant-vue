package com.gym.aispringboot.util;

import com.gym.aispringboot.common.ResultCode;
import com.gym.aispringboot.config.SecurityConfig;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String requestUri = request.getRequestURI();
        // check if it is a public path
        return SecurityConfig.isPublicPath(requestUri);
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain
    )throws ServletException, IOException{
        // get uri and method
        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        System.out.println(requestUri);
        System.out.println(method);
        // 1. extract JWT token
        String token = JwtTokenUtil.extractTokenFromRequest(request);
        if (StringUtils.hasText(token)){

        }else{
            // clear context
            clearSecurityContext();
            // return error notification
            ResponseUtil.WriteError(response, ResultCode.ACCESS_UNAUTHORIZED);
            return;
        }
        // continue filter chain
        chain.doFilter(request, response);


    }

    // Spring Security context
    private void clearSecurityContext(){
        SecurityContextHolder.clearContext();
    }
}
