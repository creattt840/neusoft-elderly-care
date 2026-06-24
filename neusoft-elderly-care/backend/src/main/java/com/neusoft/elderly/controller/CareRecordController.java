package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.service.CareRecordService;
import com.neusoft.elderly.vo.CareRecordVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/care-record")
public class CareRecordController {

    @Autowired
    private CareRecordService careRecordService;

    @GetMapping("/list")
    public Result<List<CareRecordVO>> list(@RequestParam(required = false) Long elderlyId) {
        return Result.success(careRecordService.listByElderlyId(elderlyId));
    }

    @GetMapping("/date")
    public Result<List<CareRecordVO>> getByDate(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(careRecordService.listByDate(date));
    }

    @GetMapping("/page")
    public Result<PageResult<CareRecordVO>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                                 @RequestParam(defaultValue = "10") Integer pageSize,
                                                 @RequestParam(required = false) Long elderlyId,
                                                 @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate recordDate) {
        Page<CareRecord> page = new Page<>(pageNum, pageSize);
        return Result.success(careRecordService.pageCareRecordVOs(page, elderlyId, recordDate));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody CareRecord careRecord) {
        return Result.success(careRecordService.saveCareRecord(careRecord));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody CareRecord careRecord) {
        return Result.success(careRecordService.updateCareRecord(careRecord));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(careRecordService.removeById(id));
    }
}
