@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales invoice header PV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZSD_APP11_HEADER_PV
  provider contract transactional_query
  as projection on ZSD_APP11_HEADER
{
  key BillingDocument,
      BillingDocumentDate,
      BillingDocumentType,
      CompanyCode,
      DistributionChannel,
      Division,
      @Semantics.largeObject:{
      mimeType: 'mimetype',
      fileName: 'filename',
      contentDispositionPreference: #INLINE
      }
      attachment,
      filename,
      mimetype,
      /* Associations */
      _Item : redirected to composition child ZSD_APP11_ITEM_PV      
}
