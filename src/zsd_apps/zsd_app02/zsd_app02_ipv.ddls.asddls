@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing Slip - Gate Out Child PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP02_IPV
  as projection on ZSD_APP02_IV
{
  key Uuid,
  key Tokennum,
      Godate,
      Gotime,
      Grsdate,
      Grstime,
      @ObjectModel.text.element: [ 'Matdesc' ]
      Material,
      Matdesc,
      Batch,
      Sloc,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Grswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Netwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Tarewgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Chbwgt,
      Concrate,
      Concnrate,
      Cylinder,
      Totcyln,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      Cylnvol,
      Sealnum,
      Remarks,
      Frgtrms,
      Dlvplace,
      @Semantics.unitOfMeasure: true
      Wgtunit,
      Mark,
      Loadsts,
      Contnum,
      Contitem,
      Sonum,
      Soitem,
      Custref,
      Delvnum,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZSD_APP02_RPV
}
