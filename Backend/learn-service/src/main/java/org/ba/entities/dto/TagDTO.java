package org.ba.entities.dto;

import org.ba.entities.TagColor;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class TagDTO {
    @NotEmpty
    private String tag;
    @NotNull
    private TagColor color;
}
