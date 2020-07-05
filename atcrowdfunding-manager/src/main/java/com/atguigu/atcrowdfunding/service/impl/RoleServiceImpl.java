package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    TRoleMapper roleMapper;


    @Override
    public PageInfo<TRole> listPage(Map<String, Object> paramMap) {
        String condition = (String) paramMap.get("condition");
        TRoleExample example = new TRoleExample();
        if (!StringUtils.isEmpty(condition)){
            example.createCriteria().andNameLike("%"+condition+"%");

        }
        List<TRole> list = roleMapper.selectByExample(example);
        PageInfo<TRole> page = new PageInfo<>(list,5);
        return page;
    }

    @Override
    public void saveRole(TRole role) {
        roleMapper.insertSelective(role);
    }

    @Override
    public TRole getRoleById(Integer id) {
        return roleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(TRole role) {
            roleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRole(Integer id) {
            roleMapper.deleteByPrimaryKey(id);
    }
}
