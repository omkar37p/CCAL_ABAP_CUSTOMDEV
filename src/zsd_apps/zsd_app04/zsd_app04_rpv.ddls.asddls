@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Delivery Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP04_RPV
  provider contract transactional_query
  as projection on ZSD_APP04_RV
{
  key Uuid,
      Tokennum,
      Gidate,
      Gitime,
      @ObjectModel.text.element: [ 'Plantname' ]
      Plant,
      Plantname,
      Vehicleno,
      Trucktyp,
      Trspname,
      Trspmode,
      Drivername,
      Lrnumber,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Tarewgt,
      Wgtunit,
      Status,
      Mark,
      @ObjectModel.text.element: [ 'matdesc' ]
      material,
      matdesc,
      batch,
      sloc,
      Division,
      Divmark,
      Divname,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      grswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      netwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      chbwgt,
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
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Cylnvol,
      Remarks,
      Loadsts
}
