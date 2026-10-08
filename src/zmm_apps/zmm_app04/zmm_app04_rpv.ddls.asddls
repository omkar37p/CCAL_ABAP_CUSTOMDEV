@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase - GateIn Header Data'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP04_RPV
  provider contract transactional_query
  as projection on ZMM_APP04_RV
{
  key Uuid,
      Ticketnum,
      Tckdate,
      Tcktime,
      Tcktim,
      Taredate,
      Taretime,
      Grsdate,
      Grstime,
      Grstim,
      @EndUserText.label: 'Gate ID'
      Gateid,
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plantname' ]
      Plant,
      Plantname,
      Vehicleno,
      Veninvno,
      @EndUserText.label: 'Wheeler Type'
      Trcuktyp,
      @EndUserText.label: 'Contact Person'
      Drivername,
      @EndUserText.label: 'LR Number'
      Lrnumber,
      @EndUserText.label: 'Transporter'
      Trspname,
      Nonporef,
      Ebeln,
      @EndUserText.label: 'Mode of Transport'
      Trspmode,
      Remarks,
      Loadsts,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      @EndUserText.label: 'Gross Weight'
      Igrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      @EndUserText.label: 'Net Weight'
      Inetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      @EndUserText.label: 'Tare Weight'
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
      _Gout : redirected to composition child ZMM_APP04_IPV2,
      _Item : redirected to composition child ZMM_APP04_IPV1
}
