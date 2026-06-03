package com.neusoft.elderly.common;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import java.util.Collections;
import java.util.List;

public class PageResult<T> {
    private Long total;
    private List<T> list;
    private Long pageNum;
    private Long pageSize;
    private Long pages;

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public Long getPageNum() {
        return pageNum;
    }

    public void setPageNum(Long pageNum) {
        this.pageNum = pageNum;
    }

    public Long getPageSize() {
        return pageSize;
    }

    public void setPageSize(Long pageSize) {
        this.pageSize = pageSize;
    }

    public Long getPages() {
        return pages;
    }

    public void setPages(Long pages) {
        this.pages = pages;
    }

    public static <T> PageResult<T> of(Long total, List<T> list, Long pageNum, Long pageSize) {
        PageResult<T> result = new PageResult<>();
        result.setTotal(total);
        result.setList(list);
        result.setPageNum(pageNum);
        result.setPageSize(pageSize);
        long pages = pageSize == 0 ? 0 : (total + pageSize - 1) / pageSize;
        result.setPages(pages);
        return result;
    }

    public static <T> PageResult<T> of(Page<?> page, List<T> list) {
        return of(page.getTotal(), list, page.getCurrent(), page.getSize());
    }

    public static <T> PageResult<T> empty(long pageNum, long pageSize) {
        return of(0L, Collections.emptyList(), pageNum, pageSize);
    }
}
