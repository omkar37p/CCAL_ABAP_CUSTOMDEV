@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales invoice header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSD_APP11_HEADER
  as select from I_BillingDocumentBasic as hd
  left outer join zsd_form_db as Form on Form.billingdocument = hd.BillingDocument
  composition [0..*] of ZSD_APP11_ITEM as _Item
  
{
    key hd.BillingDocument,
        hd.BillingDocumentDate,
        hd.BillingDocumentType,
        hd.CompanyCode,
        hd.DistributionChannel,
        hd.Division,
        Form.attachment,
        Form.filename,
        Form.mimetype,
        _Item
}
