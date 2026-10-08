@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGSTR1_NEW_RE
  as select from    I_BillingDocument              as BDC
    inner join      I_BillingDocumentItem          as BDI  on  BDI.BillingDocument     =  BDC.BillingDocument
    inner join I_JournalEntry                      as JEH  on  JEH.AccountingDocument = BDC.AccountingDocument
    //                                                  and Jei.AccountingDocumentItem = BDC.AccountingDocumentItem
                                                           and JEH.FiscalYear         = BDC.FiscalYear
                                                           and JEH.CompanyCode        = BDC.CompanyCode
                                                           
                                                           
        left outer join I_JournalEntryItem             as Jei  on  Jei.AccountingDocument = BDC.AccountingDocument
    //                                                  and Jei.AccountingDocumentItem = BDC.AccountingDocumentItem
                                                           and Jei.FiscalYear         = BDC.FiscalYear
                                                           and Jei.CompanyCode        = BDC.CompanyCode
                                                           and Jei.Ledger             = '0L'
                                                           and Jei.TaxCode            = 'T1'
                                                              //and Jei.OffsettingAccountType = 'D'
   left outer join I_OperationalAcctgDocItem as ACC  on  ACC.AccountingDocument = Jei.AccountingDocument
                                                      and ACC.FiscalYear         = Jei.FiscalYear
                                                      and ACC.CompanyCode        = Jei.CompanyCode
                                                      and ACC.AccountingDocumentItem = ACC.AccountingDocumentItem   
                                                           
    left outer join I_BillingDocumentItemPrcgElmnt as IGST on  IGST.BillingDocument     = BDI.BillingDocument
                                                           and IGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and IGST.ConditionType       = 'JOIG'



    left outer join I_BillingDocumentItemPrcgElmnt as ZGST on  ZGST.BillingDocument     = BDI.BillingDocument
                                                           and ZGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZGST.ConditionType       = 'ZIIG'
    left outer join I_BillingDocumentItemPrcgElmnt as CGST on  CGST.BillingDocument     = BDI.BillingDocument
                                                           and CGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CGST.ConditionType       = 'JOCG'
    left outer join I_BillingDocumentItemPrcgElmnt as ZCST on  ZCST.BillingDocument     = BDI.BillingDocument
                                                           and ZCST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZCST.ConditionType       = 'ZOCG'
    left outer join I_BillingDocumentItemPrcgElmnt as SGST on  SGST.BillingDocument     = BDI.BillingDocument
                                                           and SGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and SGST.ConditionType       = 'JOSG'

    left outer join I_BillingDocumentItemPrcgElmnt as ZSGT on  ZSGT.BillingDocument     = BDI.BillingDocument
                                                           and ZSGT.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZSGT.ConditionType       = 'ZOSG'

    left outer join I_BillingDocumentItemPrcgElmnt as CESS on  CESS.BillingDocument     = BDI.BillingDocument
                                                           and CESS.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CESS.ConditionType       = 'JCOS'

    left outer join I_ProductPlantBasic            as Hsn  on  Hsn.Product = BDI.Product
                                                           and Hsn.Plant   = BDI.Plant
    left outer join I_Customer                     as cus  on cus.Customer = BDI.BillToParty
    left outer join I_CustomerGroupText            as Cdc  on  Cdc.CustomerGroup = BDC.CustomerGroup
                                                           and Cdc.Language      = 'E'
    left outer join I_Region                       as Reg  on  Reg.Country = BDC.Country
    //                                                   and Reg.Language = 'E'
                                                           and Reg.Region  = BDC.Region

    left outer join I_Plant                        as Pla  on Pla.Plant = BDI.Plant

    left outer join I_IN_BusinessPlaceTaxDetail    as sup  on sup.BusinessPlace = Pla.BusinessPlace
    left outer join I_BillingDocumentBasic         as Bsc  on Bsc.BillingDocument = BDC.BillingDocument


                                                     
{
  key ACC.GLAccount  as GLAcc , 
  key BDI.BillingDocument      as billdoc,

  key BDI.BillingDocumentItem    as billitm,
  
  

      //key IGST.BillingDocument,

      //      key IGST.BillingDocumentItem,



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

      then concat(abap.char'Apr,',substring(Jei.FiscalYear, 3, 2))

      when '011'

      then concat(abap.char'May,',substring(Jei.FiscalYear, 3, 2))

      when '012'

      then concat(abap.char'Jun,',substring(Jei.FiscalYear, 3, 2))

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

      then concat(abap.char'Apr,',substring(Jei.FiscalYear, 3, 2))

      when '011'

      then concat(abap.char'May,',substring(Jei.FiscalYear, 3, 2))

      when '012'

      then concat(abap.char'Jun,',substring(Jei.FiscalYear, 3, 2))

      else null end   
                        as BAUTOFILLPERIOD,
                          

      //Jei.GLAcc  as RevenueAccount,

      IGST.PricingProcedureStep                                                                                                                                 as igststep,

      IGST.PricingProcedureCounter                                                                                                                              as igstcnt,

      //      cus.Customer                 as kunnr,

      //      Cdc.CustomerGroup            as kngrp,

      Cdc.Language                                                                                                                                              as lang,

      //      Hsn.Product                  as product,

      //      Hsn.Plant                    as plant,

      cus.CustomerName                                                                                                                                          as custname,

      cus.TaxNumber3                                                                                                                                            as taxno2,

      BDC.BillingDocumentDate                                                                                                                                   as billdate,

      BDC.BillingDocumentDate                                                                                                                                   as Fidocdate,

      BDC.StatisticsCurrency     as stcurr,



      @Semantics.amount.currencyCode: 'stcurr'



      //cast((get_numeric_value(BDI.NetAmount)+ get_numeric_value(BDI.TaxAmount)) * (BDI.PriceDetnExchangeRate) as abap.dec( 15,2 )) as tottaxamt,

      //cast((get_numeric_value(BDI.NetAmount)) as abap.dec( 15, 2) ) as tottaxamt,

      cast((get_numeric_value(BDI.NetAmount)) * (BDI.PriceDetnExchangeRate) as abap.dec( 15,2 )) as tottaxamt,



      @Semantics.amount.currencyCode: 'stcurr'

      //case IGST.ConditionType when 'JOIG'

      //then  cast( (get_numeric_value(BDI.TaxAmount) + get_numeric_value(IGST.ConditionRateValue) )  * (BDI.PriceDetnExchangeRate) as  abap.dec( 15,2 ) )

      //  else cast( BDI.TaxAmount as  abap.dec( 15,2 ) )

      //end  as totnetamt,

      case when BDC.BillingDocumentType = 'G2' then cast(0.00 as abap.dec(15,2))  //abap.decfloat34'0'

            when IGST.ConditionType = 'JOIG'

      then cast(((get_numeric_value(BDI.NetAmount)+get_numeric_value( IGST.ConditionAmount))* get_numeric_value(BDI.PriceDetnExchangeRate))as abap.dec( 15,2 ))

      when ZGST.ConditionType = 'ZIIG' then cast(((get_numeric_value(BDI.NetAmount)+get_numeric_value( ZGST.ConditionAmount))* get_numeric_value(BDI.PriceDetnExchangeRate))as abap.dec( 15,2 ))// + get_numeric_value( BDI.TaxAmount)

      else cast(((get_numeric_value(BDI.NetAmount)+ get_numeric_value( BDI.TaxAmount)) * get_numeric_value(BDI.PriceDetnExchangeRate))as abap.dec( 15,2 ))  end as totnetamt,

      //cast((get_numeric_value(BDI.NetAmount)+get_numeric_value( BDI.TaxAmount)) as abap.dec(15,2) ) as totnetamt,// + get_numeric_value( BDI.TaxAmount)

      BDC.AccountingExchangeRate                                                                                                                                as excgrate,

      BDI.ProductGroup   as prdgrp,



      //      case

      //      when   IGST.ConditionType       = 'JOIG' then IGST.ConditionRateValue

      //      when ZGST.ConditionType       = 'ZIIG' then ZGST.ConditionRateValue

      //     else null end as igstrate,

      //

      //      case

      //      when   CGST.ConditionType       = 'JOCG' then CGST.ConditionRateValue

      //      when ZCST.ConditionType       = 'ZOCG' then ZCST.ConditionRateValue

      //     else null end as cgstrate,

      //

      //      case

      //      when   CGST.ConditionType       = 'JOSG' then SGST.ConditionRateValue

      //      when ZSGT.ConditionType       = 'ZOSG' then ZSGT.ConditionRateValue

      //     else null end as sgstRate,

      //@Semantics.amount.currencyCode: 'igstcurr'

      case

       when CGST.ConditionType = 'JOCG' or SGST.ConditionType = 'JOSG'

       then (SGST.ConditionRateValue) + (SGST.ConditionRateValue)

        when ZCST.ConditionType       = 'ZOCG' or  ZSGT.ConditionType = 'ZOSG'

        then  (ZCST.ConditionRateValue) + (ZCST.ConditionRateValue)

        when IGST.ConditionType       = 'JOIG' then IGST.ConditionRateValue

        when ZGST.ConditionType       = 'ZIIG' then ZGST.ConditionRateValue

         else  null end                                                                                                                                         as Gstrate,











      @Semantics.amount.currencyCode: 'igstcurr'

      case

      when   IGST.ConditionType       = 'JOIG' then cast(get_numeric_value(IGST.ConditionAmount) * (BDI.PriceDetnExchangeRate )as abap.dec( 15,2 ))

      when ZGST.ConditionType       = 'ZIIG' then cast(get_numeric_value(ZGST.ConditionAmount) *(BDI.PriceDetnExchangeRate )as abap.dec( 15,2 ))

      else null end                                                                                                                                             as igstamt,

      @Semantics.amount.currencyCode: 'igstcurr'

      case

      when   CGST.ConditionType       = 'JOCG' then CGST.ConditionAmount

      when ZCST.ConditionType       = 'ZOCG' then ZCST.ConditionAmount

      else null end                                                                                                                                             as cgstamt,

      @Semantics.amount.currencyCode: 'igstcurr'

      case

      when   SGST.ConditionType       = 'JOSG' then SGST.ConditionAmount

      when ZSGT.ConditionType       = 'ZOSG' then ZSGT.ConditionAmount

      else null end                                                                                                                                             as sgstamt,





      IGST.ConditionCurrency                                                                                                                                    as IGSTCURR,



      @Semantics.amount.currencyCode: 'igstcurr'

      CESS.ConditionAmount                                                                                                                                      as Cessamt,

      BDI.BillingDocumentItemText                                                                                                                               as itmtxt,

      BDI.BaseUnit                                                                                                                                              as uom,

      //      bdi.PriceDetnExchangeRate  as Pexch,

      @Semantics.quantity.unitOfMeasure: 'uom'

      BDI.BillingQuantity                                                                                                                                       as billqty,

      Hsn.ConsumptionTaxCtrlCode                                                                                                                                as hsncode,

      IGST.ConditionType                                                                                                                                        as igstcntyp,

      CGST.ConditionType                                                                                                                                        as cgstcntyp,

      SGST.ConditionType                                                                                                                                        as sgstcntyp,

      sup.IN_GSTIdentificationNumber                                                                                                                            as SupplierGSTIN,





      /*  case when Reg.Region = 'AN' then '35'





  when Reg.Region = 'AP' then '28'

  when Reg.Region = 'AR' then '12'

  when Reg.Region = 'AS' then '18'

  when Reg.Region = 'BR' then '10'

  when Reg.Region = 'CG' then '22'

  when Reg.Region = 'CH' then '04'

  when Reg.Region = 'CT' then '22'

  when Reg.Region = 'DD' then '25'

  when Reg.Region = 'DH' then '26'

  when Reg.Region = 'DL' then '07'

  when Reg.Region = 'DN' then '26'

  when Reg.Region = 'GA' then '30'

  when Reg.Region = 'GJ' then '24'

  when Reg.Region = 'HP' then '02'

  when Reg.Region = 'HR' then '06'

  when Reg.Region = 'JH' then '20'

  when Reg.Region = 'JK' then '01'

  when Reg.Region = 'KA' then '29'

  when Reg.Region = 'KL' then '32'

  when Reg.Region = 'LA' then '38'

  when Reg.Region = 'LD' then '31'

  when Reg.Region = 'MH' then '27'

  when Reg.Region = 'ML' then '17'

  when Reg.Region = 'MN' then '14'

  when Reg.Region = 'MP' then '23'

  when Reg.Region = 'MZ' then '15'

  when Reg.Region = 'NL' then '13'

  when Reg.Region = 'OD' then '21'

  when Reg.Region = 'OR' then '21'

  when Reg.Region = 'PB' then '03'

  when Reg.Region = 'PY' then '34'

  when Reg.Region = 'RJ' then '08'

  when Reg.Region = 'SK' then '11'

  //when Reg.Region = 'TG' then ''

  when Reg.Region = 'TN' then '33'

  when Reg.Region = 'TR' then '16'

  when Reg.Region = 'TS' then '36'

  when Reg.Region = 'UK' then '05'

  when Reg.Region = 'UP' then '09'

  when Reg.Region = 'UT' then '05'

  when Reg.Region = 'WB' then '19'

  else null end                as State,*/

      case

          when cus.Region = 'AN' then '35' -- Andaman and Nicobar Islands

          when cus.Region = 'AP' then '37' -- Andhra Pradesh

          when cus.Region = 'AR' then '12' -- Arunachal Pradesh

          when cus.Region = 'AS' then '18' -- Assam

          when cus.Region = 'BR' then '10' -- Bihar

          when cus.Region = 'CG' then '22' -- Chhattisgarh

          when cus.Region = 'CH' then '04' -- Chandigarh

          when cus.Region = 'DD' then '26' -- Dadra and Nagar Haveli and Daman and Diu

          when cus.Region = 'DL' then '07' -- Delhi

          when cus.Region = 'DH' then '26' -- Dadra and Nagar Haveli and Daman and Diu (duplicate of DD)

          when cus.Region = 'GA' then '30' -- Goa

          when cus.Region = 'GJ' then '24' -- Gujarat

          when cus.Region = 'HP' then '02' -- Himachal Pradesh

          when cus.Region = 'HR' then '06' -- Haryana

          when cus.Region = 'JH' then '20' -- Jharkhand

          when cus.Region = 'JK' then '01' -- Jammu and Kashmir

          when cus.Region = 'KA' then '29' -- Karnataka

          when cus.Region = 'KL' then '32' -- Kerala

          when cus.Region = 'LA' then '38' -- Ladakh

          when cus.Region = 'LD' then '31' -- Lakshadweep

          when cus.Region = 'MH' then '27' -- Maharashtra

          when cus.Region = 'ML' then '17' -- Meghalaya

          when cus.Region = 'MN' then '14' -- Manipur

          when cus.Region = 'MP' then '23' -- Madhya Pradesh

          when cus.Region = 'MZ' then '15' -- Mizoram

          when cus.Region = 'NL' then '13' -- Nagaland

          when cus.Region = 'OD' then '21' -- Odisha

          when cus.Region = 'PB' then '03' -- Punjab

          when cus.Region = 'PY' then '34' -- Puducherry

          when cus.Region = 'RJ' then '08' -- Rajasthan

          when cus.Region = 'SK' then '11' -- Sikkim

          when cus.Region = 'TS' then '36' -- Telangana

          when cus.Region = 'TN' then '33' -- Tamil Nadu

          when cus.Region = 'TR' then '16' -- Tripura

          when cus.Region = 'UK' then '05' -- Uttarakhand

          when cus.Region = 'UP' then '09' -- Uttar Pradesh

          when cus.Region = 'WB' then '19' -- West Bengal

          when BDC.DistributionChannel = '02'then '97'

          else null

      end                                                                                                                                                       as State,





      //      Sup.                 as Suppler,

      //      Reg.RegionName               as Statecode,

      BDC.Division                                                                                                                                              as Divisionb,

      //      BDI.ProfitCenter             as ProfitCenter,



      case when BDC.BillingDocumentType = 'F2' then 'Tax Invoice'

            when BDC.BillingDocumentType = 'G2' then 'CDNR'

      else null end                                                                                                                                             as BillingType,



      BDC.AccountingDocument as Accdoc,

      BDC.OverallBillingStatus       as InStus,

      case BDC.BillingDocumentType when 'F2'

      then

      BDC.DocumentReferenceID  else null end                                                                                                                    as refdoc,

      //      abap.char' ' as supplytype,





      case

      //          when cus.TaxNumber3 = ''  then 'B2C'

      //          when cus.TaxNumber3 <> '' then 'B2B'

      when BDC.DistributionChannel =  '01' and  cus.TaxNumber3 = ''  then 'B2C'

      when BDC.DistributionChannel =  '01' and  cus.TaxNumber3 <> ''  then 'B2B'

      when BDC.DistributionChannel = '02'then 'EXP'

      when BDC.DistributionChannel = '03' then 'DEXP'

      when BDC.DistributionChannel = '04'  then 'SEZ'

      when cus.TaxNumber3 = '' and BDC.TotalNetAmount < abap.dec'000000000250000' then 'B2CS'

      when cus.TaxNumber3 <> '' and BDC.TotalNetAmount > abap.dec'000000000250000' then 'B2CL'

      else null end                                                                                                                                             as Supplytype1,





      /*case  when  BDC.BillingDocumentType  = 'F2' then 'Normal'

            when  BDC.BillingDocumentType = 'G2' then 'Normal'

            when BDI.TaxCode = 'AL' or BDI.TaxCode = 'AC'  then 'Nill Rated' ///and BDC.BillingDocumentType  = 'F2'

            else null end as Supply,*/

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

      else null end                                                                                                                                             as Supply,





      case when BDC.DistributionChannel = '02'then 'WPAY'

           when BDC.DistributionChannel = '04'then 'SEWOP'

            when  BDC.DistributionChannel = '02' and BDC.CustomerGroup = '09'then 'WOPAY'

            else null end                                                                                                                                       as ExportType,





      case BDC.BillingDocumentType

      when 'G2'

      then(BDC.DocumentReferenceID)

      else null end                                                                                                                                             as Notenumber,



      case BDC.BillingDocumentType

      when 'G2'

      then(BDC.BillingDocumentDate)

      else null end                                                                                                                                             as NoteDate,

      @Semantics.amount.currencyCode: 'stcurr'

      case when BDC.BillingDocumentType = 'G2' and IGST.ConditionType  = 'JOIG'

      then cast(get_numeric_value(BDC.TotalNetAmount) + get_numeric_value(IGST.ConditionAmount)  as abap.dec( 15, 2 ))

       when BDC.BillingDocumentType = 'G2' and CGST.ConditionType  = 'JOCG'

       then cast(get_numeric_value(BDC.TotalNetAmount) + (get_numeric_value(CGST.ConditionAmount)*2)  as abap.dec( 15, 2 ))

      else null end                                                                                                                                             as NoteValue,





      //      abap.char'' as ExportType,


      Pla.Plant,

      Pla.PlantName










}



where
 //BDC.BillingDocumentType <> 'F8'
  //and 
  //BDC.BillingDocumentType <> 'JSTO'
 //and 
 (   JEH.AccountingDocumentType = 'DR'
  or JEH.AccountingDocumentType = 'SA' 
  or JEH.AccountingDocumentType = 'DA' 
  or JEH.AccountingDocumentType = 'DG'
  or JEH.AccountingDocumentType = 'DZ' )
  
        
 
 and BDI.BillingQuantity is not initial;
