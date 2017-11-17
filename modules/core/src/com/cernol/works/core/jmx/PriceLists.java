package com.cernol.works.core.jmx;

import com.cernol.works.entity.*;
import com.cernol.works.service.StockItemService;
import com.cernol.works.service.ToolsService;
import com.haulmont.cuba.core.Persistence;
import com.haulmont.cuba.core.Transaction;
import com.haulmont.cuba.core.TypedQuery;
import com.haulmont.cuba.core.global.Metadata;
import com.haulmont.cuba.core.global.TimeSource;
import com.haulmont.cuba.security.app.Authenticated;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.inject.Inject;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Component("works_PriceListsMBean")
public class PriceLists implements PriceListsMBean {

    private Logger log = LoggerFactory.getLogger(PriceLists.class);

    @Inject
    private Persistence persistence;

    @Inject
    private Metadata metadata;

    @Inject
    private WorksConfig worksConfig;

    @Inject
    private TimeSource timeSource;

    @Inject
    private StockItemService stockItemService;

    @Inject
    private ToolsService toolsService;

    @Override
    @Authenticated
    public String calculatePriceListsOn(Date onDate) {
        try {
            List<Product> productList;
            List<ProductContainer> productContainerList;
            List<Formula> prodcutFormulaList;

            try (Transaction tx = persistence.createTransaction()) {
                TypedQuery<Product> productTypedQuery = persistence.getEntityManager().createQuery(
                        "select p from works$Product p " +
                                "where p.deleteTs is null " +
                                "order by p.code ",
                        Product.class);

                productList = productTypedQuery.getResultList();

                for (Product product : productList) {
                    productContainerList = product.getContainers();

                    for (ProductContainer productContainer : productContainerList) {

                        BigDecimal priceRawMaterial = BigDecimal.ZERO;
                        BigDecimal priceContainer = BigDecimal.ZERO;
                        BigDecimal priceOverhead = BigDecimal.ZERO;
                        BigDecimal priceLabel = BigDecimal.ZERO;
                        BigDecimal priceTotal = BigDecimal.ZERO;

                        Container container = productContainer.getContainer();
                        priceContainer = stockItemService.getPointInTimeCost(container.getId(), onDate);

                        BigDecimal containerMass = container.getCapacity().multiply(product.getSpecificGravity());

                        prodcutFormulaList = product.getFormula();

                        for (Formula formula : prodcutFormulaList) {
                            RawMaterial rawMaterial = formula.getRawMaterial();

                            BigDecimal pitCost = stockItemService.getPointInTimeCost(rawMaterial.getId(), onDate);

                            priceRawMaterial = priceRawMaterial
                                    .add(pitCost.multiply(containerMass)
                                            .multiply(formula.getPartsPer100())
                                            .divide(BigDecimal.valueOf(100.0), 4, BigDecimal.ROUND_HALF_DOWN));

                        }

                        if (product.getApplyOverhead()) {
                            priceOverhead = (priceRawMaterial.add(priceContainer))
                                    .multiply(BigDecimal.valueOf(worksConfig.getOrderOverhead(), 0))
                                    .divide(BigDecimal.valueOf(100), 2);
                        }

                        if (productContainer.getProductLabel() != null) {
                            priceLabel = priceLabel.add(stockItemService.getPointInTimeCost(
                                    productContainer.getProductLabel().getId(),
                                    onDate));
                        }

                        if (productContainer.getCorrosiveLabel() != null) {
                            priceLabel = priceLabel.add(stockItemService.getPointInTimeCost(
                                    productContainer.getCorrosiveLabel().getId(),
                                    onDate));
                        }

                        if (productContainer.getPoisonousLabel() != null) {
                            priceLabel = priceLabel.add(stockItemService.getPointInTimeCost(
                                    productContainer.getPoisonousLabel().getId(),
                                    onDate));
                        }

                        if (productContainer.getFlammableLabel() != null) {
                            priceLabel = priceLabel.add(stockItemService.getPointInTimeCost(
                                    productContainer.getFlammableLabel().getId(),
                                    onDate));
                        }

                        if (productContainer.getKeepAwayLabel() != null) {
                            priceLabel = priceLabel.add(stockItemService.getPointInTimeCost(
                                    productContainer.getKeepAwayLabel().getId(),
                                    onDate));
                        }

                        priceTotal = priceRawMaterial.add(priceContainer).add(priceOverhead).add(priceLabel);

                        createOrUpdatePriceList(
                                product,
                                container,
                                onDate,
                                priceRawMaterial,
                                priceContainer,
                                priceOverhead,
                                priceLabel,
                                priceTotal);

                    }
                }

            }
            return "Updated price lists for " + onDate.toString();
        } catch (Throwable e) {
            log.error("Error calculating usages", e);
            return ExceptionUtils.getFullStackTrace(e);
        }

    }

    @Override
    @Authenticated
    public String calculateYesterdayPriceLists() {

        String message =
                calculatePriceListsOn(
                        toolsService.endOfDay(
                                toolsService.previousDay(
                                        timeSource.currentTimestamp())));
        return message;
    }

    private void createOrUpdatePriceList(Product product,
                                         Container container,
                                         Date priceOn,
                                         BigDecimal rawMaterialCost,
                                         BigDecimal containerCost,
                                         BigDecimal overheadCost,
                                         BigDecimal labelCost,
                                         BigDecimal price) {
        try (Transaction tx = persistence.createTransaction()) {
            TypedQuery<PriceList> query = persistence.getEntityManager().createQuery(
                    "select pl from works$PriceList pl " +
                            "where pl.product.id = ?1 " +
                            "and pl.container.id = ?2 " +
                            "and pl.priceOn = ?3 ",
                    PriceList.class);

            query.setParameter(1, product);
            query.setParameter(2, container);
            query.setParameter(3, priceOn);

            List<PriceList> priceListList = query.getResultList();

            if (priceListList.size() == 0) {
                PriceList priceList = metadata.create(PriceList.class);

                priceList.setProduct(product);
                priceList.setContainer(container);
                priceList.setPriceOn(priceOn);
                priceList.setRawMaterialCost(rawMaterialCost);
                priceList.setContainerCost(containerCost);
                priceList.setOverheadCost(overheadCost);
                priceList.setLabelCost(labelCost);
                priceList.setPrice(price);

                persistence.getEntityManager().persist(priceList);

            } else if (priceListList.size() == 1) {
                PriceList priceList = priceListList.get(0);

                priceList.setRawMaterialCost(rawMaterialCost);
                priceList.setContainerCost(containerCost);
                priceList.setOverheadCost(overheadCost);
                priceList.setLabelCost(labelCost);
                priceList.setPrice(price);

            } else {
                throw new IllegalStateException("More than one Price List entry for " + product.getCode() +
                        " in " + container.getDescription() + " on " + priceOn.toString());
            }

            tx.commit();
        }
    }
}