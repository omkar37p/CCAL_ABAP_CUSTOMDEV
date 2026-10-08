@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZSD_APP06_RV as select from ZSD_APP02_RV as GTIN 
left outer join  ZSD_APP02_IV as _GTOUT on _GTOUT.Uuid = GTIN.Uuid and _GTOUT.Tokennum = GTIN.Tokennum
composition[0..1] of ZSD_APP06_RVC1 as _delv
composition[0..1] of ZSD_APP06_RVC2 as _delv2
{
   key _GTOUT.Delvnum,
    GTIN.Uuid,
    GTIN.Tokennum,
   GTIN.Gidate,
   GTIN.Gitime,
   GTIN.Godate,
   GTIN.Gotime,
   GTIN.trwdate,
   GTIN.trwtime,
   GTIN.Plant,
   GTIN.Plantname,
   GTIN.Vehicleno,
   GTIN.Trucktyp,
   GTIN.Trspname,
   GTIN.Trspmode,
   GTIN.Drivername,
   GTIN.Lrnumber,
   GTIN.Material,
   GTIN.Matdesc,
   GTIN.Batch,
   GTIN.Sloc,
   GTIN.Division,
   GTIN.Divname,
   GTIN.Divmark,
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   GTIN.Tarewgt,
   GTIN.Wgtunit,
   GTIN.Status,
   GTIN.Mark,
   @Semantics.user.createdBy: true
   GTIN.Createdby,
   @Semantics.systemDateTime.createdAt: true
   GTIN.Createdat,
   @Semantics.user.lastChangedBy: true
   GTIN.Lastchangedby,
   @Semantics.systemDateTime.lastChangedAt: true
   GTIN.Lastchangedat,
   /* Associations */
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   _GTOUT.Tarewgt as TAREWG,
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   _GTOUT.Grswgt,
   _GTOUT.Concnrate,
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   _GTOUT.Chbwgt,
   _GTOUT.Grsdate,
   _GTOUT.Grstime,
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   _GTOUT.Netwgt,
   _GTOUT.Totcyln,
   @Semantics.quantity.unitOfMeasure: 'Wgtunit'
   _GTOUT.Cylnvol,
   _GTOUT.Sealnum,
   _GTOUT.Frgtrms,
   _GTOUT.Dlvplace,
   _GTOUT.Remarks,
   _GTOUT.Loadsts,
    
    _delv,
    _delv2
   
}
where _GTOUT.Delvnum is not initial 
