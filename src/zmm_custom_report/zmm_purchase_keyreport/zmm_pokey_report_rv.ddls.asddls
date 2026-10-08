@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Key Register Report - RV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_POKEY_REPORT_RV
  as select distinct from I_PurchaseOrderAPI01           as _POH
    inner join            I_PurchaseOrderItemAPI01       as _POI  on _POI.PurchaseOrder = _POH.PurchaseOrder
    left outer join       I_PurchaseRequisitionItemAPI01 as _PRI  on  _PRI.PurchasingDocument     = _POI.PurchaseOrder
                                                                  and _PRI.PurchasingDocumentItem = _POI.PurchaseOrderItem
    left outer join       I_MaterialDocumentItem_2       as _MIGO on  _MIGO.PurchaseOrder     = _POI.PurchaseOrder
                                                                  and _MIGO.PurchaseOrderItem = _POI.PurchaseOrderItem
    left outer join       I_SuplrInvcItemPurOrdRefAPI01  as _MIRO on  _MIRO.ReferenceDocument           = _MIGO.MaterialDocument
                                                                  and _MIRO.ReferenceDocumentFiscalYear = _MIGO.MaterialDocumentYear
                                                                  and _MIRO.ReferenceDocumentItem       = _MIGO.MaterialDocumentItem
    left outer join       ZMM_PO_TAX                     as Tax   on  Tax.PurchaseOrder     = _POI.PurchaseOrder
                                                                  and Tax.PurchaseOrderItem = _POI.PurchaseOrderItem

    left outer join       ZMM_JVPARTIAL_AMT                    as _vend on  _vend.ReferenceDocument = _MIRO.SupplierInvoice
                                                                  and _vend.FiscalYear        = _MIRO.FiscalYear
    left outer join       I_JournalEntry                 as JOH   on  JOH.AccountingDocument = _vend.AccountingDocument
                                                                  and JOH.CompanyCode        = _vend.CompanyCode
                                                                  and JOH.FiscalYear         = _vend.FiscalYear
    association [1..1] to I_Supplier           as _SUP   on  _SUP.Supplier = _POH.Supplier
    association [1..1] to I_ProductDescription as _PRDES on  _PRDES.Product  = _POI.Material
                                                       and _PRDES.Language = $session.system_language
    association [1..1] to I_BusinessUserBasic  as _uname on  _uname.UserID = _POH.CreatedByUser

{
  key _POI.PurchaseOrder,
  key _POI.PurchaseOrderItem,
  key _POI.PurchaseRequisition,
  

  key  _vend.Accno, 
      _POH.PurchaseOrderType,
      _POH.PurchaseOrderDate,
      _POH.CompanyCode,
      _POH.CreatedByUser,
      _POH.PaymentTerms,
      _POH.IncotermsClassification,
      _POH.Supplier                                            as Vendor,
      _POI.Plant,
      _POI.Material,
      _POI.BaseUnit,
      _POI.YY1_budget_code_PDI,
      _POI.YY1_bdgdesc_PDI,
      _POI.DocumentCurrency,
      cast(_POI.OrderQuantity as abap.dec( 15, 3 ))            as PoQty,
      cast(_POI.NetAmount as abap.dec( 15, 2 ))                as UnitPrice,
      cast(_POI.NetAmount as abap.dec( 15, 2 ))                as TaxableValue,
      Tax.CGSTAmount,
      Tax.SGSTAmount,
      Tax.IGSTAmount,
      Tax.DiscountAmt,
      _PRI.CreationDate                                        as PurchaseReqCreationDate,
      cast(_MIGO.QuantityInEntryUnit as abap.dec( 15, 3 ))     as RecQty,
      _MIGO.MaterialDocument,
      _MIGO.MaterialDocumentItem,
      _MIGO.MaterialDocumentYear,
      _MIGO.DocumentDate,
      _MIRO.SupplierInvoice,
      _MIRO.SupplierInvoiceItem,
      //      (cast(_POI.NetAmount as abap.dec( 15, 2 ))+Tax.IGSTAmount+Tax.CGSTAmount+Tax.SGSTAmount) as GrossAmount,
      case
            when Tax.IGSTAmount is not initial then
                    cast(_POI.NetAmount as abap.dec( 15, 2 )) + Tax.IGSTAmount
            when Tax.CGSTAmount is not initial and Tax.SGSTAmount is not initial then
                    cast(_POI.NetAmount as abap.dec( 15, 2 )) + Tax.CGSTAmount + Tax.SGSTAmount
            else cast(_POI.NetAmount as abap.dec( 15, 2 )) end as GrossAmount,
            
//      _vend.ClearingDate                                       as Vendorpaymentdate,
//      _vend.ClearingJournalEntry                               as vendorpaymentno,
//      _vend.ClearingAmt,
      _vend.PaymentAmount,
        case    
            when _vend.ClearingJournalEntry is not initial then _vend.ClearingJournalEntry
            when _vend.ClearingJournalEntry is initial then _vend.Accno
            else null end as vendorpaymentno,
        case
            when _vend.ClearingJournalEntry is not initial then _vend.ClearingDate
             when _vend.ClearingJournalEntry is initial then _vend.PostingDate
            else null end as  Vendorpaymentdate,
        case
            when _vend.ClearingJournalEntry is not initial then _vend.ClearingAmt
             when _vend.ClearingJournalEntry is initial then _vend.PaymentAmount
            else null end as VendorPayAmt,
                   
      _vend.AccountingDocument,
      _vend.AccountingDocumentItem,
      _vend.accitem,
      JOH.DocumentReferenceID as InvoiceNumber,
      cast(_POI.DownPaymentAmount as abap.dec( 15, 2 )) as Downpayment,
     

      _PRDES,
      _SUP,
      _uname
}
