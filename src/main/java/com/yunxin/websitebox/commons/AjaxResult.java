package com.yunxin.websitebox.commons;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @ClassName AjaxResult
 * @Description 统一返回结果类
 * @Author hdw
 * @Date 2020/9/3023:57
 * @Version 1.0
 */
@Data
public class AjaxResult<T> {

    @ApiModelProperty(value = "是否成功")
    private Boolean success;

    @ApiModelProperty(value = "返回码")
    private Integer code;

    @ApiModelProperty(value = "返回消息")
    private String message;

    @ApiModelProperty(value = "返回数据")
    private T data;

    private AjaxResult() {
    }

    /**
     * 成功静态方法
     * @return
     */
    public static AjaxResult ok() {
        AjaxResult result = new AjaxResult();
        result.setSuccess(true);
        result.setCode(ResultCode.SUCCESS);
        result.setMessage("成功!");
        return result;
    }

    /**
     * 失败静态方法
     * @return
     */
    public static AjaxResult error() {
        AjaxResult result = new AjaxResult();
        result.setSuccess(true);
        result.setCode(ResultCode.ERROR);
        result.setMessage("失败!");
        return result;
    }

    public AjaxResult success(Boolean success){
        this.setSuccess(success);
        return this;
    }

    public AjaxResult message(String message){
        this.setMessage(message);
        return this;
    }

    public AjaxResult code(Integer code){
        this.setCode(code);
        return this;
    }

    public AjaxResult data(T data){
        this.data= data;
        return this;
    }


}
