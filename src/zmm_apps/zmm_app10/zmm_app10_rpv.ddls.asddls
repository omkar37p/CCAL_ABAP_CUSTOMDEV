@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP10_RPV
  provider contract transactional_query
  as projection on ZMM_APP10_RV
{
  key Uuid,
      Ticketnum,
      Tckdate,
      Tcktime,
      Plant,
      Plantname,
      Vehicleno,
      Veninvno,
      Trcuktyp,
      Drivername,
      Lrnumber,
      Trspname,
      Vendname,
      Nonporef,
      Trspmode,
      Remarks,
      Loadsts,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Igrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Inetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Itarewgt,
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
      _Gout : redirected to composition child ZMM_APP10_IPV2,
      _Item : redirected to composition child ZMM_APP10_IPV1
}
