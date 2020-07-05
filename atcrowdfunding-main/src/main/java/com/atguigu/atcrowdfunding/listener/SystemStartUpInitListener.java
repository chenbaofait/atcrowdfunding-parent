package com.atguigu.atcrowdfunding.listener;

import com.atguigu.atcrowdfunding.util.Const;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
//服务器启动时，讲上下文路径存放发哦application域中
public class SystemStartUpInitListener implements ServletContextListener {
    //服务器启动时进行初始化操作
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext servletContext = servletContextEvent.getServletContext();
        String contextPath = servletContext.getContextPath();
        servletContext.setAttribute(Const.PATH, contextPath);
        System.out.println("这是监听器初始方法");
    }
//服务停止时进行销毁操作
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println(" 这是销毁方法" );
    }
}
