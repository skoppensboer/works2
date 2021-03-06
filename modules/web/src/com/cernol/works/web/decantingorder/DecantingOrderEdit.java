package com.cernol.works.web.decantingorder;

import com.cernol.works.entity.*;
import com.cernol.works.service.ToolsService;
import com.haulmont.cuba.gui.components.*;
import com.haulmont.cuba.gui.data.CollectionDatasource;
import com.haulmont.reports.gui.actions.EditorPrintFormAction;

import javax.inject.Inject;
import javax.inject.Named;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

public class DecantingOrderEdit extends AbstractEditor<DecantingOrder> {

    @Inject
    private ToolsService toolsService;

    @Inject
    WorksConfig worksConfig;


    @Inject
    private CollectionDatasource<DecantingOrderTarget, UUID> decantingOrderTargetsDs;

    @Named("fieldGroup.decantedProduct")
    private PickerField decantedProductField;

    @Named("fieldGroup.currentStatus")
    private LookupField currentStatusField;

    @Inject
    private Button printBtn;

    @Override
    public void init(Map<String, Object> params) {
        super.init(params);

        printBtn.setAction(new EditorPrintFormAction(this,null));
    }

    @Override
    protected void initNewItem(DecantingOrder item) {
        super.initNewItem(item);

        item.setDocumentOn(Date.from(toolsService.getNow()));
        item.setDescription("Decanting - No product");
        item.setUnit(Unit.Litre);
        item.setCurrentStatus(DocumentStatus.New);
    }

    @Override
    protected void postInit() {
        super.postInit();

        decantedProductField.addValueChangeListener(e -> productChanged());

        decantingOrderTargetsDs.addCollectionChangeListener(e -> targetsChanged());

        currentStatusField.addValueChangeListener(e -> statusChanged());

    }

    private void productChanged() {
        if (getItem().getDecantedProduct() == null) {
            getItem().setDescription("Decanting - No product");
        } else {
            getItem().setDescription("Decanting - " + getItem().getDecantedProduct().getCode());
        }
    }

    private void statusChanged() {
        if (getItem().getCurrentStatus() == DocumentStatus.Cancelled) {
            BigDecimal zeroVal = BigDecimal.ZERO;

            getItem().setMass(zeroVal);
            getItem().setContainerCost(zeroVal);
            getItem().setOverheadCost(zeroVal);
            
            if (getItem().getDecantedProduct() == null) {
                getItem().setDescription("Cancelled: Decanting - No product");
            } else {
                getItem().setDescription("Cancelled: Decanting - " + getItem().getDecantedProduct().getCode());
            }
        } else
        {
            productChanged();
            targetsChanged();
        }

    }

    private void targetsChanged() {
        BigDecimal targetVolume = BigDecimal.ZERO;
        BigDecimal targetCost = BigDecimal.ZERO;
        BigDecimal overheadCost;

        for (DecantingOrderTarget line : decantingOrderTargetsDs.getItems()) {
            targetVolume = targetVolume.add(line.getLineCapacity());
            targetCost = targetCost.add(line.getLineCost());
        }

        if (getItem().getDecantedProduct() == null) {
            overheadCost = BigDecimal.ZERO;
        } else {

            if (getItem().getDecantedProduct().getApplyOverhead()) {
                overheadCost = BigDecimal.ZERO;
            } else {
                overheadCost = targetCost.multiply(BigDecimal.valueOf(worksConfig.getDecantingOverhead(), 0)).
                        divide(BigDecimal.valueOf(100, 0));
            }
        }
        getItem().setTargetVolume(targetVolume);
        getItem().setContainerCost(targetCost);
        getItem().setOverheadCost(overheadCost);


    }
}