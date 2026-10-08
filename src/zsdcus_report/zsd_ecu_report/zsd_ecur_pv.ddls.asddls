@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register ECU Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@Search.searchable: true
define root view entity ZSD_ECUR_PV  
provider contract transactional_query
  as projection on ZSD_ECUR_RV
{

    key VoucherNo,
    key BillingDocumentItem,
    key customerCode,
    key DeliveryDocument,
    key DeliveryDocumentItem,
    BillDate,
    BillingDocumentType,
    VoucherType,
    ODNNumber,
    Product,
    Plant,
    BaseUnit,
    BillingDocumentItemText,
    BaseValue,
    Quantity,
    CustomerName,
    curr,
    @Semantics.amount.currencyCode: 'curr'
    TaxbleValue,
    Freight,
    igstvalue,
    cgstvalue,
    sgstvalue,
    tcsvalue,
    InvoiceValue,
    ShipToParty,
    shipcustomername,
    CreationTime
    
}
