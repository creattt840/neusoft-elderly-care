package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.service.ServiceInfoService;
import com.neusoft.elderly.service.ServiceSubscriptionService;
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

    // 服务项目
    @GetMapping("/list")
    public Result<List<ServiceInfo>> list(@RequestParam(required = false) Integer type) {
        if (type != null) {
            return Result.success(serviceInfoService.lambdaQuery()
                    .eq(ServiceInfo::getServiceType, type)
                    .eq(ServiceInfo::getStatus, 1)
                    .list());
        }
        return Result.success(serviceInfoService.list());
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

    // 服务订阅
    @GetMapping("/subscription/{elderlyId}")
    public Result<List<ServiceSubscription>> getByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(serviceSubscriptionService.getByElderlyId(elderlyId));
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
