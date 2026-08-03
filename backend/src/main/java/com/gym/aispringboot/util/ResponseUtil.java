package com.gym.aispringboot.util;

import cn.hutool.json.JSONUtil;
import com.gym.aispringboot.common.Result;
import com.gym.aispringboot.common.ResultCode;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

public class ResponseUtil {
    // error response of filter
    public static void WriteError(HttpServletResponse response, ResultCode resultCode) {
        // based on the result code, write the corresponding error response
        int status = switch (resultCode) {
            case UNAUTHORIZED, ACCESS_UNAUTHORIZED, TOKEN_INVALID, TOKEN_EXPIRED, TOKEN_BLOCKED ->
                    HttpStatus.UNAUTHORIZED.value(); // 401
            case TOKEN_ACCESS_FORBIDDEN -> HttpStatus.FORBIDDEN.value(); // 403
            default -> HttpStatus.BAD_REQUEST.value();  //400
        };

        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());


        try (PrintWriter writer = response.getWriter()) {
            String jsonResponse = JSONUtil.toJsonStr(Result.error(resultCode.getCode(), resultCode.getMsg(), null));
            writer.print(jsonResponse);
            writer.flush(); // write to output stream
        } catch (IOException e) {
            System.out.println("WriteError: " + e.getMessage());
        }

    }

}
