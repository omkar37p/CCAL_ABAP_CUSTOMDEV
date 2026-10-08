@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Child to Child Entity view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP13_IIRV1 as select from zmm_app13_tb1
association to parent ZMM_APP13_IRV1 as _item2 on $projection.Uuid = _item2.Uuid and $projection.Itemno = _item2.Itemno
association to ZMM_APP13_RV1 as _Root on $projection.Uuid = _Root.Uuid
{
  key uuid   as Uuid,
  key itemno as Itemno,
  key itemo as Itemo,
  matnr      as Matnr,
  maktx     as Maktx,
  uom       as Uom, 
  @Semantics.quantity.unitOfMeasure : 'Uom'
  quantity   as Quantity,
  @Semantics.user.createdBy: true
  createdby as Createdby,
   @Semantics.systemDateTime.createdAt: true
  createdat as Createddat,
  indt as Indt,
  intim as Intim,
    _item2,
    _Root
}
