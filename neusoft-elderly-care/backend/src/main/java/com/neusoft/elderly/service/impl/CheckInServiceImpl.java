package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CheckIn;
import com.neusoft.elderly.mapper.CheckInMapper;
import com.neusoft.elderly.service.CheckInService;
import org.springframework.stereotype.Service;

/**
 * 入住记录服务实现
 */
@Service
public class CheckInServiceImpl extends ServiceImpl<CheckInMapper, CheckIn> implements CheckInService {
}
