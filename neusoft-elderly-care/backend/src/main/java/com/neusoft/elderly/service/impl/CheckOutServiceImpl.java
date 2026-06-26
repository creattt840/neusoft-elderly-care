package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CheckOut;
import com.neusoft.elderly.mapper.CheckOutMapper;
import com.neusoft.elderly.service.CheckOutService;
import org.springframework.stereotype.Service;

/**
 * 退住记录服务实现
 */
@Service
public class CheckOutServiceImpl extends ServiceImpl<CheckOutMapper, CheckOut> implements CheckOutService {
}
