@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Header Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PO_HDR 
as select from zpo_hdr_dt
composition [0..*] of ZI_PO_ITM as _Item
{
    key po_id as PoId,
    doc_type as DocType,
    company_code as CompanyCode,
    vendor as Vendor,
    purch_org as PurchOrg,
    purch_grp as PurchGrp,
    doc_date as DocDate,
    created_by as CreatedBy,
    created_on as CreatedOn,
    _Item 
}
