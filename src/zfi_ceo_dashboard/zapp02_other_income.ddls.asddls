@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Other Income AGG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZAPP02_OTHER_INCOME
  as select from ZAPP02_OTHER_INCOME_AGG as A
left outer join ZAPP02_SALES as B on B.CompanyCode = A.CompanyCode
                                 and B.Fiscal_Period = A.Fiscal_Period
                                 and B.Fiscal_Year   = A.Fiscal_Year
                                 and B.Product       = A.Product
{
    key A.CompanyCode,
       A. Fiscal_Period,
       A. Fiscal_Year,
       A. TransactionCurrency,
       A. Product,
       A. GLAccount,

sum(
    case
        when A.VariableCostCategory = 'OTHER_INCOME'
        then cast(A. AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as OTHER_INCOME,

  sum(
    case
        when A. VariableCostCategory = 'FG_WIP'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as FG_WIPCost,

sum(
    case
        when A.VariableCostCategory = 'POWER'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as PowerCost,

sum(
    case
        when A.VariableCostCategory = 'FUEL'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as FuelCost,

sum(
    case
        when A.VariableCostCategory = 'STORES_CONSUMABLE'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as StoresConsumableCost,

sum(
    case
        when A.VariableCostCategory = 'LABOUR'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as LabourCost,

sum(
    case
        when A.VariableCostCategory = 'Raw Materials'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Raw_Materials,

sum(
    case
        when A.VariableCostCategory = 'Depreciation'
        then cast(A. AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Depreciation,

sum(
    case
        when A.VariableCostCategory = 'Employees R & B'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Employees_R_B,


sum(
    case
        when A.VariableCostCategory = 'R & M-Machinery'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as R_M_Machinery,

  sum(
    case
        when A.VariableCostCategory = 'Insurance'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Insurance,

sum(
    case
        when A.VariableCostCategory = 'Trvelling Expenses'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Travelling_Expenses,

sum(
    case
        when A.VariableCostCategory = 'Miscellaneous Expe'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Miscellaneous_Expenses,

sum(
    case
        when A.VariableCostCategory = 'Director Rem'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Director_Remuneration,

sum(
    case
        when A.VariableCostCategory = 'Frt_ED paid'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Frt_ED_paid,

sum(
    case
        when A.VariableCostCategory = 'Auditors Rem'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Auditors_Remuneration,

sum(
    case
        when A.VariableCostCategory = 'Finance Charges'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Finance_Charges,

sum(
    case
        when A.VariableCostCategory = 'Trading Profit'
        then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
        else cast( 0 as abap.dec(23,2) )
    end
) as Trading_Profit,

     
     /*  ********* Variable Cost ********** */

(
    sum(
        case
            when A.VariableCostCategory = 'Raw Materials'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
 
    +
    
    sum(
        case
            when A.VariableCostCategory = 'FG_WIP'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'POWER'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
        
        )
    +
    sum(
        case
            when A.VariableCostCategory = 'Depreciation'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'FUEL'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'STORES_CONSUMABLE'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'LABOUR'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
) as TotalVariableCost,
    
        /*  ************* contribution *************** */
   
   (
    sum(
        case
            when A.VariableCostCategory = 'Employees R & B'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
 
    +
    
    sum(
        case
            when A. VariableCostCategory = 'R & M-Machinery'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'Insurance'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
        
        )
    +
    sum(
        case
            when A.VariableCostCategory = 'Trvelling Expenses'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'Miscellaneous Expe'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'Director Rem'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    +
    sum(
        case
            when A.VariableCostCategory = 'Frt_ED paid'
            then cast(A. AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
    
    +
    sum(
        case
            when A.VariableCostCategory = 'Auditors Rem'
            then cast( A.AmountInCompanyCodeCurrency as abap.dec(23,2) )
            else cast( 0 as abap.dec(23,2) )
        end
    )
  
) as Fixed_Cost,
         @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    B.TotalQuantity,
         @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    B.TotalConversionQuantity,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    B.TotalAmount,
    B.BillingQuantityUnit,
//    B.TransactionCurrency,
    B.MTN_SaleValue_Per_Quantity,
    B.ECU_SaleValue_Per_Quantity,
    B.NR_SaleValue_Per_Quantity

}
group by

    A.CompanyCode,
    A.Fiscal_Period,
    A.Fiscal_Year,
    A.Product,
    A.GLAccount,
    A.TransactionCurrency,
    B.TotalQuantity,
    B.TotalConversionQuantity,
    B.TotalAmount,
    B.BillingQuantityUnit,
//    B.TransactionCurrency,
    B.MTN_SaleValue_Per_Quantity,
    B.ECU_SaleValue_Per_Quantity,
    B.NR_SaleValue_Per_Quantity;







