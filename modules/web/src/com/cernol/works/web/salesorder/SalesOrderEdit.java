package com.cernol.works.web.salesorder;

import com.cernol.works.entity.*;
import com.cernol.works.service.ToolsService;
import com.haulmont.cuba.gui.components.AbstractEditor;
import com.haulmont.cuba.gui.components.Button;
import com.haulmont.cuba.gui.components.LookupField;
import com.haulmont.cuba.gui.components.TextField;
import com.haulmont.cuba.gui.data.CollectionDatasource;
import com.haulmont.reports.gui.actions.EditorPrintFormAction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

public class SalesOrderEdit extends AbstractEditor<SalesOrder> {

    private Logger log = LoggerFactory.getLogger(SalesOrder.class);

    @Inject
    ToolsService toolsService;

    @Inject
    private Button printBtn;

    @Override
    public void init(Map<String, Object> params) {
        super.init(params);

        printBtn.setAction(new EditorPrintFormAction(this,null));
        
    }

    @Inject
    private CollectionDatasource<SalesOrderContainer, UUID> salesOrderContainersDs;

    @Inject
    private CollectionDatasource<SalesOrderRawMaterial, UUID> salesOrderRawMaterialsDs;

    @Named("fieldGroup.invoiceNo")
    protected TextField invoiceField;

    @Named("fieldGroup.currentStatus")
    private LookupField currentStatusField;

    @Override
    protected void initNewItem(SalesOrder item) {
        super.initNewItem(item);

        item.setDocumentOn(Date.from(toolsService.getNow()));
        item.setDescription("Sales - No Invoice");
        item.setUnit(Unit.Kilogram);
        item.setCurrentStatus(DocumentStatus.New);
    }

    @Override
    protected void postInit() {
        super.postInit();

        invoiceField.addValueChangeListener(e -> invoiceChanged());

        salesOrderContainersDs.addCollectionChangeListener(e -> containersChanged());

        salesOrderRawMaterialsDs.addCollectionChangeListener(e -> rawMaterialsChanged());

        currentStatusField.addValueChangeListener(e -> statusChanged());
    }

    private void invoiceChanged() {
        getItem().setDescription("Sales - " + getItem().getInvoiceNo());
    }

    private void containersChanged() {

        BigDecimal containerCost = BigDecimal.ZERO;

        for (SalesOrderContainer line : salesOrderContainersDs.getItems()) {
            containerCost = containerCost.add(line.getLinePrice());
        }

        getItem().setContainerCost(containerCost);
    }

    private void rawMaterialsChanged() {

        BigDecimal rawMaterialCost = BigDecimal.ZERO;

        for (SalesOrderRawMaterial line : salesOrderRawMaterialsDs.getItems()) {
            rawMaterialCost = rawMaterialCost.add(line.getLinePrice());
        }

        getItem().setRawMaterialCost(rawMaterialCost);

    }
    
    private void statusChanged() {

        log.info("statusChanged()");

        if (getItem().getCurrentStatus() == DocumentStatus.Cancelled) {
            BigDecimal zeroVal = BigDecimal.ZERO;

            //getItem().setMass(zeroVal);
            getItem().setRawMaterialCost(zeroVal);
            getItem().setContainerCost(zeroVal);
            getItem().setOverheadCost(zeroVal);
        } else {
              containersChanged();
              rawMaterialsChanged();
        }

    }
}