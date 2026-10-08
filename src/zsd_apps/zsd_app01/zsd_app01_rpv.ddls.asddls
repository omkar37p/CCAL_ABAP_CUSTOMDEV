@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Gate Entry - Header PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP01_RPV
  provider contract transactional_query
  as projection on ZSD_APP01_RV
{
  key Uuid,
      Tokennum,
      Gidate,
      Gitime,
      Godate,
      Gotime,
      Vehicleno,
      Trucktyp,
      Trspname,
      Trspmode,
      Drivername,
      Lrnumber,
      Sonum,
      Delvnum,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Grswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Netwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Tarewgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Chbwgt,
      Concrate,
      Cylinder,
      Totcyln,
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
      _Item : redirected to composition child ZSD_APP01_IPV1
}
