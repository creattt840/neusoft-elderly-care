package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.CareRecord;
import com.neusoft.elderly.service.CareRecordService;
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
    public Result<List<CareRecord>> list(@RequestParam(required = false) Long elderlyId) {
        if (elderlyId != null) {
            return Result.success(careRecordService.getByElderlyId(elderlyId));
        }
        return Result.success(careRecordService.list());
    }

    @GetMapping("/date")
    public Result<List<CareRecord>> getByDate(@RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date) {
        return Result.success(careRecordService.getByDate(date));
    }

    @GetMapping("/page")
    public Result<Page<CareRecord>> page(@RequestParam(defaultValue = "1") Integer pageNum,
                                         @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<CareRecord> page = new Page<>(pageNum, pageSize);
        return Result.success(careRecordService.page(page));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody CareRecord careRecord) {
        return Result.success(careRecordService.save(careRecord));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody CareRecord careRecord) {
        return Result.success(careRecordService.updateById(careRecord));
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        return Result.success(careRecordService.removeById(id));
    }
}
