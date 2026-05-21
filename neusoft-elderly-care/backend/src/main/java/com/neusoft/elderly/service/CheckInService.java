package com.neusoft.elderly.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.entity.CheckIn;
import com.neusoft.elderly.mapper.CheckInMapper;
import org.springframework.stereotype.Service;

@Service
public class CheckInService extends ServiceImpl<CheckInMapper, CheckIn> {
}
