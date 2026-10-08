@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Custom Report Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_GSTR1_RV as select from I_JournalEntry as JEH
                              inner join I_JournalEntryItem as Jei  on  Jei.AccountingDocument = JEH.AccountingDocument
                                                                    and Jei.FiscalYear = JEH.FiscalYear
                                                                    and Jei.CompanyCode = JEH.CompanyCode
                                                                    and Jei.Ledger = '0L'
                                                                    and (Jei.AccountingDocumentType = 'RV' or Jei.AccountingDocumentType = 'DG' or
                                                                          Jei.AccountingDocumentType = 'DZ' or
                                                                         Jei.AccountingDocumentType = 'DA' or Jei.AccountingDocumentType = 'DR')
                              left outer join I_BillingDocumentItem as BDI on BDI.BillingDocument = Jei.ReferenceDocument
                                                                    and BDI.BillingDocumentItem = Jei.ReferenceDocumentItem
                              left outer join I_BillingDocument as BDC on BDC.BillingDocument = BDI.BillingDocument
                              left outer join I_OperationalAcctgDocItem as DR_CUS  on  DR_CUS.AccountingDocument = Jei.AccountingDocument
                                                      and DR_CUS.FiscalYear         = Jei.FiscalYear
                                                      and DR_CUS.CompanyCode        = Jei.CompanyCode
                                                      and DR_CUS.FinancialAccountType = 'D'
                              
                              left outer join I_OperationalAcctgDocItem as ACC_IG  on  ACC_IG.AccountingDocument = Jei.AccountingDocument
                                                      and ACC_IG.FiscalYear         = Jei.FiscalYear
                                                      and ACC_IG.CompanyCode        = Jei.CompanyCode
                                                      and ACC_IG.TransactionTypeDetermination = 'JOI'
                                                      and ACC_IG.AccountingDocumentType != 'RV'
                              left outer join I_OperationalAcctgDocItem as ACC_CG  on  ACC_CG.AccountingDocument = Jei.AccountingDocument
                                                      and ACC_CG.FiscalYear         = Jei.FiscalYear
                                                      and ACC_CG.CompanyCode        = Jei.CompanyCode
                                                      and ACC_CG.TransactionTypeDetermination = 'JOC'
                                                      and ACC_CG.AccountingDocumentType != 'RV'
                              left outer join I_OperationalAcctgDocItem as ACC_SG  on  ACC_SG.AccountingDocument = Jei.AccountingDocument
                                                      and ACC_SG.FiscalYear         = Jei.FiscalYear
                                                      and ACC_SG.CompanyCode        = Jei.CompanyCode
                                                      and ACC_SG.TransactionTypeDetermination = 'JOS'
                                                      and ACC_SG.AccountingDocumentType != 'RV'

                                                      
                              left outer join I_BillingDocumentItemPrcgElmnt as IGST on  IGST.BillingDocument     = BDI.BillingDocument
                                                           and IGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and IGST.ConditionType       = 'JOIG'        //Standard IGST
                              left outer join I_BillingDocumentItemPrcgElmnt as ZGST on  ZGST.BillingDocument     = BDI.BillingDocument
                                                           and ZGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZGST.ConditionType       = 'ZIIG'        //Custom IGST
                             left outer join I_BillingDocumentItemPrcgElmnt as CGST on  CGST.BillingDocument     = BDI.BillingDocument
                                                           and CGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CGST.ConditionType       = 'JOCG'        //Standard CGST
                             left outer join I_BillingDocumentItemPrcgElmnt as ZCST on  ZCST.BillingDocument     = BDI.BillingDocument
                                                           and ZCST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZCST.ConditionType       = 'ZOCG'        //Custom CGST
                             left outer join I_BillingDocumentItemPrcgElmnt as SGST on  SGST.BillingDocument     = BDI.BillingDocument
                                                           and SGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and SGST.ConditionType       = 'JOSG'        //Standard SGST
                             left outer join I_BillingDocumentItemPrcgElmnt as ZSGT on  ZSGT.BillingDocument     = BDI.BillingDocument
                                                           and ZSGT.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZSGT.ConditionType       = 'ZOSG'        //Custom SGST
                             left outer join I_BillingDocumentItemPrcgElmnt as CESS on  CESS.BillingDocument     = BDI.BillingDocument
                                                           and CESS.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CESS.ConditionType       = 'JCOS'
                             left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on  ZFRI.BillingDocument     = BDI.BillingDocument
                                                           and ZFRI.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZFRI.ConditionType       = 'ZFRI' 
                                                           and ZFRI.ConditionAmount is not initial                                                          
                            left outer join I_ProductPlantBasic            as Hsn  on  Hsn.Product = BDI.Product
                                                           and Hsn.Plant   = BDI.Plant
                            left outer join I_Customer                     as cus  on cus.Customer = BDI.BillToParty
                            left outer join I_CustomerGroupText            as Cdc  on  Cdc.CustomerGroup = BDC.CustomerGroup
                                                           and Cdc.Language      = 'E'
                            left outer join I_Region                       as Reg  on  Reg.Country = BDC.Country
                                                           and Reg.Region  = BDC.Region

                            left outer join I_Plant                        as Pla  on Pla.Plant = BDI.Plant

                            left outer join I_IN_BusinessPlaceTaxDetail    as sup  on sup.BusinessPlace = Pla.BusinessPlace
                                                            and sup.CompanyCode = Pla.SalesOrganization
                            left outer join ZEWAY_EIN_CUS_VIEW as EWAY on EWAY.ElectronicDocSourceKey = BDC.BillingDocument
                            left outer join I_Customer                     as dr_cusn  on dr_cusn.Customer = DR_CUS.Customer
                            left outer join I_IN_BusinessPlaceTaxDetail    as dr_sup  on dr_sup.BusinessPlace = DR_CUS.BusinessPlace
                                                                                       and dr_sup.CompanyCode = DR_CUS.CompanyCode

{
   key JEH.CompanyCode as CompanyCode,
   key JEH.FiscalYear as FiscalYear,
   key JEH.AccountingDocument as AccountingDocument,
   key Jei.SourceLedger as SourceLedger,
   key Jei.LedgerGLLineItem as LedgerGLLineItem,
   key Jei.Ledger as Ledger,
   key BDI.BillingDocument      as billdoc,
   key BDI.BillingDocumentItem    as billitm,
   key Hsn.Product as hsnproduct,
   key cus.Customer as cuscustomer,
   key Cdc.Language,
   key Reg.Country,
   key Reg.Region,
   key Pla.Plant as plaplant,
   key sup.BusinessPlace as supBusinessPlace,
       JEH.TransactionCurrency,
       Jei.AccountingDocumentItem,
       Jei.TaxCode,
       Jei.GLAccount,
       Jei.PostingDate,
       Jei.DocumentDate,
       Jei.FiscalPeriod,
       Jei.CompanyCodeCurrency,
       Jei.Product,
       
      JEH.AccountingDocumentType,
      JEH.DocumentReferenceID,
      
      BDI.BillToPartyRegion,
      BDC.BillingDocumentType,
      BDC.AssignmentReference,
      case
//            when Jei.AccountingDocumentType = 'RV' and IGST.ConditionBaseValue is not initial then cast(IGST.ConditionBaseValue as abap.dec( 14, 2 ))
//            when Jei.AccountingDocumentType = 'RV' and CGST.ConditionBaseValue is not initial then (cast(CGST.ConditionBaseValue as abap.dec( 14, 2 )))
//            when Jei.AccountingDocumentType = 'DG' and IGST.ConditionBaseValue is not initial then cast(IGST.ConditionBaseValue as abap.dec( 14, 2 ))
//            when Jei.AccountingDocumentType = 'DG' and CGST.ConditionBaseValue is not initial then (cast(CGST.ConditionBaseValue as abap.dec( 14, 2 )))
            when Jei.AccountingDocumentType = 'RV' and BDI.NetAmount is not initial then (cast(BDI.NetAmount as abap.dec( 14, 2 )))     // new one 19.03.2025
            when Jei.AccountingDocumentType = 'DG' and BDI.NetAmount is not initial then (cast(BDI.NetAmount as abap.dec( 14, 2 )))     // new one 19.03.2025        
            when Jei.AccountingDocumentType = 'SA' and ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'SA' and ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then (cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )))
            when Jei.AccountingDocumentType = 'DZ' and ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DZ' and ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then (cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )))
            when Jei.AccountingDocumentType = 'DA' and ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DA' and ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then (cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )))
            when Jei.AccountingDocumentType = 'DR' and ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DR' and ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then (cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )))
            else null end as TaxableValue,
      case
            when Jei.AccountingDocumentType = 'RV' and IGST.ConditionAmount is not initial then  cast(IGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DG' and IGST.ConditionAmount is not initial then  cast(IGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'SA' and ACC_IG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DZ' and ACC_IG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DA' and ACC_IG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DR' and ACC_IG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            else null end as igstConditionAmount,
      case 
            when Jei.AccountingDocumentType = 'RV' and CGST.ConditionAmount is not initial then  cast(CGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DG' and CGST.ConditionAmount is not initial then  cast(CGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'SA' and ACC_CG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DZ' and ACC_CG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DA' and ACC_CG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DR' and ACC_CG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            else null end as cgstconditionamount,
      case 
            when Jei.AccountingDocumentType = 'RV' and SGST.ConditionAmount is not initial then  cast(SGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DG' and SGST.ConditionAmount is not initial then  cast(SGST.ConditionAmount as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'SA' and ACC_SG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DZ' and ACC_SG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DA' and ACC_SG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            when Jei.AccountingDocumentType = 'DR' and ACC_SG.AbsltAmtInAdditionalCurrency1 is not initial then  cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 ))
            else null end as sgstconditionamount,
      cast(CESS.ConditionAmount as abap.dec( 14, 2 )) as cessconditionamount,
      cast(ZFRI.ConditionAmount as abap.dec( 14, 2)) as freightAmount,
      case
//              when IGST.ConditionBaseValue is not initial then (cast(IGST.ConditionBaseValue as abap.dec( 14, 2 )) + cast(IGST.ConditionAmount as abap.dec( 14, 2 )))
              when Jei.AccountingDocumentType = 'RV' and BDI.NetAmount is not initial and BDI.TaxAmount is not initial      // new onw 19.03.2025
                        then (cast(BDI.NetAmount as abap.dec( 14, 2 )) + cast(BDI.TaxAmount as abap.dec( 14, 2 )))          // new onw 19.03.2025
              when Jei.AccountingDocumentType = 'RV' and BDI.NetAmount is not initial and BDI.TaxAmount is initial      // new onw 19.03.2025
                        then cast(BDI.NetAmount as abap.dec( 14, 2 ))  
                                    
              when Jei.AccountingDocumentType = 'DG' and BDI.NetAmount is not initial and BDI.TaxAmount is not initial      // new onw 19.03.2025
                        then (cast(BDI.NetAmount as abap.dec( 14, 2 )) + cast(BDI.TaxAmount as abap.dec( 14, 2 )))           // new onw 19.03.2025  
              when Jei.AccountingDocumentType = 'DG' and BDI.NetAmount is not initial and BDI.TaxAmount is initial      // new onw 19.03.2025
                        then cast(BDI.NetAmount as abap.dec( 14, 2 ))
                                           
              when ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then (cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )) + cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )))
              
//              when CGST.ConditionBaseValue is not initial then
//                      (cast(CGST.ConditionBaseValue as abap.dec( 14, 2 )) + cast(CGST.ConditionAmount as abap.dec( 14, 2 )) + cast(SGST.ConditionAmount as abap.dec( 14, 2 )) )
                      
              when ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy is not initial then
                      (cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )) + cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )) + cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )) )
              else null end as InvoiceValue,              
      case 
            when Jei.TaxCode = 'AA' then '5%'
            when Jei.TaxCode = 'AB' then '12%'      
            when Jei.TaxCode = 'AC' then '18%'
            when Jei.TaxCode = 'AD' then '28%'      
            when Jei.TaxCode = 'AE' then '0%'
            when Jei.TaxCode = 'AG' then '12%'      
            when Jei.TaxCode = 'AH' then '18%'
            when Jei.TaxCode = 'AI' then '28%'      
            when Jei.TaxCode = 'AO' then '5%'
            when Jei.TaxCode = 'T0' then '1%' 
            when Jei.TaxCode = 'AQ' then '0.1%'                  
            else null end as TaxPerc,
            
      EWAY.IN_ElectronicDocEWbillNmbr as E_WayBillNo,
      EWAY.IN_EDocEWbillCreateDate as E_WayBilldate,
      EWAY.IN_ElectronicDocAcknNmbr as Einvoiceno,
      EWAY.IN_ElectronicDocAcknDate as Einvoicedate,
      
      ACC_IG.TransactionTypeDetermination,
      cast(ACC_IG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )) as Taxamount,
      cast(ACC_IG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )) as AmountValue,
      
      cast(ACC_CG.TaxAbsltBaseAmountInCoCodeCrcy as abap.dec( 14, 2 )) as cgtamount,
      cast(ACC_CG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )) as cgTax,
      cast(ACC_SG.AbsltAmtInAdditionalCurrency1 as abap.dec( 14, 2 )) as sgTax,

      case Jei.FiscalPeriod

      when '001'

      then concat(abap.char'Apr,', substring(Jei.FiscalYear, 3, 2))

      when '002'

      then concat(abap.char'May,',substring(Jei.FiscalYear, 3, 2))

      when '003'

      then concat(abap.char'Jun,',substring(Jei.FiscalYear, 3, 2))

      when '004'

      then concat(abap.char'Jul,',substring(Jei.FiscalYear, 3, 2))

      when '005'

      then concat(abap.char'Aug,',substring(Jei.FiscalYear, 3, 2))

      when '006'

      then concat(abap.char'Sep,',substring(Jei.FiscalYear, 3, 2))

      when '007'

      then concat(abap.char'Oct,',substring(Jei.FiscalYear, 3, 2))

      when '008'

      then concat(abap.char'Nov,',substring(Jei.FiscalYear, 3, 2))

      when '009'

      then concat(abap.char'Dec,',substring(Jei.FiscalYear, 3, 2))

      when '010'

      then concat(abap.char'Jan,',substring(Jei.FiscalYear, 3, 2))

      when '011'

      then concat(abap.char'Feb,',substring(Jei.FiscalYear, 3, 2))

      when '012'

      then concat(abap.char'Mar,',substring(Jei.FiscalYear, 3, 2))

      else null end                                                                                                                                             as GSTR1RETURNPERIOD,



      case Jei.FiscalPeriod

      when '001'

      then concat(abap.char'Apr,', substring(Jei.FiscalYear, 3, 2))

      when '002'

      then concat(abap.char'May,',substring(Jei.FiscalYear, 3, 2))

      when '003'

      then concat(abap.char'Jun,',substring(Jei.FiscalYear, 3, 2))

      when '004'

      then concat(abap.char'Jul,',substring(Jei.FiscalYear, 3, 2))

      when '005'

      then concat(abap.char'Aug,',substring(Jei.FiscalYear, 3, 2))

      when '006'

      then concat(abap.char'Sep,',substring(Jei.FiscalYear, 3, 2))

      when '007'

      then concat(abap.char'Oct,',substring(Jei.FiscalYear, 3, 2))

      when '008'

      then concat(abap.char'Nov,',substring(Jei.FiscalYear, 3, 2))

      when '009'

      then concat(abap.char'Dec,',substring(Jei.FiscalYear, 3, 2))

      when '010'

      then concat(abap.char'Jan,',substring(Jei.FiscalYear, 3, 2))

      when '011'

      then concat(abap.char'Feb,',substring(Jei.FiscalYear, 3, 2))

      when '012'

      then concat(abap.char'Mar,',substring(Jei.FiscalYear, 3, 2))

      else null end   
                        as BAUTOFILLPERIOD,
      
      BDC.BillingDocumentDate as billdate,
      BDC.BillingDocumentDate as Fidocdate,
      BDC.StatisticsCurrency     as stcurr,

      BDI.BillingDocumentItemText as itmtxt,
      BDI.BaseUnit                as uom,
      //      bdi.PriceDetnExchangeRate  as Pexch,
      @Semantics.quantity.unitOfMeasure: 'uom'
      BDI.BillingQuantity         as billqty,
      BDC.Division as Divisionb,

      case when BDC.BillingDocumentType = 'F2' then 'Tax Invoice'
            when BDC.BillingDocumentType = 'G2' then 'CDNR'
      else null end   as BillingType,
      case BDC.BillingDocumentType

      when 'G2'

      then(BDC.DocumentReferenceID)

      else null end as Notenumber,    
      
      case

      when BDI.TaxCode = 'AA' then 'Normal'

      when BDI.TaxCode = 'AB'then 'Normal'

      when BDI.TaxCode = 'AC'then 'Nil Rated'

      when BDI.TaxCode = 'AD'then 'Normal'

      when BDI.TaxCode = 'AE'then 'Normal'

      when BDI.TaxCode = 'AF'then 'Normal'

      when BDI.TaxCode = 'AG'then 'Normal'

      when BDI.TaxCode = 'AH'then 'Normal'

      when BDI.TaxCode = 'AI'then 'Normal'

      when BDI.TaxCode = 'AJ'then 'Normal'

      when BDI.TaxCode = 'AK'then 'Normal'

      when BDI.TaxCode = 'AL'then 'Nil Rated'

      when BDI.TaxCode = 'AM'then 'Normal'

      when BDI.TaxCode = 'AN'then 'Normal'

      when BDI.TaxCode = 'AO'then 'Normal'

      when BDI.TaxCode = 'AP'then 'Normal'

      when BDI.TaxCode = 'AQ'then 'Normal'

      when BDI.TaxCode = 'AR'then 'Normal'

      else null end as Supply,
      
      case when BDC.DistributionChannel = '02'then 'WPAY'

           when BDC.DistributionChannel = '04'then 'SEWOP'

            when  BDC.DistributionChannel = '02' and BDC.CustomerGroup = '09'then 'WOPAY'

            else null end   as ExportType,
                  
      case
            when cus.Customer is not initial then cus.Customer
            when dr_cusn.Customer is not initial then dr_cusn.Customer
            else null end as cuscode,      
      case
            when cus.CustomerName  is not initial then cus.CustomerName
            when dr_cusn.CustomerName is not initial then dr_cusn.CustomerName
            else null end as custname,
      case 
            when cus.TaxNumber3 is not initial then cus.TaxNumber3
            when dr_cusn.TaxNumber3 is not initial then dr_cusn.TaxNumber3
            else null end as taxno2,     
      DR_CUS.Customer,
       case
            when cus.TaxNumber3 is not initial then 'REGISTERD'
            when cus.TaxNumber3 is initial then 'UNREGISTERD'
        else null 
          end as UR_Type,
            
      Hsn.ConsumptionTaxCtrlCode  as hsncode,
      case 
            when sup.IN_GSTIdentificationNumber is not initial then sup.IN_GSTIdentificationNumber
            when dr_sup.IN_GSTIdentificationNumber is not initial then dr_sup.IN_GSTIdentificationNumber
            else null end as SupplierGSTIN,

      case
          when cus.Region = 'AN' then '35-AN' -- Andaman and Nicobar Islands
          when dr_cusn.Region = 'AN' then '35-AN' -- Andaman and Nicobar Islands
          when cus.Region = 'AP' then '37-AP' -- Andhra Pradesh
          when dr_cusn.Region = 'AP' then '37-AP' -- Andhra Pradesh
          when cus.Region = 'AR' then '12-AR' -- Arunachal Pradesh
          when dr_cusn.Region = 'AR' then '12-AR' -- Arunachal Pradesh
          when cus.Region = 'AS' then '18-AS' -- Assam
          when dr_cusn.Region = 'AS' then '18-AS' -- Assam
          when cus.Region = 'BR' then '10-BR' -- Bihar
          when dr_cusn.Region = 'BR' then '10-BR' -- Bihar
          when cus.Region = 'CG' then '22-CG' -- Chhattisgarh
          when dr_cusn.Region = 'CG' then '22-CG' -- Chhattisgarh
          when cus.Region = 'CH' then '04-CH' -- Chandigarh
          when dr_cusn.Region = 'CH' then '04-CH' -- Chandigarh
          when cus.Region = 'DD' then '26-DD' -- Dadra and Nagar Haveli and Daman and Diu
          when dr_cusn.Region = 'DD' then '26-DD' -- Dadra and Nagar Haveli and Daman and Diu
          when cus.Region = 'DL' then '07-DL' -- Delhi
          when dr_cusn.Region = 'DL' then '07-DL' -- Delhi
          when cus.Region = 'DH' then '26-DH' -- Dadra and Nagar Haveli and Daman and Diu (duplicate of DD)
          when dr_cusn.Region = 'DH' then '26-DH' -- Dadra and Nagar Haveli and Daman and Diu (duplicate of DD)
          when cus.Region = 'GA' then '30-GA' -- Goa
          when dr_cusn.Region = 'GA' then '30-GA' -- Goa
          when cus.Region = 'GJ' then '24-GJ' -- Gujarat
          when dr_cusn.Region = 'GJ' then '24-GJ' -- Gujarat
          when cus.Region = 'HP' then '02-HP' -- Himachal Pradesh
          when dr_cusn.Region = 'HP' then '02-HP' -- Himachal Pradesh
          when cus.Region = 'HR' then '06-HR' -- Haryana
          when dr_cusn.Region = 'HR' then '06-HR' -- Haryana
          when cus.Region = 'JH' then '20-JH' -- Jharkhand
          when dr_cusn.Region = 'JH' then '20-JH' -- Jharkhand
          when cus.Region = 'JK' then '01-JK' -- Jammu and Kashmir
          when dr_cusn.Region = 'JK' then '01-JK' -- Jammu and Kashmir
          when cus.Region = 'KA' then '29-KA' -- Karnataka
          when dr_cusn.Region = 'KA' then '29-KA' -- Karnataka
          when cus.Region = 'KL' then '32-KL' -- Kerala
          when dr_cusn.Region = 'KL' then '32-KL' -- Kerala
          when cus.Region = 'LA' then '38-LA' -- Ladakh
          when dr_cusn.Region = 'LA' then '38-LA' -- Ladakh
          when cus.Region = 'LD' then '31-LD' -- Lakshadweep
          when dr_cusn.Region = 'LD' then '31-LD' -- Lakshadweep
          when cus.Region = 'MH' then '27-MH' -- Maharashtra
          when dr_cusn.Region = 'MH' then '27-MH' -- Maharashtra
          when cus.Region = 'ML' then '17-ML' -- Meghalaya
          when dr_cusn.Region = 'ML' then '17-ML' -- Meghalaya
          when cus.Region = 'MN' then '14-MN' -- Manipur
          when dr_cusn.Region = 'MN' then '14-MN' -- Manipur
          when cus.Region = 'MP' then '23-MP' -- Madhya Pradesh
          when dr_cusn.Region = 'MP' then '23-MP' -- Madhya Pradesh
          when cus.Region = 'MZ' then '15-MZ' -- Mizoram
          when dr_cusn.Region = 'MZ' then '15-MZ' -- Mizoram
          when cus.Region = 'NL' then '13-NL' -- Nagaland
          when dr_cusn.Region = 'NL' then '13-NL' -- Nagaland
          when cus.Region = 'OD' then '21-OD' -- Odisha
          when dr_cusn.Region = 'OD' then '21-OD' -- Odisha
          when cus.Region = 'PB' then '03-PB' -- Punjab
          when dr_cusn.Region = 'PB' then '03-PB' -- Punjab
          when cus.Region = 'PY' then '34-PY' -- Puducherry
          when dr_cusn.Region = 'PY' then '34-PY' -- Puducherry
          when cus.Region = 'RJ' then '08-RJ' -- Rajasthan
          when dr_cusn.Region = 'RJ' then '08-RJ' -- Rajasthan
          when cus.Region = 'SK' then '11-SK' -- Sikkim
          when dr_cusn.Region = 'SK' then '11-SK' -- Sikkim
          when cus.Region = 'TS' then '36-TS' -- Telangana
          when dr_cusn.Region = 'TS' then '36-TS' -- Telangana
          when cus.Region = 'TN' then '33-TN' -- Tamil Nadu
          when dr_cusn.Region = 'TN' then '33-TN' -- Tamil Nadu
          when cus.Region = 'TR' then '16-TR' -- Tripura
          when dr_cusn.Region = 'TR' then '16-TR' -- Tripura
          when cus.Region = 'UK' then '05-UK' -- Uttarakhand
          when dr_cusn.Region = 'UK' then '05-UK' -- Uttarakhand
          when cus.Region = 'UP' then '09-UP' -- Uttar Pradesh
          when dr_cusn.Region = 'UP' then '09-UP' -- Uttar Pradesh
          when cus.Region = 'WB' then '19-WB' -- West Bengal
          when dr_cusn.Region = 'WB' then '19-WB' -- West Bengal
          when BDC.DistributionChannel = '02'then '97'
          else null 
          end as State,
          
      
      case
            when cus.TaxNumber3 is not initial then 'B2B'
            when dr_cusn.TaxNumber3 is not initial then 'B2B'
            when BDC.DistributionChannel = '30'then 'EXP'
            when cus.TaxNumber3 is initial and BDC.TotalNetAmount > abap.dec'000000000100000' then 'B2CL'
            when dr_cusn.TaxNumber3 is initial and DR_CUS.AbsltAmtInAdditionalCurrency1 > abap.dec'000000000100000' then 'B2CL'
            when cus.TaxNumber3 is initial and BDC.TotalNetAmount < abap.dec'000000000100000' then 'B2CS'
            when dr_cusn.TaxNumber3 is initial and DR_CUS.AbsltAmtInAdditionalCurrency1 < abap.dec'000000000100000' then 'B2CS'
            
            when BDC.BillingDocumentType = 'L2' and cus.TaxNumber3 is not initial then 'CDNR'
            when BDC.BillingDocumentType = 'G2' and cus.TaxNumber3 is not initial then 'CDNR'
            when BDC.BillingDocumentType = 'L2' and cus.TaxNumber3 is  initial then 'CDNUR'
            when BDC.BillingDocumentType = 'G2' and cus.TaxNumber3 is  initial then 'CDNUR'

            else null end  as Supplytype1,
      case
           when Pla.Plant is not initial then Pla.Plant
           when DR_CUS.BusinessPlace is not initial then DR_CUS.BusinessPlace
           else null end as plant,
/////////      Pla.Plant,
      Pla.PlantName,
//      jei.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
            when BDC.DistributionChannel = '30' then ( Jei.CreditAmountInCoCodeCrcy * -1 )
            else null end as ExportAmount      
      
    
}
where 


Jei.GLAccountType = 'P' 
 and (   Jei.TaxCode = 'AA' or Jei.TaxCode = 'AB' or Jei.TaxCode = 'AC' or Jei.TaxCode = 'AD' 
         or Jei.TaxCode = 'AE' or Jei.TaxCode = 'AG' or Jei.TaxCode = 'AH'
         or Jei.TaxCode = 'AI' or Jei.TaxCode = 'AO' or Jei.TaxCode = 'A0' or Jei.TaxCode = 'T0' or Jei.TaxCode = 'AQ' or Jei.TaxCode is initial)

and ( Jei.GLAccount != '0000400102' ) // This logic work on skip the duplicate line item for Sales-Commission
and ( Jei.GLAccount != '0000400100' ) // This logic work on skip the duplicate line item for Sales-Discount (SD)
and ( Jei.GLAccount != '0000400101' ) // This logic work on skip the duplicate line item for Sales-Freight
and ( Jei.GLAccount != '0000400103' ) // This logic work on skip the duplicate line item for Sales reverse manual
and ( Jei.GLAccount != '0000649005' ) // This logic work on skip the duplicate line item for Rounding Off Expenes
and ( Jei.GLAccount != '0000635002' ); // this logic work on skip the duplicate line item for Carriage Outward
//and ( Jei.AccountingDocumentType = 'RV' or Jei.AccountingDocumentType = 'DG' or Jei.AccountingDocumentType = 'SA' 
      
//      or Jei.AccountingDocumentType = 'DZ' or Jei.AccountingDocumentType = 'DA' or Jei.AccountingDocumentType = 'DR'  );  // this line new 20.03.2025
       
