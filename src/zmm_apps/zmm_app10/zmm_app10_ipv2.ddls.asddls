@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Child PEntity2'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP10_IPV2
  as projection on ZMM_APP10_IV2
{
  key Uuid,
  key Ticketnum,
      Gotime,
      Godate,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Ogrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Onetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Oitarewgt,
      Wgtunit,
      Mark,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZMM_APP10_RPV
}
