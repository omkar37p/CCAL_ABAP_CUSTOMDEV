@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Slip - Gate In Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP02_RPV
  provider contract transactional_query
  as projection on ZSD_APP02_RV
{
  key Uuid,
      Tokennum,
      Gidate,
      Gitime,
      Godate,
      Gotime,
      Trwdate,
      Trwtime,
      @ObjectModel.text.element: [ 'Plantname' ]
      Plant,
      Plantname,
      Vehicleno,
      Trucktyp,
      Trspname,
      Trspmode,
      Drivername,
      Lrnumber,
      @ObjectModel.text.element: [ 'Matdesc' ]
      Material,
      Matdesc,
      Batch,
      Sloc,
      @ObjectModel.text.element: [ 'Divname' ]
      Division,
      Divname,
      Divmark,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Tarewgt,
      @Semantics.unitOfMeasure: true
      Wgtunit,
      Status,
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
      _Item : redirected to composition child ZSD_APP02_IPV
}
