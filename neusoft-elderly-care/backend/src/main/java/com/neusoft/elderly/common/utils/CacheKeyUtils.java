package com.neusoft.elderly.common.utils;

import java.util.Arrays;
import java.util.stream.Collectors;

public final class CacheKeyUtils {

    private static final String NULL_VALUE = "_";

    private CacheKeyUtils() {
    }

    public static String pageKey(long pageNum, long pageSize, Object... filters) {
        String filterKey = Arrays.stream(filters)
                .map(CacheKeyUtils::normalize)
                .collect(Collectors.joining(":"));
        return pageNum + ":" + pageSize + ":" + filterKey;
    }

    private static String normalize(Object value) {
        if (value == null) {
            return NULL_VALUE;
        }
        if (value instanceof String str) {
            String trimmed = str.trim();
            return trimmed.isEmpty() ? NULL_VALUE : trimmed;
        }
        return value.toString();
    }
}
