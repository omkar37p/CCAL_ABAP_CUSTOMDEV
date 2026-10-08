CLASS zdemo_test_class_rp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZDEMO_TEST_CLASS_RP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


SELECT pp~accountingdocument,pp~accountingdocumenttype,pp~companycode,je~LedgerGLLineItem, pp~fiscalyear,je~amountintransactioncurrency,je~transactiontypedetermination
FROM I_PaymentProposalItem as pp left OUTER JOIN I_JournalEntryItem as je
        ON je~accountingdocument = pp~accountingdocument and je~companycode = pp~companycode and je~fiscalyear = pp~fiscalyear
        and ledger = '0L'
       WHERE paymentrundate = '20250624'
         and paymentdocument = '2000000034'
         and pp~companycode = '1000'
         INTO TABLE @data(gt_pi) .

if gt_pi is not initial.

SORT gt_pi BY accountingdocument LedgerGLLineItem transactiontypedetermination .
DELETE ADJACENT DUPLICATES FROM gt_pi COMPARING accountingdocument LedgerGLLineItem transactiontypedetermination .

*read table gt_pi into data(ls_tds) with key accountingdocumenttype = 'KR' transactiontypedetermination = 'WIT'. "WIT-TDS  KR-Vendor Invoice
*IF SY-SUBRC eq 0.
* out->write( 'TDS = ' ).
*   out->write( ABS( ls_tds-amountintransactioncurrency ) ). "TDS
*else.
*   out->write( 'TDS = 0.00' ).
*endif.

data: lv_zref02 type I_JournalEntryItem-amountintransactioncurrency.

loop at gt_pi into data(ls_tds) where ( accountingdocumenttype = 'KR' or accountingdocumenttype = 'RE' ) and transactiontypedetermination = 'WIT'. "WIT-TDS  KR-Vendor Invoice
    lv_zref02 += ABS( ls_tds-amountintransactioncurrency ). "TDS
    clear ls_tds.
endloop.

*paymentcustomerfields-zref02 = lv_zref02 .
out->write( lv_zref02 ).

if lv_zref02 is initial.
   out->write( 'TDS = 0.00' ).
endif.

read table gt_pi into data(ls_adp_KZ) with key accountingdocumenttype = 'KZ'. "A-Advance Payment  KZ-Vendor Payment
IF SY-SUBRC eq 0.
   out->write( 'Advance Payment KZ = ' ).
   out->write( ABS( ls_adp_KZ-amountintransactioncurrency ) ). "A-Advance Payment
else.
   read table gt_pi into data(ls_adp_KA) with key accountingdocumenttype = 'KA' . "A-Advance Payment  KA-Vendor Payment
   IF SY-SUBRC eq 0 and ls_adp_KA-amountintransactioncurrency <> space.
      out->write( 'Advance Payment KA = ' ).
      out->write( ABS( ls_adp_KA-amountintransactioncurrency ) ). "A-Advance Payment
   endif.
endif.

read table gt_pi into data(ls_cm) with key accountingdocumenttype = 'KG'.  "KG-Vendor Credit Memo
IF SY-SUBRC eq 0.
   out->write( 'Vendor Credit Memo = ' ).
   out->write( ABS( ls_cm-amountintransactioncurrency ) ). "Vendor Credit Memo
else.
   out->write( 'Vendor Credit Memo = 0.00' ).
endif.


Endif.

  ENDMETHOD.
ENDCLASS.
