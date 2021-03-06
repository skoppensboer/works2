/*
 * Copyright (c) 2017 CubeIT
 */
package com.cernol.works.entity;

import com.haulmont.chile.core.datatypes.impl.EnumClass;

import javax.annotation.Nullable;


public enum Unit implements EnumClass<String> {

    Kilogram("kg"),
    Litre("l");

    private String id;

    Unit(String value) {
        this.id = value;
    }

    public String getId() {
        return id;
    }

    @Nullable
    public static Unit fromId(String id) {
        for (Unit at : Unit.values()) {
            if (at.getId().equals(id)) {
                return at;
            }
        }
        return null;
    }
}