alter table WORKS_STOCK_INTAKE_ITEM add constraint FK_WORKS_STOCK_INTAKE_ITEM_STOCK_INTAKE foreign key (STOCK_INTAKE_ID) references WORKS_STOCK_INTAKE(ID);
alter table WORKS_STOCK_INTAKE_ITEM add constraint FK_WORKS_STOCK_INTAKE_ITEM_STOCK_ITEM foreign key (STOCK_ITEM_ID) references WORKS_STOCK_ITEM(ID);
create index IDX_WORKS_STOCK_INTAKE_ITEM_STOCK_INTAKE on WORKS_STOCK_INTAKE_ITEM (STOCK_INTAKE_ID);
create index IDX_WORKS_STOCK_INTAKE_ITEM_STOCK_ITEM on WORKS_STOCK_INTAKE_ITEM (STOCK_ITEM_ID);
