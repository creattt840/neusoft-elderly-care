package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.entity.*;
import com.neusoft.elderly.mapper.CareRecordMapper;
import com.neusoft.elderly.mapper.ElderlyMapper;
import com.neusoft.elderly.mapper.MealPlanMapper;
import com.neusoft.elderly.mapper.OutingMapper;
import com.neusoft.elderly.mapper.ServiceSubscriptionMapper;
import com.neusoft.elderly.service.*;
import com.neusoft.elderly.vo.BedVO;
import com.neusoft.elderly.vo.ElderlyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 老人信息服务实现
 */
@Service
public class ElderlyServiceImpl extends ServiceImpl<ElderlyMapper, Elderly> implements ElderlyService {

    @Autowired
    private BedService bedService;

    @Autowired
    private CheckInService checkInService;

    @Autowired
    private CheckOutService checkOutService;

    @Autowired
    private PageCacheService pageCacheService;

    @Autowired
    private OutingMapper outingMapper;

    @Autowired
    private CareRecordMapper careRecordMapper;

    @Autowired
    private MealPlanMapper mealPlanMapper;

    @Autowired
    private ServiceSubscriptionMapper serviceSubscriptionMapper;

    /** 分页查询老人列表含床位信息，缓存 */
    @Override
    @Cacheable(
            cacheNames = CacheNames.ELDERLY_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size, #name, #status)"
    )
    public PageResult<ElderlyVO> pageWithInfo(Page<Elderly> page, String name, Integer status) {
        LambdaQueryWrapper<Elderly> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(name)) {
            wrapper.like(Elderly::getName, name);
        }
        if (status != null) {
            wrapper.eq(Elderly::getStatus, status);
        }
        wrapper.orderByDesc(Elderly::getCreateTime);
        Page<Elderly> result = baseMapper.selectPage(page, wrapper);

        List<ElderlyVO> list = result.getRecords().stream()
                .map(this::toElderlyVO)
                .collect(Collectors.toList());
        return PageResult.of(result, list);
    }

    /** 根据ID获取老人详情 */
    @Override
    public ElderlyVO getDetail(Long id) {
        Elderly elderly = baseMapper.selectById(id);
        return elderly == null ? null : toElderlyVO(elderly);
    }

    /** 获取编辑时可选的床位 */
    @Override
    public List<BedVO> getAvailableBedsForEdit(Long elderlyId) {
        List<BedVO> beds = new ArrayList<>(bedService.getAvailableBedVOs());
        if (elderlyId == null) {
            return beds;
        }
        Elderly elderly = baseMapper.selectById(elderlyId);
        if (elderly == null || elderly.getBedId() == null) {
            return beds;
        }
        boolean exists = beds.stream().anyMatch(bed -> bed.getId().equals(elderly.getBedId()));
        if (!exists) {
            BedVO currentBed = bedService.getBedVO(elderly.getBedId());
            if (currentBed != null) {
                beds.add(0, currentBed);
            }
        }
        return beds;
    }

    /** 老人入住 */
    @Override
    @Transactional
    public void checkIn(Elderly elderly, Long bedId) {
        bedService.validateBedAssignable(bedId, null);

        Bed bed = bedService.getById(bedId);
        elderly.setBedId(bedId);
        elderly.setStatus(1);
        elderly.setCheckInDate(LocalDate.now());
        syncAddress(elderly);
        baseMapper.insert(elderly);

        bed.setStatus(1);
        bed.setElderlyId(elderly.getId());
        bedService.updateById(bed);

        CheckIn checkIn = new CheckIn();
        checkIn.setElderlyId(elderly.getId());
        checkIn.setBedId(bedId);
        checkIn.setCheckInDate(elderly.getCheckInDate());
        checkInService.save(checkIn);
        pageCacheService.clearElderlyRelated();
    }

    /** 新增老人，清除缓存 */
    @Override
    public boolean save(Elderly entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearElderlyRelated();
        }
        return saved;
    }

    /** 更新老人信息，清除缓存 */
    @Override
    @Transactional
    public void updateElderly(Elderly elderly) {
        Elderly existing = baseMapper.selectById(elderly.getId());
        if (existing == null) {
            throw new BusinessException("老人信息不存在");
        }

        Long oldBedId = existing.getBedId();
        Long newBedId = elderly.getBedId();

        if (existing.getStatus() != null && existing.getStatus() == 1
                && newBedId != null && !newBedId.equals(oldBedId)) {
            if (oldBedId != null) {
                releaseBed(oldBedId);
            }

            bedService.validateBedAssignable(newBedId, elderly.getId());

            Bed newBed = bedService.getById(newBedId);
            newBed.setStatus(1);
            newBed.setElderlyId(elderly.getId());
            bedService.updateById(newBed);
        }

        syncAddress(elderly);
        baseMapper.updateById(elderly);
        pageCacheService.clearElderlyRelated();
    }

    /** 删除老人释放床位，清除缓存 */
    @Override
    @Transactional
    public void removeElderly(Long id) {
        Elderly elderly = baseMapper.selectById(id);
        if (elderly == null) {
            throw new BusinessException("老人信息不存在");
        }
        if (elderly.getStatus() != null && elderly.getStatus() == 1 && elderly.getBedId() != null) {
            releaseBed(elderly.getBedId());
        }
        removeRelatedRecords(id);
        removeById(id);
        pageCacheService.clearElderlyRelated();
    }

    /** 老人退住，清除缓存 */
    @Override
    @Transactional
    public void checkOut(Long elderlyId) {
        Elderly elderly = baseMapper.selectById(elderlyId);
        if (elderly == null) {
            throw new BusinessException("老人信息不存在");
        }

        if (elderly.getBedId() != null) {
            CheckOut checkOut = new CheckOut();
            checkOut.setElderlyId(elderlyId);
            checkOut.setBedId(elderly.getBedId());
            checkOut.setCheckOutDate(LocalDate.now());
            checkOutService.save(checkOut);
            releaseBed(elderly.getBedId());
        }
        baseMapper.update(new LambdaUpdateWrapper<Elderly>()
                .eq(Elderly::getId, elderlyId)
                .set(Elderly::getStatus, 2)
                .set(Elderly::getBedId, null));
        pageCacheService.clearElderlyRelated();
    }

    /** 统计在住老人数量 */
    @Override
    public Long countActiveElderly() {
        return baseMapper.countActiveElderly();
    }

    /** 统计已退住老人数量 */
    @Override
    public Long countCheckedOutElderly() {
        return baseMapper.countCheckedOutElderly();
    }

    private ElderlyVO toElderlyVO(Elderly elderly) {
        ElderlyVO vo = new ElderlyVO();
        vo.setId(elderly.getId());
        vo.setName(elderly.getName());
        vo.setPhone(elderly.getPhone());
        vo.setGender(elderly.getGender());
        vo.setAge(elderly.getAge());
        vo.setIdCard(elderly.getIdCard());
        vo.setAddress(elderly.getAddress());
        vo.setCountry(elderly.getCountry());
        vo.setProvince(elderly.getProvince());
        vo.setCity(elderly.getCity());
        vo.setAddressDetail(elderly.getAddressDetail());
        vo.setHealthCondition(elderly.getHealthCondition());
        vo.setAllergyInfo(elderly.getAllergyInfo());
        vo.setEmergencyContact(elderly.getEmergencyContact());
        vo.setEmergencyPhone(elderly.getEmergencyPhone());
        vo.setCareLevelId(elderly.getCareLevelId());
        vo.setBedId(elderly.getBedId());
        vo.setStatus(elderly.getStatus());
        vo.setCheckInDate(elderly.getCheckInDate());
        vo.setCreateTime(elderly.getCreateTime());
        vo.setUpdateTime(elderly.getUpdateTime());

        if (elderly.getBedId() != null) {
            BedVO bedVO = bedService.getBedVO(elderly.getBedId());
            if (bedVO != null) {
                vo.setBedNo(bedVO.getBedNo());
                vo.setRoomNo(bedVO.getRoomNo());
            }
        }
        return vo;
    }

    private void removeRelatedRecords(Long elderlyId) {
        checkInService.remove(new LambdaQueryWrapper<CheckIn>().eq(CheckIn::getElderlyId, elderlyId));
        checkOutService.remove(new LambdaQueryWrapper<CheckOut>().eq(CheckOut::getElderlyId, elderlyId));
        outingMapper.delete(new LambdaQueryWrapper<Outing>().eq(Outing::getElderlyId, elderlyId));
        careRecordMapper.delete(new LambdaQueryWrapper<CareRecord>().eq(CareRecord::getElderlyId, elderlyId));
        mealPlanMapper.delete(new LambdaQueryWrapper<MealPlan>().eq(MealPlan::getElderlyId, elderlyId));
        serviceSubscriptionMapper.delete(new LambdaQueryWrapper<ServiceSubscription>()
                .eq(ServiceSubscription::getElderlyId, elderlyId));
        baseMapper.deleteElderlyMealsByElderlyId(elderlyId);
    }

    private void releaseBed(Long bedId) {
        boolean updated = bedService.update(new LambdaUpdateWrapper<Bed>()
                .eq(Bed::getId, bedId)
                .set(Bed::getStatus, 0)
                .set(Bed::getElderlyId, null));
        if (updated) {
            pageCacheService.clearBedRelated();
        }
    }

    private void syncAddress(Elderly elderly) {
        StringBuilder sb = new StringBuilder();
        if (StringUtils.hasText(elderly.getCountry())) {
            sb.append(elderly.getCountry());
        }
        if (StringUtils.hasText(elderly.getProvince())) {
            if (sb.length() > 0) {
                sb.append(' ');
            }
            sb.append(elderly.getProvince());
        }
        if (StringUtils.hasText(elderly.getCity())) {
            if (sb.length() > 0) {
                sb.append(' ');
            }
            sb.append(elderly.getCity());
        }
        if (StringUtils.hasText(elderly.getAddressDetail())) {
            if (sb.length() > 0) {
                sb.append(' ');
            }
            sb.append(elderly.getAddressDetail());
        }
        if (sb.length() > 0) {
            elderly.setAddress(sb.toString());
        }
    }
}
