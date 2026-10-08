@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Maintenance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP09_IV1
  as select from zmm_app09_tb2
  association to parent ZMM_APP09_RV as _Header on  $projection.Plant  = _Header.Plant
                                                and $projection.Deptid = _Header.Deptid
                                                and $projection.Uuid   = _Header.Uuid

{
  key plant              as Plant,
  key deptid             as Deptid,
  key uuid               as Uuid,
  key bdgcode            as Bdgcode,
  key itemno             as Itemno,
      bdgitxt            as Bdgitxt,
      remarks            as Remarks,
      curky              as Curky,
      @Semantics.amount.currencyCode: 'Curky'
      allcbdg            as Allcbdg,
      actstss            as Actstss,
      //      @Semantics.largeObject:
      //      { mimeType: 'Mimetype',
      //      fileName: 'Filename',
      //      contentDispositionPreference: #INLINE }
      //      attachment         as Attachment,
      //      @Semantics.mimeType: true
      //      mimetype           as Mimetype,
      //      filename           as Filename,
      @Semantics.user.createdBy: true
      localcreatedby     as Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      localcreatedat     as Localcreatedat,
      @Semantics.user.lastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,
      _Header
}
