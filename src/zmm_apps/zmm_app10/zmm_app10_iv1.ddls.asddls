@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Child Entity1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP10_IV1
  as select from zmm_app10_tb2
  association to parent ZMM_APP10_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid          as Uuid,
  key ebelp         as Ebelp,
      matnr         as Matnr,
      maktx         as Maktx,
      bedat         as Bedat,
      @Semantics.quantity.unitOfMeasure: 'Rcvunt'
      vdinvqty      as Vdinvqty,
      inspectionlot as Inspectionlot,
      insresult     as Insresult,
      inslotsts     as Inslotsts,
      rcvunt        as Rcvunt,
      _Header
}
