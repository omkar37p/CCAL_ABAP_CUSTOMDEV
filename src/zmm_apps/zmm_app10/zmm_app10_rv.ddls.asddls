@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP10_RV
  as select from zmm_app10_tb1
  composition [0..*] of ZMM_APP10_IV1 as _Item
  composition [0..*] of ZMM_APP10_IV2 as _Gout
{
  key uuid          as Uuid,
      ticketnum     as Ticketnum,
      tckdate       as Tckdate,
      tcktime       as Tcktime,
      plant         as Plant,
      plantname     as Plantname,
      vehicleno     as Vehicleno,
      veninvno      as Veninvno,
      trcuktyp      as Trcuktyp,
      drivername    as Drivername,
      lrnumber      as Lrnumber,
      trspname      as Trspname,
      vendname      as Vendname,
      nonporef      as Nonporef,
      trspmode      as Trspmode,
      remarks       as Remarks,
      loadsts       as Loadsts,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      igrswgt       as Igrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      inetwgt       as Inetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      itarewgt      as Itarewgt,
      wgtunit       as Wgtunit,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      _Item,
      _Gout

}
