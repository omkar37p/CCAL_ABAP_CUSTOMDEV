@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase order Reversed Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PO_GR_AGG
  as select from ZI_POAMT as A
{
  key A.BudgetCode,
      A.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum(A.POAmt) as UsedbdgAmt
//  key PH.PurchaseOrderItem,
//
//  sum(
//      case
//          when PH.PurchasingHistoryCategory = 'E'
//          then
//              case
//                  when PH.DebitCreditCode = 'H'
//                  then - cast( PH.PurOrdAmountInCompanyCodeCrcy as abap.dec(23,2) )
//                  else   cast( PH.PurOrdAmountInCompanyCodeCrcy as abap.dec(23,2) )
//              end
//          else 0
//      end
//  ) as GRAmount
}
group by  
  A.BudgetCode,
  A.DocumentCurrency
