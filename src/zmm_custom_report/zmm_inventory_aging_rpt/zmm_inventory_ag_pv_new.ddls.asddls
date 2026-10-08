@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION VIEW'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_INVENTORY_AG_PV_NEW 
provider contract transactional_query
as projection on ZMM_INVENTORY_AG_RV_NEW

{
    key mat,
    key Batch,
    key Plant,
    key StorageL,
    key Companycode,
    key Supplier,
     @Semantics.quantity.unitOfMeasure: 'uom'
    key   currentstockqty,
//    key Materialdoc,
     uom,
//    @Semantics.quantity.unitOfMeasure: 'uom'
//    currentstockqty,
    materialtype,
    stroagelocationname,
    Batchmafdate,
    Batchmafdate1,
    BatchExpDate,
    materialdesc,
    Nonmovingdays,
    cucy,
     @Semantics.amount.currencyCode: 'cucy'
    Currentstocka,
    Postingd,
    Pos,
    sales,
    Sitem,
    Customer,
    
    Productgroupname,
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
