@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Slip - Gate In Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
///*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZSD_APP02_RV
  as select from zsd_app02_tb3
  composition [0..*] of ZSD_APP02_IV as _Item
{
  key uuid          as Uuid,
      tokennum      as Tokennum,
      gidate        as Gidate,
      gitime        as Gitime,
      godate        as Godate,
      gotime        as Gotime,
      trwdate       as trwdate,
      trwtime       as trwtime,
      plant         as Plant,
      plantname     as Plantname,
      vehicleno     as Vehicleno,
      trucktyp      as Trucktyp,
      trspname      as Trspname,
      trspmode      as Trspmode,
      drivername    as Drivername,
      lrnumber      as Lrnumber,
      material      as Material,
      matdesc       as Matdesc,
      batch         as Batch,
      sloc          as Sloc,
      division      as Division,
      divname       as Divname,
      divmark       as Divmark,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      tarewgt       as Tarewgt,
      wgtunit       as Wgtunit,
      status        as Status,
      mark          as Mark,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat,
      _Item
}
//where
//  mark <> 'X'
