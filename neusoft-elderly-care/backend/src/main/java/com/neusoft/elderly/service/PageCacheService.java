package com.neusoft.elderly.service;

import com.neusoft.elderly.common.constant.CacheNames;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Service;

/**
 * 分页缓存清除服务（按业务关联批量清除缓存）
 */
@Service
public class PageCacheService {

    private final CacheManager cacheManager;

    public PageCacheService(CacheManager cacheManager) {
        this.cacheManager = cacheManager;
    }

    /** 清除老人相关缓存：elderly+bed+outing+care_record+meal_plan */
    public void clearElderlyRelated() {
        clear(CacheNames.ELDERLY_PAGE, CacheNames.BED_PAGE, CacheNames.OUTING_PAGE,
                CacheNames.CARE_RECORD_PAGE, CacheNames.MEAL_PLAN_PAGE);
    }

    /** 清除房间相关缓存：room+bed+elderly */
    public void clearRoomRelated() {
        clear(CacheNames.ROOM_PAGE, CacheNames.BED_PAGE, CacheNames.ELDERLY_PAGE);
    }

    /** 清除床位相关缓存：bed+elderly */
    public void clearBedRelated() {
        clear(CacheNames.BED_PAGE, CacheNames.ELDERLY_PAGE);
    }

    /** 清除外出记录缓存 */
    public void clearOutingRelated() {
        clear(CacheNames.OUTING_PAGE);
    }

    /** 清除护理等级相关缓存：care_level+care_item+care_record */
    public void clearCareLevelRelated() {
        clear(CacheNames.CARE_LEVEL_LIST, CacheNames.CARE_ITEM_PAGE, CacheNames.CARE_RECORD_PAGE);
    }

    /** 清除护理项目相关缓存：care_item+care_record */
    public void clearCareItemRelated() {
        clear(CacheNames.CARE_ITEM_PAGE, CacheNames.CARE_RECORD_PAGE);
    }

    /** 清除护理记录缓存 */
    public void clearCareRecordRelated() {
        clear(CacheNames.CARE_RECORD_PAGE);
    }

    /** 清除膳食计划缓存 */
    public void clearMealPlanRelated() {
        clear(CacheNames.MEAL_PLAN_PAGE);
    }

    /** 清除服务信息缓存 */
    public void clearServiceRelated() {
        clear(CacheNames.SERVICE_PAGE);
    }

    private void clear(String... cacheNames) {
        for (String cacheName : cacheNames) {
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                cache.clear();
            }
        }
    }
}
