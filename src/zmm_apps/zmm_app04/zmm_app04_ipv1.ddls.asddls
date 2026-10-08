@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase - GateIn POItem Data'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP04_IPV1
  as projection on ZMM_APP04_IV1
{
  key Uuid,
  key Ebelp,
      @ObjectModel.text.element: [ 'Maktx' ]
      Matnr,
      Maktx,
      Bedat,
      @ObjectModel.text.element: [ 'Suppname' ]
      Lifnr,
      Suppname,
      Werks,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Poqty,
      @Semantics.quantity.unitOfMeasure: 'Rcvunt'
      Rcvqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Vdinvqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Actphqty,
      Inspectionlot,
      Insresult,
      Inslotsts,
      Meins,
      Rcvunt,
      /* Associations */
      _Header : redirected to parent ZMM_APP04_RPV
}
