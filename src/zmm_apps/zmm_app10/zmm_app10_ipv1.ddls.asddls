@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Child PEntity1'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP10_IPV1
  as projection on ZMM_APP10_IV1
{
  key Uuid,
  key Ebelp,
      @ObjectModel.text.element: [ 'Maktx' ]
      Matnr,
      Maktx,
      Bedat,
      @Semantics.quantity.unitOfMeasure: 'Rcvunt'
      Vdinvqty,
      Inspectionlot,
      Insresult,
      Inslotsts,
      Rcvunt,
      /* Associations */
      _Header : redirected to parent ZMM_APP10_RPV
}
