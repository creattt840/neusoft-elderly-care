package com.neusoft.elderly.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.neusoft.elderly.common.BusinessException;
import com.neusoft.elderly.common.PageResult;
import com.neusoft.elderly.entity.Elderly;
import com.neusoft.elderly.entity.Outing;
import com.neusoft.elderly.mapper.OutingMapper;
import com.neusoft.elderly.service.ElderlyService;
import com.neusoft.elderly.service.OutingService;
import com.neusoft.elderly.vo.OutingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class OutingServiceImpl extends ServiceImpl<OutingMapper, Outing> implements OutingService {

    @Lazy
    @Autowired
    private ElderlyService elderlyService;

    @Override
    public List<OutingVO> listOutingVOs() {
        return buildOutingVOs(list());
    }

    @Override
    public List<OutingVO> listActiveOutingVOs() {
        return buildOutingVOs(getActiveOutings());
    }

    @Override
    public PageResult<OutingVO> pageOutingVOs(Page<Outing> page, Integer status) {
        long total = baseMapper.countOutingPage(status);
        if (total == 0) {
            return PageResult.empty(page.getCurrent(), page.getSize());
        }
        long offset = (page.getCurrent() - 1) * page.getSize();
        List<OutingVO> list = baseMapper.selectOutingPage(offset, page.getSize(), status);
        return PageResult.of(total, list, page.getCurrent(), page.getSize());
    }

    @Override
    public OutingVO getOutingVO(Long id) {
        Outing outing = getById(id);
        if (outing == null) {
            return null;
        }
        OutingVO vo = toOutingVO(outing);
        enrichElderlyInfo(List.of(vo));
        return vo;
    }

    @Override
    public List<Outing> getActiveOutings() {
        return baseMapper.selectActiveOutings();
    }

    @Override
    public void returnOuting(Long id) {
        Outing outing = getById(id);
        if (outing == null) {
            throw new BusinessException("外出记录不存在");
        }
        outing.setStatus(1);
        outing.setActualReturnTime(LocalDateTime.now());
        updateById(outing);
    }

    private List<OutingVO> buildOutingVOs(List<Outing> outings) {
        List<OutingVO> outingVOs = outings.stream()
                .map(this::toOutingVO)
                .collect(Collectors.toList());
        enrichElderlyInfo(outingVOs);
        return outingVOs;
    }

    private void enrichElderlyInfo(List<OutingVO> outingVOs) {
        Set<Long> elderlyIds = outingVOs.stream()
                .map(OutingVO::getElderlyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (elderlyIds.isEmpty()) {
            return;
        }
        Map<Long, Elderly> elderlyMap = elderlyService.listByIds(elderlyIds).stream()
                .collect(Collectors.toMap(Elderly::getId, elderly -> elderly));
        for (OutingVO outingVO : outingVOs) {
            if (outingVO.getElderlyId() == null) {
                continue;
            }
            Elderly elderly = elderlyMap.get(outingVO.getElderlyId());
            if (elderly != null) {
                outingVO.setElderlyName(elderly.getName());
                outingVO.setElderlyPhone(elderly.getPhone());
            }
        }
    }

    private OutingVO toOutingVO(Outing outing) {
        OutingVO vo = new OutingVO();
        vo.setId(outing.getId());
        vo.setElderlyId(outing.getElderlyId());
        vo.setOutingType(outing.getOutingType());
        vo.setStartTime(outing.getStartTime());
        vo.setExpectedReturnTime(outing.getExpectedReturnTime());
        vo.setActualReturnTime(outing.getActualReturnTime());
        vo.setAccompanier(outing.getAccompanier());
        vo.setAccompanierPhone(outing.getAccompanierPhone());
        vo.setDestination(outing.getDestination());
        vo.setReason(outing.getReason());
        vo.setStatus(outing.getStatus());
        vo.setCreateTime(outing.getCreateTime());
        return vo;
    }
}
