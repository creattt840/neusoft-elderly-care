package com.neusoft.elderly.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.neusoft.elderly.common.Result.PageResult;
import com.neusoft.elderly.common.Result.Result;
import com.neusoft.elderly.entity.CareItem;
import com.neusoft.elderly.entity.CareLevel;
import com.neusoft.elderly.service.CareItemService;
import com.neusoft.elderly.service.CareLevelService;
import com.neusoft.elderly.vo.CareItemVO;
import com.neusoft.elderly.vo.CareLevelVO;
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

    @GetMapping("/level/list")
    public Result<List<CareLevelVO>> levelList() {
        return Result.success(careLevelService.listCareLevelVOs());
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

    @GetMapping("/item/page")
    public Result<PageResult<CareItemVO>> itemPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                   @RequestParam(defaultValue = "10") Integer pageSize,
                                                   @RequestParam(required = false) Long careLevelId) {
        Page<CareItem> page = new Page<>(pageNum, pageSize);
        return Result.success(careItemService.pageCareItemVOs(page, careLevelId));
    }

    @GetMapping("/item/list")
    public Result<List<CareItemVO>> itemList(@RequestParam(required = false) Long careLevelId) {
        return Result.success(careItemService.listByCareLevelId(careLevelId));
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
