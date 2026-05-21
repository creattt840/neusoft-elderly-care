package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.service.CareLevelService;
import com.neusoft.elderly.service.CareItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/care")
public class CareController {

    @Autowired
    private CareLevelService careLevelService;

    @Autowired
    private CareItemService careItemService;

    // 护理级别
    @GetMapping("/level/list")
    public Result<List<CareLevel>> levelList() {
        return Result.success(careLevelService.list());
    }

    @PostMapping("/level")
    public Result<Boolean> saveLevel(@RequestBody CareLevel careLevel) {
        return Result.success(careLevelService.save(careLevel));
    }

    @PutMapping("/level")
    public Result<Boolean> updateLevel(@RequestBody CareLevel careLevel) {
        return Result.success(careLevelService.updateById(careLevel));
    }

    @DeleteMapping("/level/{id}")
    public Result<Boolean> deleteLevel(@PathVariable Long id) {
        return Result.success(careLevelService.removeById(id));
    }

    // 护理内容
    @GetMapping("/item/list")
    public Result<List<CareItem>> itemList(@RequestParam(required = false) Long careLevelId) {
        if (careLevelId != null) {
            return Result.success(careItemService.getByCareLevelId(careLevelId));
        }
        return Result.success(careItemService.list());
    }

    @PostMapping("/item")
    public Result<Boolean> saveItem(@RequestBody CareItem careItem) {
        return Result.success(careItemService.save(careItem));
    }

    @PutMapping("/item")
    public Result<Boolean> updateItem(@RequestBody CareItem careItem) {
        return Result.success(careItemService.updateById(careItem));
    }

    @DeleteMapping("/item/{id}")
    public Result<Boolean> deleteItem(@PathVariable Long id) {
        return Result.success(careItemService.removeById(id));
    }
}
