@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase - GateOut Header Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP04_IV2
  as select from zmm_app04_tb3
  association to parent ZMM_APP04_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid          as Uuid,
  key ticketnum     as Ticketnum,
      vhlistid      as Vhlistid,
      pcklistid     as Pcklistid,
      gotime        as Gotime,
      gotim         as Gotim,
      wghgotim      as Wghgotim,
      godate        as Godate,
      wghgodate     as Wghgodate,
      wghgotime     as Wghgotime,
      vehicleno     as Vehicleno,
      veninvno      as Veninvno,
      trcuktyp      as Trcuktyp,
      drivername    as Drivername,
      lrnumber      as Lrnumber,
      trspname      as Trspname,
      trspmode      as Trspmode,
      concrate      as Concrate,
      cylinder      as Cylinder,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      ogrswgt       as Ogrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      onetwgt       as Onetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      oitarewgt     as Oitarewgt,
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
      _Header
}
