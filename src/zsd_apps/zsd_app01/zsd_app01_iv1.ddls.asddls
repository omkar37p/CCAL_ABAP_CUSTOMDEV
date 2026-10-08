@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Gate Entry - Item Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP01_IV1
  as select from zsd_app01_tb2
  association to parent ZSD_APP01_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid     as Uuid,
  key soitem   as Soitem,
      division as Division,
      material as Material,
      matdesc  as Matdesc,
      batch    as Batch,
      plant    as Plant,
      sloc     as Sloc,
      @Semantics.quantity.unitOfMeasure: 'Ordunt'
      ordqty   as Ordqty,
      ordunt   as Ordunt,
      _Header
}
