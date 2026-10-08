@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Screen View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSDAPP04 as select from ZSD_APP04_RV
{
    key Uuid,
    Tokennum,
    Gidate,
    Gitime,
    Plant,
    Plantname,
    Vehicleno,
    Trucktyp,
    Trspname,
    Trspmode,
    Drivername,
    Lrnumber,
    cast(Tarewgt as abap.dec( 9, 3 )) as Tarwgt,
    Wgtunit,
    Status,
    Mark,
    material,
    matdesc,
    batch,
    sloc,
    Division,
    Divmark,
    Divname,
    cast(grswgt as abap.dec( 9, 3 )) as grswgt,
    cast(netwgt as abap.dec( 9, 3 )) as netwgt,
    cast(chbwgt as abap.dec( 9, 3 )) as chbwgt,
    concnrate,
    concrate,
    Contnum,
    Contitem,
    sonum,
    soitem,
    Custref,
    delvnum,
    Sealnum,
    Totcyln,
    Frgtrms,
    Dlvplace,
    cast(Cylnvol as abap.dec( 9, 3 )) as Cylnvol,
    Remarks,
    Loadsts
}
