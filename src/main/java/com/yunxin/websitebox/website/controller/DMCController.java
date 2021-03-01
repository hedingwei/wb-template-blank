package com.yunxin.websitebox.website.controller;

import cn.hutool.extra.spring.SpringUtil;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yunxin.websitebox.commons.AjaxResult;
import com.yunxin.websitebox.utils.MethodUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.reflect.InvocationTargetException;

@RestController
@RequestMapping("/api/dmc")
public class DMCController {


    @PostMapping("/service")
    public AjaxResult service(@RequestBody String body){
        String beanName = null;
        String method = null;
        try{
            JSONObject obj = (JSONObject) JSONObject.parse(body);
            beanName = obj.getString("bean");
            method = obj.getString("method");
            JSONArray args = obj.getJSONArray("args");
            Object bean = SpringUtil.getBean(Class.forName(beanName));
            if(bean==null){
                return AjaxResult.error().message("未识别的服务");
            }else{
                Object ret = MethodUtils.invoke(bean,method,args.stream().toArray());
                return AjaxResult.ok().data(ret);
            }
        }catch (Throwable t){
            if(t instanceof ClassNotFoundException){
                return AjaxResult.error().message("未识别的服务:"+beanName);
            }
            Throwable cause = t.getCause();
            if((cause!=null)&&(cause instanceof InvocationTargetException)){
                Throwable targetException = ((InvocationTargetException) cause).getTargetException();
                AjaxResult.error().message(targetException.getMessage());
            }
            if(cause!=null){
                return AjaxResult.error().message(t.getCause().getMessage());
            }else{
                return AjaxResult.error().message(t.getMessage());
            }


        }
    }
}
