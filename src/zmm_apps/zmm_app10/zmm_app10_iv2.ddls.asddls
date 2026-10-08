@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry - Non PO Child Entity2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP10_IV2
  as select from zmm_app10_tb3
  association to parent ZMM_APP10_RV as _Header on $projection.Uuid = _Header.Uuid
{
  key uuid          as Uuid,
  key ticketnum     as Ticketnum,
      gotime        as Gotime,
      godate        as Godate,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      ogrswgt       as Ogrswgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      onetwgt       as Onetwgt,
      @Semantics.quantity.unitOfMeasure: 'Wgtunit'
      oitarewgt     as Oitarewgt,
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
      _Header
}
