package org.ba.models;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Tag {
    private String tag;
    private String color;
}