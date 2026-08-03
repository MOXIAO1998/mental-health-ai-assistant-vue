package com.gym.aispringboot.util;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.gym.aispringboot.config.JwtConfig;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Date;

@Component
public class JwtTokenUtil implements ApplicationContextAware {
    private static ApplicationContext applicationContext;
    private static final String ISSUER = "mental-health-assistant ";

    // generate token method
    public static String generateToken(Long userId, String username, Integer RoleType) {
        try {
            // get jwt config
            JwtConfig jwtConfig = getJwtConfig();
            // generate signature method
            Algorithm algorithm = Algorithm.HMAC256(jwtConfig.getSecret());
            // generate timeout duration
            Date expiration = new Date(System.currentTimeMillis() + jwtConfig.getExpiration());

            String token = JWT.create().
                    withClaim("userId", userId).
                    withClaim("username", username).
                    withClaim("roleType", RoleType).
                    withExpiresAt(expiration).
                    withIssuedAt(new Date()).
                    withIssuer(ISSUER).
                    sign(algorithm);
            return token;
        } catch (Exception e) {
            throw new RuntimeException("Token Generation failed: " + e);
        }
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        JwtTokenUtil.applicationContext = applicationContext;

    }

    public static JwtConfig getJwtConfig() {
        return applicationContext.getBean(JwtConfig.class);
    }

    // extract token
    public static String extractTokenFromRequest(HttpServletRequest request) {
        if (request == null){
            return null;
        }

        String tokenHeader = request.getHeader("token");
        if(StringUtils.hasText(tokenHeader)){
            return tokenHeader;
        }
        return null;
    }
}
