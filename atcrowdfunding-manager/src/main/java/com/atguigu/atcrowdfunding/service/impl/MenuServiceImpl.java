package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.dao.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService {
    @Autowired
    TMenuMapper menuMapper;

    /**
     * 返回所有福彩但对象，以及父类对象的children（子菜单）集合
     * @return父菜单集合
     */
    @Override
    public List<TMenu> listAllMenu() {
        List<TMenu> parentMenuList = new ArrayList<>();
        Map<Integer,TMenu> cache = new HashMap<>();//为了以后找父菜单好找
        //这是全部数据
        List<TMenu> allMenuList = menuMapper.selectByExample(null);
        //需要组合父菜单和子菜单关系
        //1.查找所有父菜单
        for (TMenu menu : allMenuList) {
            if (menu.getPid() == 0){//外键为零表示当前菜单为父菜单
                parentMenuList.add(menu);
                cache.put(menu.getId(), menu);
            }
        }
        //2,查找所有子菜单查找到每一个父的孩子菜单，存放到children属性 跟着父一起返回
        for (TMenu tMenu : allMenuList) {
            if (tMenu.getPid() != 0){
                Integer pid = tMenu.getPid();//孩子父亲的id
                TMenu parentMenu = cache.get(pid);
                parentMenu.getChildren().add(tMenu);

            }
        }

        return parentMenuList;
    }
}
