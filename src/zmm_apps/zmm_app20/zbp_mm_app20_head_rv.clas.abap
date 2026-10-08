CLASS zbp_mm_app20_head_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app20_head_rv.

    TYPES : get_head TYPE table of zmm_reject_hdb.
    TYPES : get_item type table of zmm_reject_idb.

    PUBLIC SECTION.
        CLASS-DATA: gt_header TYPE table of zmm_reject_hdb,
                   gt_upheader type table of zmm_reject_hdb,
                   update_form TYPE TABLE of zmm_reject_hdb,

                   gt_item type table of zmm_reject_idb,
                   gt_getitems TYPE table of zmm_reject_idb,
                   gt_upitem type table of zmm_reject_idb.

   CLASS-METHODS Get_pdf_xml
        IMPORTING
            im_head TYPE get_head
            im_item TYPE get_item
        EXPORTING
            ex_base_64 TYPE string.

ENDCLASS.



CLASS ZBP_MM_APP20_HEAD_RV IMPLEMENTATION.


METHOD get_pdf_xml.

*        DATA: wa_head TYPE zmm_reject_hdb,
*              lv_xml TYPE string,
*              lv_counter type i VALUE 1.
***********************************************************************
*        get TIME STAMP FIELD DATA(ts).
*        CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
***********************************************************************
*            data(wa_rejhead) = im_head[ 1 ].
*
***********************************************************************
*            SELECT SINGLE * from zmm_migo_head WITH PRIVILEGED ACCESS
*            WHERE MaterialDocument = @wa_rejhead-materialdocument
*            and MaterialDocumentYear = @wa_rejhead-materialdocumentyear
*            into @data(wa_headout).
***********************************************************************
*            DATA(wa_postal) = |{ wa_headout-CityName } { wa_headout-PostalCode }|.
***********************************************************************
*
*            lv_xml = |<?xml version="1.0" encoding="UTF-8"?>| &&
*                        |<form1>| &&
*                            |<Main>| &&
*                            |<CoAdd>| &&
*                                |<ComName>| && wa_headout-PlantName && |</ComName>| &&
*                                |<add1>| && wa_headout-Streetone && |</add1>| &&
*                                |<add2>| && wa_headout-Streettwo && |</add2>| &&
*                                |<gstin>| && wa_headout-gstin && |</gstin>| &&
*                                |<cin>| && wa_headout-cin && |</cin>| &&
*                                |<Plant>| && wa_headout-Plant && |</Plant>| &&
*                            |</CoAdd>| &&
*                            |<Supp>| &&
*                                |<SuName>| && wa_headout-SupplierFullName && |</SuName>| &&
*                                |<Add1>| && wa_headout-street1 && |</Add1>| &&
*                                |<Add2>| && wa_headout-street2 && |</Add2>| &&
*                                |<Add3>| && wa_postal && |</Add3>| &&
*                                |<gstin>| && wa_headout-supgstin && |</gstin>| &&
*                                |<email>| && wa_headout-EmailAddress && |</email>| &&
*                            |</Supp>| &&
*                            |<Head>| &&
*                                |<MDNNo>| && wa_rejhead-mdnno && |</MDNNo>| &&
*                                |<MDNDate>| && wa_rejhead-mdndate && |</MDNDate>| &&
*                                |<grnNo>| && wa_headout-MaterialDocument && |</grnNo>| &&
*                                |<grndate>| && wa_headout-Migodate && |</grndate>| &&
*                                |<invoiceno>| && wa_headout-InvoiceNo && |</invoiceno>| &&
*                                |<invoicedate>| && wa_headout-Invoicedate && |</invoicedate>| &&
*                                |<PoNo>| && wa_headout-PurchaseOrder && |</PoNo>| &&
*                                |<podate>| && wa_headout-PurchaseOrderDate && |</podate>| &&
*                            |</Head>|.
*                      DATA(lv_count) = 1.
*                      LOOP at im_item INTO DATA(ls_item).
*                      lv_xml = lv_xml &&
*                            |<Item>| &&
*                            |<Table1>| &&
*                            |<HeaderRow/>| &&
*                            |<Row1>| &&
*                                |<slno>| && ls_item-materialdocumentitem && |</slno>| &&
*                                |<material>| && condense( |{ ls_item-material ALPHA = OUT }| ) && |</material>| &&
*                                |<descrip>| && ls_item-productdescription && |</descrip>| &&
*                                |<uom>| && ls_item-materialbaseunit && |</uom>| &&
*                                |<poqty>| && ls_item-poqty && |</poqty>| &&
*                                |<invoqty>| && ls_item-invoiceqty && |</invoqty>| &&
*                                |<recqty>| && ls_item-receivedqty && |</recqty>| &&
*                                |<accqty>| && ls_item-acceptedqty && |</accqty>| &&
*                                |<rejqty>| && ls_item-rejectedqty && |</rejqty>| &&
*                            |</Row1>| &&
*                            |</Table1>| &&
*                            |</Item>|.
*            lv_count += 1.
*            endloop.
*                        lv_xml = lv_xml &&
*                            |<Footer>| &&
*                                |<remarks>| && wa_rejhead-remark && |</remarks>| &&
*                                |<Predate></Predate>| &&
*                                |<Autdate></Autdate>| &&
*                            |</Footer>| &&
*                        |</Main>| &&
*                    |</form1>|.
*
*                    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH '&#38;'.
*                    ex_base_64 = cl_web_http_utility=>encode_base64( unencoded = lv_xml ).
ENDMETHOD.
ENDCLASS.
