@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection Child entity of Child 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_APP14_IIPV as projection on  ZMM_APP14_IIRV
{
    key Uuid,
    key Itemno,
    key  Itemo,
    key Itemn,
    
    Matnr,
    Maktx,
    Uom,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Quantity,
    Createdby,
    Createdat,
    Indt,
    Intim,
     @Semantics.quantity.unitOfMeasure: 'Uom'
    Recvqty,
     @Semantics.quantity.unitOfMeasure: 'Uom'
Penqty ,
Invoice,
    /* Associations */
    _ITME :  redirected to parent ZMM_APP14_IPV,
    _HDR :redirected to ZMM_APP14_PV
}
