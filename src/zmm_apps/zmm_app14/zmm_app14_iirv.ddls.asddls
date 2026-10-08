@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection Child entity of Child 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP14_IIRV as select from zmm_app14_tb1
association to parent ZMM_APP14_IRV as _ITME on $projection.Uuid = _ITME.Uuid and $projection.Itemno  = _ITME.Itemno
association[1..1] to ZMM_APP14_RV as _HDR on $projection.Uuid = _HDR.Uuid
{
    key uuid as Uuid,
    key itemno as Itemno,
     KEY itemo as Itemo,
    key itemn as Itemn,
    matnr as Matnr,
    maktx as Maktx,
    uom as Uom,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    quantity as Quantity,
    @Semantics.user.createdBy: true
    createdby as Createdby,
    @Semantics.systemDateTime.createdAt: true
    createdat as Createdat,
    indt as Indt,
    intim as Intim,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    recvqty as Recvqty,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    penqty  as Penqty ,
    
    invoice as Invoice,
    _ITME,
    _HDR
}
