@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AutoPay Bank Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_AUTOBANK
  as select from zautopay_bank
  association to parent ZI_AUTOENROLLMENT as _Header
    on $projection.ParentUUID = _Header.Uuid
{
  key uuid          as Uuid,
      parent_uuid   as ParentUuid,
      bankaccount   as Bankaccount,
      routingnumber as Routingnumber,
      accounttype   as Accounttype,
      paymenttoken  as Paymenttoken,
      createdby     as Createdby,
      createdat     as Createdat,
      lastchangedat as Lastchangedat,
      _Header
}
