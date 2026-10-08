@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out Projection View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZSD_APP06_PV  provider contract transactional_query
  as projection on ZSD_APP06_RV
{
    key Delvnum,
    Uuid,
    Tokennum,
    Gidate,
    Gitime,
    Godate,
    Gotime,
    trwdate,
    trwtime,
    Plant,
    Plantname,
    Vehicleno,
    Trucktyp,
    Trspname,
    Trspmode,
    Drivername,
    Lrnumber,
    Material,
    Matdesc,
    Batch,
    Sloc,
    Division,
    Divname,
    Divmark,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    Tarewgt,
    Wgtunit,
    Status,
    Mark,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    TAREWG,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    Grswgt,
    Concnrate,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    Chbwgt,
    Grsdate,
    Grstime,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    Netwgt,
    Totcyln,
    @Semantics.quantity.unitOfMeasure: 'Wgtunit'
    Cylnvol,
    Sealnum,
    Frgtrms,
    Dlvplace,
    Remarks,
    Loadsts,
    /* Associations */
    _delv : redirected to composition child ZSD_APP06_PVC1 ,
    _delv2 : redirected to composition child ZSD_APP06_PVC2
}
