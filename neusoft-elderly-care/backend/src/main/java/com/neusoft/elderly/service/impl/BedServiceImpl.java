package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.exception.BusinessException;
import com.neusoft.elderly.common.constant.CacheNames;
import com.neusoft.elderly.entity.Bed;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.Room;
import com.neusoft.elderly.mapper.BedMapper;
import com.neusoft.elderly.service.BedService;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.PageCacheService;
import com.neusoft.elderly.service.RoomService;
import com.neusoft.elderly.vo.BedVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class BedServiceImpl extends ServiceImpl<BedMapper, Bed> implements BedService {

    private static final int ROOM_STATUS_MAINTENANCE = 2;

    @Autowired
    private RoomService roomService;

    @Lazy
    @Autowired
    private ElderlyService elderlyService;

    @Autowired
    private PageCacheService pageCacheService;

    @Override
    public List<BedVO> listBedVOs() {
        return buildSortedBedVOs(list());
    }

    @Override
    @Cacheable(cacheNames = CacheNames.BED_PAGE,
            key = "T(com.neusoft.elderly.common.utils.CacheKeyUtils).pageKey(#page.current, #page.size)")
    public PageResult<BedVO> pageBedVOs(Page<Bed> page) {
        long total = baseMapper.countBedPage();
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<BedVO> list = baseMapper.selectBedPage(offset, page.getSize());
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    @Override
    public boolean save(Bed entity) {
        boolean saved = super.save(entity);
        if (saved) {
            pageCacheService.clearBedRelated();
        }
        return saved;
    }

    @Override
    public boolean updateById(Bed entity) {
        boolean updated = super.updateById(entity);
        if (updated) {
            pageCacheService.clearBedRelated();
        }
        return updated;
    }

    @Override
    public boolean removeById(java.io.Serializable id) {
        boolean removed = super.removeById(id);
        if (removed) {
            pageCacheService.clearBedRelated();
        }
        return removed;
    }

    @Override
    public List<BedVO> getBedVOsByRoomId(Long roomId) {
        return getBedsByRoomId(roomId).stream()
                .map(this::toBedVO)
                .collect(Collectors.toList());
    }

    private List<Bed> getBedsByRoomId(Long roomId) {
        return baseMapper.selectByRoomId(roomId);
    }

    @Override
    public List<BedVO> getAvailableBedVOs() {
        return baseMapper.selectAvailableBeds().stream()
                .map(this::toBedVO)
                .filter(bed -> !isRoomMaintaining(bed.getRoomStatus()))
                .collect(Collectors.toList());
    }

    @Override
    public BedVO getBedVO(Long id) {
        Bed bed = getById(id);
        if (bed == null) {
            return null;
        }
        BedVO bedVO = toBedVO(bed);
        if (bed.getElderlyId() != null) {
            Elderly elderly = elderlyService.getById(bed.getElderlyId());
            if (elderly != null) {
                fillElderlyInfo(bedVO, elderly);
            }
        }
        return bedVO;
    }

    @Override
    public void validateBedAssignable(Long bedId, Long elderlyId) {
        BedVO bed = getBedVO(bedId);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }
        if (isRoomMaintaining(bed.getRoomStatus())) {
            throw new BusinessException("该房间维修中，床位不可入住");
        }
        if (bed.getStatus() != null && bed.getStatus() == 1
                && (elderlyId == null || !elderlyId.equals(bed.getElderlyId()))) {
            throw new BusinessException("该床位已被占用");
        }
    }

    @Override
    public long countAvailableBeds() {
        return getAvailableBedVOs().size();
    }

    @Override
    public long countOccupiedBeds() {
        return baseMapper.countOccupiedBedsExcludingMaintenance();
    }

    private List<BedVO> buildSortedBedVOs(List<Bed> beds) {
        List<BedVO> bedVOs = beds.stream()
                .map(this::toBedVO)
                .collect(Collectors.toList());
        enrichElderlyInfo(bedVOs);
        return bedVOs.stream()
                .sorted(Comparator
                        .comparing(BedVO::getRoomNo, Comparator.nullsLast(String::compareTo))
                        .thenComparing(BedVO::getBedNo, Comparator.nullsLast(String::compareTo)))
                .collect(Collectors.toList());
    }

    private void enrichElderlyInfo(List<BedVO> bedVOs) {
        Set<Long> elderlyIds = bedVOs.stream()
                .map(BedVO::getElderlyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (elderlyIds.isEmpty()) {
            return;
        }
        Map<Long, Elderly> elderlyMap = elderlyService.listByIds(elderlyIds).stream()
                .collect(Collectors.toMap(Elderly::getId, elderly -> elderly));
        for (BedVO bedVO : bedVOs) {
            if (bedVO.getElderlyId() == null) {
                continue;
            }
            Elderly elderly = elderlyMap.get(bedVO.getElderlyId());
            if (elderly != null) {
                fillElderlyInfo(bedVO, elderly);
            }
        }
    }

    private void fillElderlyInfo(BedVO bedVO, Elderly elderly) {
        bedVO.setElderlyName(elderly.getName());
        bedVO.setElderlyGender(elderly.getGender());
        bedVO.setElderlyAge(elderly.getAge());
        bedVO.setElderlyEmergencyContact(elderly.getEmergencyContact());
        bedVO.setElderlyEmergencyPhone(elderly.getEmergencyPhone());
        bedVO.setCheckInDate(elderly.getCheckInDate());
    }

    private BedVO toBedVO(Bed bed) {
        BedVO vo = new BedVO();
        vo.setId(bed.getId());
        vo.setRoomId(bed.getRoomId());
        vo.setBedNo(bed.getBedNo());
        vo.setStatus(bed.getStatus());
        vo.setElderlyId(bed.getElderlyId());
        if (bed.getRoomId() != null) {
            Room room = roomService.getById(bed.getRoomId());
            if (room != null) {
                vo.setRoomNo(room.getRoomNo());
                vo.setRoomStatus(room.getStatus());
            }
        }
        return vo;
    }

    private boolean isRoomMaintaining(Integer roomStatus) {
        return roomStatus != null && roomStatus == ROOM_STATUS_MAINTENANCE;
    }
}
