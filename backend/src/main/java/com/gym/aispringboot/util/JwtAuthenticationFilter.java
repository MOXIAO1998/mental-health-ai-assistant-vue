package com.gym.aispringboot.util;

import cn.hutool.json.JSONUtil;
import com.gym.aispringboot.DTO.response.UserLoginResponseDTO;
import com.gym.aispringboot.common.ResultCode;
import com.gym.aispringboot.config.SecurityConfig;
import com.gym.aispringboot.enumClass.UserStatus;
import com.gym.aispringboot.service.UserService;
import jakarta.annotation.Resource;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Resource
    private UserService userService;

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
    ) throws ServletException, IOException {
        // get uri and method
        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        System.out.println(requestUri);
        System.out.println(method);
        // 1. extract JWT token
        String token = JwtTokenUtil.extractTokenFromRequest(request);
        if (StringUtils.hasText(token)) {
            // 2. verify token and get user info
            JwtTokenUtil.TokenVerificationResult validationResult = JwtTokenUtil.validateToken(token);
            if (validationResult != null && validationResult.isValid()) {
                // 3.  query user info and verify user status
                UserLoginResponseDTO.UserDetailResponseDTO user = userService.getUserById(validationResult.getUserId());
                System.out.println(JSONUtil.parseObj(user));
                if (user != null && UserStatus.NORMAL.getCode().equals(user.getStatus())) {
                    // 4. create Spring Security validation Object
                    List<SimpleGrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + validationResult.getRoleType()));

                    // create UsernamePasswordAuthenticationToken Object
                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(validationResult.getUsername(), null, authorities);

                    // set Spring Security context
                    SecurityContextHolder.getContext().setAuthentication(authentication);

                    // store token into request attribute
                    request.setAttribute("jwtToken", token);

                } else {
                    // clear Context
                    clearSecurityContext();
                    ResponseUtil.WriteError(response, ResultCode.TOKEN_ACCESS_FORBIDDEN);
                    return;
                }
            } else {
                //clear context
                clearSecurityContext();
                // return error notification
                ResponseUtil.WriteError(response, ResultCode.TOKEN_INVALID);
                return;
            }

        } else {
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
    private void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }
}
