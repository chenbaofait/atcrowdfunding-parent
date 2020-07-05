package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.github.pagehelper.PageInfo;

import java.util.Map;

public interface AdminService {
    public TAdmin getAdminByLogin(String loginacct, String userpswd);

    PageInfo<TAdmin> listPage(Map<String, Object> paramap);

    void saveAdmin(TAdmin tAdmin);


    TAdmin getAdminById(Integer id);

    void updateAdmin(TAdmin tAdmin);

    void deleteAdmin(Integer id);

    void deleteBatch(String ids);
}
