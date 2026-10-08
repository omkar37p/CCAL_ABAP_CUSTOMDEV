@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Projection Child entity of Child 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP13_IIPV1 as projection on ZMM_APP13_IIRV1
{
    key Uuid,
    key Itemno,
    key  Itemo,
    Matnr,
    Maktx,
    Uom,
    @Semantics.quantity.unitOfMeasure: 'Uom'
    Quantity,
    Createdby,
    Createddat,
    Indt,
    Intim,
    /* Associations */
    _item2 : redirected to parent ZMM_APP13_IPV1,
    _Root 
}
