package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    TAdminMapper adminMapper;
    @Override
    public TAdmin getAdminByLogin(String loginacct, String userpswd) {

        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(loginacct);
        List<TAdmin> tAdmins = adminMapper.selectByExample(example);
        if(tAdmins == null || tAdmins.size() == 0){
            throw  new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }
        TAdmin admin = tAdmins.get(0);
        if (!admin.getUserpswd().equals(MD5Util.digest(userpswd))){
            throw  new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }
        return admin;
    }

    @Override
    public PageInfo<TAdmin> listPage(Map<String, Object> paramap) {
        TAdminExample example = new TAdminExample();

        String  condition = (String) paramap.get("condition");

        if (!StringUtils.isEmpty(condition)){
            example.createCriteria().andLoginacctLike("%"+condition+"%");
            TAdminExample.Criteria criteria2 = example.createCriteria().andUsernameLike("%"+condition+"%");
            TAdminExample.Criteria criteria3 = example.createCriteria().andEmailLike("%"+condition+"%");
            example.or(criteria2);
            example.or(criteria3);
        }
        example.setOrderByClause("createtime desc");
        List<TAdmin> list = adminMapper.selectByExample(example);

        int navigatePages =5;//导航页吗

        PageInfo<TAdmin> pageInfo = new PageInfo<>(list,navigatePages);

        return pageInfo;
    }

    @Override
    public void saveAdmin(TAdmin tAdmin) {
        tAdmin.setUserpswd(MD5Util.digest(Const.DEFALUT_PASSWORD));
        tAdmin.setCreatetime(DateUtil.getFormatTime());
        //动态sql语句有选择性的保存
        //属性值为null时不保存
        adminMapper.insertSelective(tAdmin);
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        return adminMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateAdmin(TAdmin tAdmin) {

        adminMapper.updateByPrimaryKeySelective(tAdmin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatch(String ids) {
        if(!StringUtils.isEmpty(ids)){
            String[] idstrArray = ids.split(",");
            List<Integer> idList = new ArrayList<>();
            for (String s : idstrArray) {
                int parseInt = Integer.parseInt(s);
                idList.add(parseInt);
            }
            TAdminExample example = new TAdminExample();

            example.createCriteria().andIdIn(idList);
            adminMapper.deleteByExample(example);

        }

    }
}
