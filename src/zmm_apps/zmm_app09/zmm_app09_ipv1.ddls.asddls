@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Maintenance'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP09_IPV1
  as projection on ZMM_APP09_IV1
{
  key Plant,
  key Deptid,
  key Uuid,
  key Bdgcode,
  key Itemno,
      @EndUserText.label: 'Budget Item Description'
      Bdgitxt,
      @EndUserText.label: 'Remarks'
      Remarks,
      @EndUserText.label: 'Currency'
      Curky,
      @Semantics.amount.currencyCode: 'Curky'
      @EndUserText.label: 'Budget Amount'
      Allcbdg,
      Actstss,
      //      @Semantics.largeObject:
      //      { mimeType: 'MimeType',
      //      fileName: 'Filename',
      //      contentDispositionPreference: #INLINE }
      //      Attachment,
      //      @Semantics.mimeType: true
      //      Mimetype,
      //      Filename,
      @Semantics.user.createdBy: true
      Localcreatedby,
      @Semantics.systemDateTime.createdAt: true
      Localcreatedat,
      @Semantics.user.lastChangedBy: true
      Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat,
      /* Associations */
      _Header : redirected to parent ZMM_APP09_RPV
}
