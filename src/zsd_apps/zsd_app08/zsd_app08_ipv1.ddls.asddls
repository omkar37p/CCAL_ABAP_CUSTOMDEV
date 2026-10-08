@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP08_IPV1
  as projection on ZSD_APP08_IV1
{
  key Bukrs,
  key Vbeln,
  key Posnr,
      Pstyv,
      Matnr,
      Matkl,
      Werks,
      Arktx,
      Vrkme,
      @Semantics.quantity.unitOfMeasure : 'vrkme'
      Fkimg,
      Vbelv,
      Posnv,
      Vgbel,
      Vgpos,
      Aubel,
      Kunag,
      /* Associations */
      _Header : redirected to parent ZSD_APP08_RPV
}
