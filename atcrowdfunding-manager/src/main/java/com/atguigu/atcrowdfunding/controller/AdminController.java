package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class AdminController {
    @Autowired
    AdminService adminService;
    @RequestMapping("admin/doDeleteBatch")
    public String doDeleteBatch(String ids , Integer pageNum){
        adminService.deleteBatch(ids);

        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("admin/doDelete")
    public String doDelete(Integer id , Integer pageNum){
        adminService.deleteAdmin(id);

        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("admin/doUpdate")
    public String doUpdate(TAdmin tAdmin , Integer pageNum){
        adminService.updateAdmin(tAdmin);

        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("admin/toUpdate")
    public String toUpdate(Integer id,Model model){
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin", admin);

        return "admin/update";
    }
    @RequestMapping("admin/doAdd")
    public String doAdd(TAdmin tAdmin){
        adminService.saveAdmin(tAdmin);

        return "redirect:/admin/index";
    }
    @RequestMapping("admin/toAdd")
    public String toAdd(){
        return "admin/add";
    }
    @RequestMapping("admin/index")
    public  String index(@RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum ,
                         @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
                         @RequestParam(value = "condition",required = false,defaultValue = "")String condition,
                         HttpSession session){
       //分页插件
        //相当于讲数据通过theradlocal绑定到线程上，传递给后续流程使用
        PageHelper.startPage(pageNum, pageSize);//开启分页功能
        //打包传递参数，map集合可以存放任意参数，业务需要发生变化时，业务接口不需要修改
        Map<String,Object>  paramap = new HashMap<>();
        paramap.put("condition", condition);
        PageInfo<TAdmin> page = adminService.listPage(paramap);
        session.setAttribute("page", page);
        return "admin/index";
    }
}
