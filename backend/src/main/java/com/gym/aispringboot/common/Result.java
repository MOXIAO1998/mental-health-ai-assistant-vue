package com.gym.aispringboot.common;

import lombok.Data;

@Data
public class Result<T> {
    private String code;
    private String msg;
    private T data;


    public static <T> Result ok() {
        Result<T> result = new Result();
        result.setCode(ResultCode.SUCCESS.getCode());
        result.setMsg(ResultCode.SUCCESS.getMsg());
        return result;
    }

    // overrides
    public static <T> Result ok(T data) {
        Result<T> result = ok();
        result.setData(data);
        return result;
    }

    public static <T> Result error() {
        Result<T> result = new Result();
        result.setCode(ResultCode.ERROR.getCode());
        result.setMsg(ResultCode.ERROR.getMsg());
        return result;
    }

    // overrides
    public static <T> Result error(String code, String msg, T data) {
        Result<T> result = new Result();
        result.setCode(code);
        result.setMsg(msg);
        result.setData(data);
        return result;
    }


}
