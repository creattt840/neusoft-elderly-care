package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.ServiceInfo;
import com.neusoft.elderly.entity.ServiceSubscription;
import com.neusoft.elderly.service.ServiceInfoService;
import com.neusoft.elderly.service.ServiceSubscriptionService;
import com.neusoft.elderly.vo.ServiceInfoVO;
import com.neusoft.elderly.vo.ServiceSubscriptionVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 服务信息与订阅管理接口
 */
@RestController
@RequestMapping("/api/service")
public class ServiceController {

    @Autowired
    private ServiceInfoService serviceInfoService;

    @Autowired
    private ServiceSubscriptionService serviceSubscriptionService;

    /** 查询服务列表 */
    @GetMapping("/list")
    public Result<List<ServiceInfoVO>> list(@RequestParam(required = false) Integer type) {
        return Result.success(serviceInfoService.listServiceInfoVOs(type));
    }

    /** 分页查询服务 */
    @GetMapping("/page")
    public Result<PageResult<ServiceInfoVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                                  @RequestParam(defaultValue = "10") Integer pageSize,
                                                  @RequestParam(required = false) Integer type) {
        Page<ServiceInfo> page = new Page<>(pageNum, pageSize);
        return Result.success(serviceInfoService.pageServiceInfoVOs(page, type));
    }

    /** 新增服务 */
    @PostMapping
    public Result<Boolean> save(@RequestBody ServiceInfo service) {
        return Result.success(serviceInfoService.save(service));
    }

    /** 更新服务 */
    @PutMapping
    public Result<Boolean> update(@RequestBody ServiceInfo service) {
        return Result.success(serviceInfoService.updateById(service));
    }

    /** 删除服务 */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(serviceInfoService.removeById(id));
    }

    /** 查询老人的服务订阅 */
    @GetMapping("/subscription/{elderlyId}")
    public Result<List<ServiceSubscriptionVO>> getByElderlyId(@PathVariable Long elderlyId) {
        return Result.success(serviceSubscriptionService.listSubscriptionVOs(elderlyId));
    }

    /** 订阅服务 */
    @PostMapping("/subscription")
    public Result<Boolean> subscribe(@RequestBody ServiceSubscription subscription) {
        return Result.success(serviceSubscriptionService.save(subscription));
    }

    /** 更新服务订阅 */
    @PutMapping("/subscription")
    public Result<Boolean> updateSubscription(@RequestBody ServiceSubscription subscription) {
        return Result.success(serviceSubscriptionService.updateById(subscription));
    }

    /** 取消服务订阅 */
    @DeleteMapping("/subscription/{id}")
    public Result<Boolean> cancelSubscription(@PathVariable Long id) {
        return Result.success(serviceSubscriptionService.removeById(id));
    }
}
