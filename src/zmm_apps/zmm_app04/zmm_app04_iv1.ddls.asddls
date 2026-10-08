@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase - GateIn POItem Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP04_IV1
  as select from zmm_app04_tb2
  association to parent ZMM_APP04_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid          as Uuid,
  key ebelp         as Ebelp,
      matnr         as Matnr,
      maktx         as Maktx,
      bedat         as Bedat,
      lifnr         as Lifnr,
      suppname      as Suppname,
      werks         as Werks,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      poqty         as Poqty,
      @Semantics.quantity.unitOfMeasure: 'Rcvunt'
      rcvqty        as Rcvqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      vdinvqty      as Vdinvqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      actphqty      as Actphqty,
      inspectionlot as Inspectionlot,
      insresult     as Insresult,
      inslotsts     as Inslotsts,
      meins         as Meins,
      rcvunt        as Rcvunt,
      _Header
}
