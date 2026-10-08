@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Child entity 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP13_IRV1 as select from ZMM_APP12_IV1
 association[0..*] to ZMM_APP13_RV1 as _Hdr on $projection.Uuid = _Hdr.Uuid
 composition [1..*] of ZMM_APP13_IIRV1 as _ItemChild
{
    key Uuid,
    key Itemno,
    Matnr,
    Maktx,
    Uom,
    Hsncode,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Quantity,
    Curky,
    @Semantics.amount.currencyCode: 'Curky'
    Netprice,
    @Semantics.amount.currencyCode: 'Curky'
    Totvalue,
    Mark,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Hdr,
    _ItemChild
}
