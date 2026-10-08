@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Slip - Gate Out Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP02_IV
  as select from zsd_app02_tb2
  association to parent ZSD_APP02_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key    uuid          as Uuid,
  key    tokennum      as Tokennum,
         godate        as Godate,
         gotime        as Gotime,
         grsdate       as Grsdate,
         grstime       as Grstime,
         material      as Material,
         matdesc       as Matdesc,
         batch         as Batch,
         sloc          as Sloc,
         @Semantics.quantity.unitOfMeasure: 'Wgtunit'
         grswgt        as Grswgt,
         @Semantics.quantity.unitOfMeasure: 'Wgtunit'
         netwgt        as Netwgt,
         @Semantics.quantity.unitOfMeasure: 'Wgtunit'
         tarewgt       as Tarewgt,
         @Semantics.quantity.unitOfMeasure: 'Wgtunit'
         chbwgt        as Chbwgt,
         concrate      as Concrate,
         concnrate     as Concnrate,
         cylinder      as Cylinder,
         @Semantics.quantity.unitOfMeasure: 'Wgtunit'
         cylnvol       as Cylnvol,
         sealnum       as Sealnum,
         remarks       as Remarks,
         frgtrms       as Frgtrms,
         dlvplace      as Dlvplace,
         totcyln       as Totcyln,
         wgtunit       as Wgtunit,
         mark          as Mark,
         loadsts       as Loadsts,
         contnum       as Contnum,
         contitem      as Contitem,
         sonum         as Sonum,
         soitem        as Soitem,
         custref       as Custref,
         delvnum       as Delvnum,
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
