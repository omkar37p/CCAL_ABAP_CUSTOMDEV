@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales register ship to address'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSDCUS_REPORT 
as select from ZSD_REPORT_2RV
{
    key BillingDocument,
    key BillingDocumentItem,
    shipCustomer,
    shipcusCityName,
    shiptostate
}
group by BillingDocument,BillingDocumentItem,
         shipCustomer,shipcusCityName,shiptostate;
