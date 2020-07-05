package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
public class RoleController {
    @Autowired
    RoleService roleService;

    @ResponseBody
    @PostMapping("/role/doDelete")
    public  String doDelete(Integer id){
        roleService.deleteRole(id);
        return  "ok";//返回json
    }
    @ResponseBody
    @PostMapping("/role/doUpdate")
    public  String get(TRole role){
        roleService.updateRole(role);
        return  "ok";//返回json
    }
    @ResponseBody
    @GetMapping("/role/get")
    public  TRole get(Integer id){
        return  roleService.getRoleById(id);//返回json
    }
    @ResponseBody
    @RequestMapping("/role/doRole")
    public  String doRole(TRole role){
        roleService.saveRole(role);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/role/loadData")
    public PageInfo<TRole> loadData(@RequestParam(value = "pageNum",required = false , defaultValue = "1") Integer pageNum,
                                    @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
                                    @RequestParam(value = "condition",required = false,defaultValue = "") String condition){
        PageHelper.startPage(pageNum, pageSize);
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("condition", condition);
        PageInfo<TRole> page = roleService.listPage(paramMap);

        return page;//返回json
    }
    @RequestMapping("/role/index")
    public String index(){
        return "role/index";
    }
}
