-- begin WORKS_CATEGORY
create unique index IDX_WORKS_CATEGORY_UK_CODE on WORKS_CATEGORY (CODE) where DELETE_TS is null ^
create unique index IDX_WORKS_CATEGORY_UK_DESCRIPTION on WORKS_CATEGORY (DESCRIPTION) where DELETE_TS is null ^
-- end WORKS_CATEGORY
-- begin WORKS_ORDER
alter table WORKS_ORDER add constraint FK_WORKS_ORDER_PRODUCT foreign key (PRODUCT_ID) references WORKS_PRODUCT(STOCK_ITEM_ID)^
alter table WORKS_ORDER add constraint FK_WORKS_ORDER_MIXER foreign key (MIXER_ID) references WORKS_MIXER(ID)^
alter table WORKS_ORDER add constraint FK_WORKS_ORDER_PRODUCT foreign key (PRODUCT_ID) references WORKS_PRODUCT(STOCK_ITEM_ID)^
create unique index IDX_WORKS_ORDER_UK_DOCUMENT_NO on WORKS_ORDER (DOCUMENT_NO) where DELETE_TS is null ^
create index IDX_WORKS_ORDER_PRODUCT on WORKS_ORDER (PRODUCT_ID)^
create index IDX_WORKS_ORDER_MIXER on WORKS_ORDER (MIXER_ID)^
-- end WORKS_ORDER
-- begin WORKS_STOCK_ITEM
create unique index IDX_WORKS_STOCK_ITEM_UK_CODE on WORKS_STOCK_ITEM (CODE) where DELETE_TS is null ^
-- end WORKS_STOCK_ITEM
-- begin WORKS_MIXER
create unique index IDX_WORKS_MIXER_UK_NAME on WORKS_MIXER (NAME) where DELETE_TS is null ^
-- end WORKS_MIXER
-- begin WORKS_CONTAINER
alter table WORKS_CONTAINER add constraint FK_WORKS_CONTAINER_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
-- end WORKS_CONTAINER
-- begin WORKS_RAW_MATERIAL
alter table WORKS_RAW_MATERIAL add constraint FK_WORKS_RAW_MATERIAL_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
-- end WORKS_RAW_MATERIAL
-- begin WORKS_PRODUCT
alter table WORKS_PRODUCT add constraint FK_WORKS_PRODUCT_CATEGORY foreign key (CATEGORY_ID) references WORKS_CATEGORY(ID)^
alter table WORKS_PRODUCT add constraint FK_WORKS_PRODUCT_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
create index IDX_WORKS_PRODUCT_CATEGORY on WORKS_PRODUCT (CATEGORY_ID)^
-- end WORKS_PRODUCT
-- begin WORKS_LABLE
alter table WORKS_LABLE add constraint FK_WORKS_LABLE_IMAGE_FILE foreign key (IMAGE_FILE_ID) references SYS_FILE(ID)^
alter table WORKS_LABLE add constraint FK_WORKS_LABLE_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
create index IDX_WORKS_LABLE_IMAGE_FILE on WORKS_LABLE (IMAGE_FILE_ID)^
-- end WORKS_LABLE
-- begin WORKS_WORKS_ORDER_PACKING
alter table WORKS_WORKS_ORDER_PACKING add constraint FK_WORKS_ORDER_PACKING_WORKS_ORDER foreign key (WORKS_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_WORKS_ORDER_PACKING add constraint FK_WORKS_ORDER_PACKING_CONTAINER foreign key (CONTAINER_ID) references WORKS_CONTAINER(STOCK_ITEM_ID)^
create index IDX_WORKS_ORDER_PACKING_WORKS_ORDER on WORKS_WORKS_ORDER_PACKING (WORKS_ORDER_ID)^
create index IDX_WORKS_ORDER_PACKING_CONTAINER on WORKS_WORKS_ORDER_PACKING (CONTAINER_ID)^
-- end WORKS_WORKS_ORDER_PACKING
-- begin WORKS_WORKS_ORDER_INGREDIENT
alter table WORKS_WORKS_ORDER_INGREDIENT add constraint FK_WORKS_ORDER_INGREDIENT_WORKS_ORDER foreign key (WORKS_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_WORKS_ORDER_INGREDIENT add constraint FK_WORKS_ORDER_INGREDIENT_RAW_MATERIAL foreign key (RAW_MATERIAL_ID) references WORKS_RAW_MATERIAL(STOCK_ITEM_ID)^
create index IDX_WORKS_ORDER_INGREDIENT_WORKS_ORDER on WORKS_WORKS_ORDER_INGREDIENT (WORKS_ORDER_ID)^
create index IDX_WORKS_ORDER_INGREDIENT_RAW_MATERIAL on WORKS_WORKS_ORDER_INGREDIENT (RAW_MATERIAL_ID)^
-- end WORKS_WORKS_ORDER_INGREDIENT
-- begin WORKS_WORKS_ORDER_LABLE
alter table WORKS_WORKS_ORDER_LABLE add constraint FK_WORKS_ORDER_LABLE_WORKS_ORDER foreign key (WORKS_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_WORKS_ORDER_LABLE add constraint FK_WORKS_ORDER_LABLE_LABLE foreign key (LABLE_ID) references WORKS_LABLE(STOCK_ITEM_ID)^
create index IDX_WORKS_ORDER_LABLE_WORKS_ORDER on WORKS_WORKS_ORDER_LABLE (WORKS_ORDER_ID)^
create index IDX_WORKS_ORDER_LABLE_LABLE on WORKS_WORKS_ORDER_LABLE (LABLE_ID)^
-- end WORKS_WORKS_ORDER_LABLE
-- begin WORKS_FORMULA
alter table WORKS_FORMULA add constraint FK_WORKS_FORMULA_PRODUCT foreign key (PRODUCT_ID) references WORKS_PRODUCT(STOCK_ITEM_ID)^
alter table WORKS_FORMULA add constraint FK_WORKS_FORMULA_RAW_MATERIAL foreign key (RAW_MATERIAL_ID) references WORKS_RAW_MATERIAL(STOCK_ITEM_ID)^
create unique index IDX_WORKS_FORMULA_UNQ on WORKS_FORMULA (PRODUCT_ID, SEQUENCE_NO) where DELETE_TS is null ^
create index IDX_WORKS_FORMULA_PRODUCT on WORKS_FORMULA (PRODUCT_ID)^
create index IDX_WORKS_FORMULA_RAW_MATERIAL on WORKS_FORMULA (RAW_MATERIAL_ID)^
-- end WORKS_FORMULA
-- begin WORKS_DECANTING_ORDER_SOURCE
alter table WORKS_DECANTING_ORDER_SOURCE add constraint FK_WORKS_DECANTING_ORDER_SOURCE_DECANTING_ORDER foreign key (DECANTING_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_DECANTING_ORDER_SOURCE add constraint FK_WORKS_DECANTING_ORDER_SOURCE_CONTAINER foreign key (CONTAINER_ID) references WORKS_CONTAINER(STOCK_ITEM_ID)^
create index IDX_WORKS_DECANTING_ORDER_SOURCE_DECANTING_ORDER on WORKS_DECANTING_ORDER_SOURCE (DECANTING_ORDER_ID)^
create index IDX_WORKS_DECANTING_ORDER_SOURCE_CONTAINER on WORKS_DECANTING_ORDER_SOURCE (CONTAINER_ID)^
-- end WORKS_DECANTING_ORDER_SOURCE
-- begin WORKS_DECANTING_ORDER_TARGET
alter table WORKS_DECANTING_ORDER_TARGET add constraint FK_WORKS_DECANTING_ORDER_TARGET_DECANTING_ORDER foreign key (DECANTING_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_DECANTING_ORDER_TARGET add constraint FK_WORKS_DECANTING_ORDER_TARGET_CONTAINER foreign key (CONTAINER_ID) references WORKS_CONTAINER(STOCK_ITEM_ID)^
create index IDX_WORKS_DECANTING_ORDER_TARGET_DECANTING_ORDER on WORKS_DECANTING_ORDER_TARGET (DECANTING_ORDER_ID)^
create index IDX_WORKS_DECANTING_ORDER_TARGET_CONTAINER on WORKS_DECANTING_ORDER_TARGET (CONTAINER_ID)^
-- end WORKS_DECANTING_ORDER_TARGET
-- begin WORKS_SALES_ORDER_CONTAINER
alter table WORKS_SALES_ORDER_CONTAINER add constraint FK_WORKS_SALES_ORDER_CONTAINER_SALES_ORDER foreign key (SALES_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_SALES_ORDER_CONTAINER add constraint FK_WORKS_SALES_ORDER_CONTAINER_CONTAINER foreign key (CONTAINER_ID) references WORKS_CONTAINER(STOCK_ITEM_ID)^
create index IDX_WORKS_SALES_ORDER_CONTAINER_SALES_ORDER on WORKS_SALES_ORDER_CONTAINER (SALES_ORDER_ID)^
create index IDX_WORKS_SALES_ORDER_CONTAINER_CONTAINER on WORKS_SALES_ORDER_CONTAINER (CONTAINER_ID)^
-- end WORKS_SALES_ORDER_CONTAINER
-- begin WORKS_SALES_ORDER_RAW_MATERIAL
alter table WORKS_SALES_ORDER_RAW_MATERIAL add constraint FK_WORKS_SALES_ORDER_RAW_MATERIAL_SALES_ORDER foreign key (SALES_ORDER_ID) references WORKS_ORDER(ID)^
alter table WORKS_SALES_ORDER_RAW_MATERIAL add constraint FK_WORKS_SALES_ORDER_RAW_MATERIAL_RAW_MATERIAL foreign key (RAW_MATERIAL_ID) references WORKS_RAW_MATERIAL(STOCK_ITEM_ID)^
create index IDX_WORKS_SALES_ORDER_RAW_MATERIAL_SALES_ORDER on WORKS_SALES_ORDER_RAW_MATERIAL (SALES_ORDER_ID)^
create index IDX_WORKS_SALES_ORDER_RAW_MATERIAL_RAW_MATERIAL on WORKS_SALES_ORDER_RAW_MATERIAL (RAW_MATERIAL_ID)^
-- end WORKS_SALES_ORDER_RAW_MATERIAL
-- begin WORKS_STOCK_COUNT
create unique index IDX_WORKS_STOCK_COUNT_UK_DOCUMENT_NO on WORKS_STOCK_COUNT (DOCUMENT_NO) where DELETE_TS is null ^
-- end WORKS_STOCK_COUNT
-- begin WORKS_STOCK_COUNT_ITEM
alter table WORKS_STOCK_COUNT_ITEM add constraint FK_WORKS_STOCK_COUNT_ITEM_STOCK_COUNT foreign key (STOCK_COUNT_ID) references WORKS_STOCK_COUNT(ID)^
alter table WORKS_STOCK_COUNT_ITEM add constraint FK_WORKS_STOCK_COUNT_ITEM_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
create index IDX_WORKS_STOCK_COUNT_ITEM_STOCK_COUNT on WORKS_STOCK_COUNT_ITEM (STOCK_COUNT_ID)^
create index IDX_WORKS_STOCK_COUNT_ITEM_STOCK_ITEM on WORKS_STOCK_COUNT_ITEM (STOCK_ITEM_ID)^
-- end WORKS_STOCK_COUNT_ITEM
-- begin WORKS_STOCK_INTAKE_ITEM
alter table WORKS_STOCK_INTAKE_ITEM add constraint FK_WORKS_STOCK_INTAKE_ITEM_STOCK_INTAKE foreign key (STOCK_INTAKE_ID) references WORKS_STOCK_INTAKE(ID)^
alter table WORKS_STOCK_INTAKE_ITEM add constraint FK_WORKS_STOCK_INTAKE_ITEM_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID)^
create index IDX_WORKS_STOCK_INTAKE_ITEM_STOCK_INTAKE on WORKS_STOCK_INTAKE_ITEM (STOCK_INTAKE_ID)^
create index IDX_WORKS_STOCK_INTAKE_ITEM_STOCK_ITEM on WORKS_STOCK_INTAKE_ITEM (STOCK_ITEM_ID)^
-- end WORKS_STOCK_INTAKE_ITEM
-- begin WORKS_SYSTEM_KEY
create unique index IDX_WORKS_SYSTEM_KEY_UNQ on WORKS_SYSTEM_KEY (CONTEXT) where DELETE_TS is null ^
-- end WORKS_SYSTEM_KEY
