package com.gym.aispringboot.common;

public enum ResultCode {
    //
    SUCCESS("200", "success"),
    ERROR("-1", "failure"),
    UNAUTHORIZED("401", "not logged in or token has expired"),
    SYSTEM_ERROR("500", "system error"),

    // parameters-related errors
    PARAM_ERROR("400", "parameter error"),
    PARAM_MISSING("4001", "required parameter missing"),
    PARAM_INVALID("4002", "incorrect parameter format"),

    // file-related errors
    FILE_NOT_FOUND("5001", "File does not exist."),
    FILE_UPLOAD_FAILED("5002", "File upload failed."),
    FILE_DELETE_FAILED("5003", "File deletion failed"),
    FILE_SIZE_EXCEEDED("5004", "The file size exceeds the limit."),
    FILE_TYPE_NOT_SUPPORTED("5005", "Unsupported file types"),
    FILE_NAME_INVALID("5006", "The file name is illegal."),
    FILE_CONTENT_INVALID("5007", "The file content is illegal."),
    FILE_SAVE_FAILED("5008", "File saving failed."),

    // Business-related errors
    BUSINESS_ERROR("6000", "Business processing failure"),
    ACCOUNT_SAME("6001", "The username already exists."),
    USER_NOT_EXIST("6002", "The username does not exists."),

    // token-related errors
    TOKEN_INVALID("A0230", "invalid token"),
    TOKEN_EXPIRED("A0230", "expired token"),
    TOKEN_BLOCKED("A0230", "The token has been added to the blacklist."),
    TOKEN_ACCESS_FORBIDDEN("A0231", "The token has been blocked from accessing."),
    AUTHORIZED_ERROR("A0300", "Abnormal access rights"),
    ACCESS_UNAUTHORIZED("A0301", "Unauthorized access");

    private String code;
    private String msg;

    ResultCode(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public String getCode() {
        return code;
    }
    public String getMsg() {
        return msg;
    }

}
