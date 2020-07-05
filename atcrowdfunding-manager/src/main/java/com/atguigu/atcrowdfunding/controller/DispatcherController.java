package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.atguigu.atcrowdfunding.util.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class DispatcherController {
    @Autowired
    AdminService adminService;
    @Autowired
    MenuService menuService;
    @RequestMapping("/logout")
    public String logout(HttpSession session){
        if (session != null){
            session.invalidate();
        }
        return "redirect:/login.jsp";


    }
    //sesion中存在从sesion域中去
    @RequestMapping(value = "/main")
    public  String main(HttpSession session){
        List<TMenu> parentMenuList = (List<TMenu>) session.getAttribute("parentMenuList");
        if (parentMenuList == null){
            //查询所有菜单，显示左侧菜单栏
            //返回所有父的菜单
            parentMenuList = menuService.listAllMenu();
            session.setAttribute("parentMenuList",parentMenuList);
            System.out.println(parentMenuList);
        }



        return "main";
    }
    @RequestMapping( "/doLogin")
    public String doLogin(String loginacct, String userpswd, HttpSession session ){
        System.out.println("loginacct = " + loginacct);
        System.out.println("userpswd = " + userpswd);
        try {
            TAdmin admin = adminService.getAdminByLogin(loginacct, userpswd);
            if(admin == null){
                return "redirect:/login.jsp";
            }else {
                session.setAttribute(Const.LOGIN_ADMIN, admin);
                return "redirect:/main";
            }
        } catch (LoginException e) {
            e.printStackTrace();
            session.setAttribute("loginacct",loginacct);
            session.setAttribute("message",e.getMessage());
            return "redirect:/login.jsp";
        }catch (Exception e){
            e.printStackTrace();
            return"redirect:/error.jsp";
        }


    }
}
