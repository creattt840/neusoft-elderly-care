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

/**
 * 护理等级与项目接口
 */
@RestController
@RequestMapping("/api/care")
public class CareController {

    @Autowired
    private CareLevelService careLevelService;

    @Autowired
    private CareItemService careItemService;

    /** 查询护理等级列表 */
    @GetMapping("/level/list")
    public Result<List<CareLevelVO>> levelList() {
        return Result.success(careLevelService.listCareLevelVOs());
    }

    /** 新增护理等级 */
    @PostMapping("/level")
    public Result<Boolean> saveLevel(@RequestBody CareLevel careLevel) {
        return Result.success(careLevelService.save(careLevel));
    }

    /** 更新护理等级 */
    @PutMapping("/level")
    public Result<Boolean> updateLevel(@RequestBody CareLevel careLevel) {
        return Result.success(careLevelService.updateById(careLevel));
    }

    /** 删除护理等级 */
    @DeleteMapping("/level/{id}")
    public Result<Boolean> deleteLevel(@PathVariable Long id) {
        return Result.success(careLevelService.removeById(id));
    }

    /** 分页查询护理项目 */
    @GetMapping("/item/page")
    public Result<PageResult<CareItemVO>> itemPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                   @RequestParam(defaultValue = "10") Integer pageSize,
                                                   @RequestParam(required = false) Long careLevelId) {
        Page<CareItem> page = new Page<>(pageNum, pageSize);
        return Result.success(careItemService.pageCareItemVOs(page, careLevelId));
    }

    /** 根据护理等级查询项目列表 */
    @GetMapping("/item/list")
    public Result<List<CareItemVO>> itemList(@RequestParam(required = false) Long careLevelId) {
        return Result.success(careItemService.listByCareLevelId(careLevelId));
    }

    /** 新增护理项目 */
    @PostMapping("/item")
    public Result<Boolean> saveItem(@RequestBody CareItem careItem) {
        return Result.success(careItemService.save(careItem));
    }

    /** 更新护理项目 */
    @PutMapping("/item")
    public Result<Boolean> updateItem(@RequestBody CareItem careItem) {
        return Result.success(careItemService.updateById(careItem));
    }

    /** 删除护理项目 */
    @DeleteMapping("/item/{id}")
    public Result<Boolean> deleteItem(@PathVariable Long id) {
        return Result.success(careItemService.removeById(id));
    }
}
