@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP08_IV1
  as select from zsd_app08_tb2
  association to parent ZSD_APP08_RV as _Header on  $projection.Bukrs = _Header.Bukrs
                                                and $projection.Vbeln = _Header.Vbeln
{
  key bukrs as Bukrs,
  key vbeln as Vbeln,
  key posnr as Posnr,
      pstyv as Pstyv,
      matnr as Matnr,
      matkl as Matkl,
      werks as Werks,
      arktx as Arktx,
      vrkme as Vrkme,
      @Semantics.quantity.unitOfMeasure : 'vrkme'
      fkimg as Fkimg,
      vbelv as Vbelv,
      posnv as Posnv,
      vgbel as Vgbel,
      vgpos as Vgpos,
      aubel as Aubel,
      kunag as Kunag,
      _Header
}
