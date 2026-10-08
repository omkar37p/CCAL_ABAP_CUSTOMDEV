@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For GRN AGING REPORT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZMM_GRNAGING_PV as projection on ZMM_GRNAGREPORT_RV
{
key GRNNO      ,
key GRNItem,
key GRNYear,
key COMPANYCODE,
    PLANT      ,
    GATEENTRYNO,
    GRNDate,
    VendorCode ,
    PurchaseOrder,
    POItem      ,
    Remarks,
    // InventStockType,
    StockType,
    DeliveryNote,
    SupplierName,
    MaterialCode,
    MaterialDescription,  
    PurchaseGroup,
    DEPARTMENT,
    UOM        ,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    RecievedQuantity,
    MOVTYPE    ,
    Currency,
    @Semantics.amount.currencyCode: 'Currency'
    INVOICEAMOUNT,
    AgeingDays,
    @Semantics.amount.currencyCode: 'Currency'
    b0_30,
    @Semantics.amount.currencyCode: 'Currency'
    b30_60,
    @Semantics.amount.currencyCode: 'Currency'
    b60_90,
    @Semantics.amount.currencyCode: 'Currency'
    b90_120,
    @Semantics.amount.currencyCode: 'Currency'
    b120_150,
    @Semantics.amount.currencyCode: 'Currency'
    b150_180,
    @Semantics.amount.currencyCode: 'Currency'
    upto365,
    @Semantics.amount.currencyCode: 'Currency'
    beyond1year 
}
