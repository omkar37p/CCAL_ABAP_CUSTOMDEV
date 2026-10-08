@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM INVENTORY AGING REPORT PV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_INVENTORY_AG_PV 
 provider contract transactional_query
  as projection on ZMM_INVENTORY_AG_RV
{
 key mat,
  key Plant,
  key StorageL,
  key Batch,
  key PostingDate,
         Companycode,
         uom,
         @Semantics.quantity.unitOfMeasure: 'uom'
         currentstockqty,
         materialtype,
         stroagelocationname,
         Batchmafdate,
         sales,
         Sitem,
         Customer,
         Supplier,
         Productgroup,
         BatchExpDate,
         materialdesc,
         Nonmovingdayss,
         Pos1tingday,
         cucy,
         @Semantics.amount.currencyCode: 'cucy'
         Currentstocka,
         @Semantics.amount.currencyCode: 'cucy'
         Amt30,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty30,
         @Semantics.amount.currencyCode: 'cucy'
         Amt60,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty60,
         @Semantics.amount.currencyCode: 'cucy'
         Amt90,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty90,
         @Semantics.amount.currencyCode: 'cucy'
         Amt180,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty180,
         @Semantics.amount.currencyCode: 'cucy'
         Amt365,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty365,
         @Semantics.amount.currencyCode: 'cucy'
         Amt1year,
         @Semantics.quantity.unitOfMeasure: 'uom'
         Qty1year
}

