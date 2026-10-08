@EndUserText.label: 'PO Header Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZI_PO_HDR_PV
  provider contract transactional_query
  as projection on ZI_PO_HDR
{
    key PoId,
    DocType,
    CompanyCode,
    Vendor,
    PurchOrg,
    PurchGrp,
    DocDate,
    CreatedBy,
    CreatedOn,
    _Item : redirected to composition child ZI_PO_ITM_PV
}
