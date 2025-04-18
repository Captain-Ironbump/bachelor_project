package org.ba.entities;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum TagColor {
    RED("#FF0000"),
    GREEN("#00FF00"),
    BLUE("#0000FF"),
    YELLOW("#FFFF00"),
    ORANGE("#FFA500"),
    PURPLE("#800080"),
    PINK("#FFC0CB"),
    TEAL("#008080"),
    CYAN("#00FFFF"),
    BROWN("#A52A2A"),
    BLACK("#000000"),
    WHITE("#FFFFFF"),
    GRAY("#808080"),
    LIGHT_GRAY("#D3D3D3"),
    DARK_GRAY("#A9A9A9"),
    INDIGO("#4B0082"),
    LIME("#00FF00"),
    MAROON("#800000"),
    NAVY("#000080"),
    OLIVE("#808000");

    private final String hex;
}