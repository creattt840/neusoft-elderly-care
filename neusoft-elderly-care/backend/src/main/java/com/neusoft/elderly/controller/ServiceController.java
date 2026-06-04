package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.service.ServiceInfoService;
import com.neusoft.elderly.service.ServiceSubscriptionService;
import com.neusoft.elderly.vo.ServiceInfoVO;
import com.neusoft.elderly.vo.ServiceSubscriptionVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/service")
public class ServiceController {

    @Autowired
    private ServiceInfoService serviceInfoService;

    @Autowired
    private ServiceSubscriptionService serviceSubscriptionService;

    @GetMapping("/list")
    public Result<List<ServiceInfoVO>> list(@RequestParam(required = false) Integer type) {
        return Result.success(serviceInfoService.listServiceInfoVOs(type));
    }

    @GetMapping("/page")
    public Result<PageResult<ServiceInfoVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                                  @RequestParam(defaultValue = "10") Integer pageSize,
                                                  @RequestParam(required = false) Integer type) {
        Page<ServiceInfo> page = new Page<>(pageNum, pageSize);
        return Result.success(serviceInfoService.pageServiceInfoVOs(page, type));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody ServiceInfo service) {
        return Result.success(serviceInfoService.save(service));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody ServiceInfo service) {
        return Result.success(serviceInfoService.updateById(service));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(serviceInfoService.removeById(id));
    }

    @GetMapping("/subscription/{elderlyId}")
    public Result<List<ServiceSubscriptionVO>> getByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(serviceSubscriptionService.listSubscriptionVOs(elderlyId));
    }

    @PostMapping("/subscription")
    public Result<Boolean> subscribe(@RequestBody ServiceSubscription subscription) {
        return Result.success(serviceSubscriptionService.save(subscription));
    }

    @PutMapping("/subscription")
    public Result<Boolean> updateSubscription(@RequestBody ServiceSubscription subscription) {
        return Result.success(serviceSubscriptionService.updateById(subscription));
    }

    @DeleteMapping("/subscription/{id}")
    public Result<Boolean> cancelSubscription(@PathVariable Long id) {
        return Result.success(serviceSubscriptionService.removeById(id));
    }
}
