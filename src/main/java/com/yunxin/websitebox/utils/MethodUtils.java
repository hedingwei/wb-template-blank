package com.yunxin.websitebox.utils;

import cn.hutool.core.util.ReflectUtil;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Stack;

public class MethodUtils {
    static Set<Class> basicType = new HashSet<>();
    static {
        basicType.add(Boolean.class);
        basicType.add(Short.class);
        basicType.add(Character.class);
        basicType.add(Integer.class);
        basicType.add(Long.class);
        basicType.add(Float.class);
        basicType.add(Double.class);
        basicType.add(String.class);
        basicType.add(boolean.class);
        basicType.add(short.class);
        basicType.add(char.class);
        basicType.add(int.class);
        basicType.add(long.class);
        basicType.add(float.class);
        basicType.add(double.class);
    }

    public static Object invoke(Object targetObject, String methodName, Object... args) throws InvocationTargetException, IllegalAccessException, Throwable {
        Class invokerClass = targetObject.getClass();
        List<Method> 候选方法数组 = ReflectUtil.getPublicMethods(invokerClass, method -> method.getName().equals(methodName)&&(method.getParameterCount()==args.length));
        Method invokingMethod = null;
        Object[] validInvokingArgs = null;
        for(int i=0;i<候选方法数组.size();i++){
            Method method = 候选方法数组.get(i);
            boolean 是我们需要的方法 = true;
            Class[] 参数类型数组 = method.getParameterTypes();
            Stack<Object> paramValueStack = new Stack<>();
            for(int j=参数类型数组.length-1;j>=0;j--){
                Class parameterType = 参数类型数组[j];
                if(basicType.contains(parameterType)){
                    if(args[j].getClass().equals(parameterType)){
                        paramValueStack.push(args[j]);
                    }else{
                        是我们需要的方法 = false;
                        break;
                    }
                }else{
                    if(parameterType.equals(args[j].getClass())){
                        paramValueStack.push(args[j]);
                    }else{
                        if((!parameterType.equals(JSONObject.class))&&(args[j].getClass().equals(JSONObject.class))){
                            try{
                                Object value = JSON.toJavaObject((JSON) args[j],parameterType);
                                paramValueStack.push(value);
                            }catch (Throwable t){
                                是我们需要的方法 = false;
                                break;
                            }
                        }else{
                            是我们需要的方法 = false;
                            break;
                        }
                    }
                }
            }

            if(!是我们需要的方法){
                continue;
            }else{
                invokingMethod = method;
                validInvokingArgs = dumpStackToArray(paramValueStack);
                break;
            }
        }

        if((invokingMethod!=null)&&(validInvokingArgs!=null)){
            Object result = invokingMethod.invoke(targetObject,validInvokingArgs);
            return result;
        }else{
            throw new Exception("指定服务方法不存在");
        }


    }

    private static Object[] dumpStackToArray(Stack s){
        int k = 0;
        Object[] d = new Object[s.size()];
        while (!s.isEmpty()){
            d[k] = s.pop();
            k++;
        }
        return d;
    }


}
