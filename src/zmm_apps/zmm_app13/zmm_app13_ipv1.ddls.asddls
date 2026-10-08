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
define ROOT view entity ZMM_APP13_IPV1
  provider contract transactional_query as projection on  ZMM_APP13_IRV1
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
     _hdr ,
    _ItemChild : redirected to composition child ZMM_APP13_IIPV1
}
