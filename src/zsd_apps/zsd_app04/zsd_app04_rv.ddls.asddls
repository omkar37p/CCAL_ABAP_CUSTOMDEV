@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Delivery Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP04_RV
  as select from zsd_app02_tb3 as t1
    inner join   zsd_app02_tb2 as t2 on  t2.uuid     = t1.uuid
                                     and t2.tokennum = t1.tokennum
{
  key t1.uuid       as Uuid,
      t1.tokennum   as Tokennum,
      t1.gidate     as Gidate,
      t1.gitime     as Gitime,
      t1.plant      as Plant,
      t1.plantname  as Plantname,
      t1.vehicleno  as Vehicleno,
      t1.trucktyp   as Trucktyp,
      t1.trspname   as Trspname,
      t1.trspmode   as Trspmode,
      t1.drivername as Drivername,
      t1.lrnumber   as Lrnumber,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      t1.tarewgt    as Tarewgt,
      t1.wgtunit    as Wgtunit,
      t1.status     as Status,
      t1.mark       as Mark,
      t1.material   as material,
      t1.matdesc    as matdesc,
      t1.batch      as batch,
      t1.sloc       as sloc,
      t1.division   as Division,
      t1.divmark    as Divmark,
      t1.divname    as Divname,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      t2.grswgt     as grswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      t2.netwgt     as netwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      t2.chbwgt     as chbwgt,
      t2.concnrate  as concnrate,
      t2.concrate   as concrate,
      t2.contnum    as Contnum,
      t2.contitem   as Contitem,
      t2.sonum      as sonum,
      t2.soitem     as soitem,
      t2.custref    as Custref,
      t2.delvnum    as delvnum,
      t2.sealnum    as Sealnum,
      t2.totcyln    as Totcyln,
      t2.frgtrms    as Frgtrms,
      t2.dlvplace   as Dlvplace,
      @Semantics.quantity.unitOfMeasure : 'Wgtunit'
      t2.cylnvol    as Cylnvol,
      t2.remarks    as Remarks,
      t2.loadsts    as Loadsts

}
where
      t1.mark   = 'X'
  and t1.status = 'LOADED'
