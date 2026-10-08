@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection Child entity 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_APP14_IPV as projection on ZMM_APP14_IRV
{
    key Uuid,
    key Itemno, 
    Matnr,
    Maktx,
    Uom,
    Hsncode,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Quantity,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Recvqty,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Penqty,
    Curky,
    @Semantics.amount.currencyCode: 'Curky'
    Netprice,
    @Semantics.amount.currencyCode: 'Curky'
    Totvalue,
    Mark,
     @Semantics.user.createdBy: true
    Createdby,
    @Semantics.systemDateTime.createdAt: true
    Createdat,
    @Semantics.user.lastChangedBy: true
    Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Lastchangedat,
    /* Associations */
    _HDR : redirected to parent ZMM_APP14_PV,
    _ITMCH : redirected to composition child ZMM_APP14_IIPV
}
