package org.ba.utils;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class FieldValidator {
    
    public static boolean isValidSortField(String field, Class<?> entityClass) {
        if (field == null || field.isEmpty()) {
            return false;
        }

        List<String> validFields = Arrays.stream(entityClass.getDeclaredFields())
                .map(Field::getName)
                .collect(Collectors.toList());

        return validFields.contains(field);
    }
}
