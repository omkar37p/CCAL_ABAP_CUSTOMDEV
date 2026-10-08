@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Gate Entry - Header Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP01_RV
  as select from zsd_app01_tb1
  composition [0..*] of ZSD_APP01_IV1 as _Item
{
  key uuid          as Uuid,
      tokennum      as Tokennum,
      gidate        as Gidate,
      gitime        as Gitime,
      godate        as Godate,
      gotime        as Gotime,
      vehicleno     as Vehicleno,
      trucktyp      as Trucktyp,
      trspname      as Trspname,
      trspmode      as Trspmode,
      drivername    as Drivername,
      lrnumber      as Lrnumber,
      sonum         as Sonum,
      delvnum       as Delvnum,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      grswgt        as Grswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      netwgt        as Netwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      tarewgt       as Tarewgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      chbwgt        as Chbwgt,
      concrate      as Concrate,
      cylinder      as Cylinder,
      totcyln       as Totcyln,
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
      _Item
}
