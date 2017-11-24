alter table WORKS_INTERMEDIATE_ORDER_INGREDIENT add constraint FK_WORKS_INTERMEDIATE_ORDER_INGREDIENT_INTERMEDIATE_ORDER foreign key (INTERMEDIATE_ORDER_ID) references WORKS_ORDER(ID);
alter table WORKS_INTERMEDIATE_ORDER_INGREDIENT add constraint FK_WORKS_INTERMEDIATE_ORDER_INGREDIENT_RAW_MATERIAL foreign key (RAW_MATERIAL_ID) references WORKS_RAW_MATERIAL(STOCK_ITEM_ID);
create index IDX_WORKS_INTERMEDIATE_ORDER_INGREDIENT_INTERMEDIATE_ORDER on WORKS_INTERMEDIATE_ORDER_INGREDIENT (INTERMEDIATE_ORDER_ID);
create index IDX_WORKS_INTERMEDIATE_ORDER_INGREDIENT_RAW_MATERIAL on WORKS_INTERMEDIATE_ORDER_INGREDIENT (RAW_MATERIAL_ID);