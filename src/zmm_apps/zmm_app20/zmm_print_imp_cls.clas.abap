CLASS zmm_print_imp_cls DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_PRINT_IMP_CLS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

**********************************************************************
    IF NOT io_request->is_data_requested(  ).
      RETURN.
    ENDIF.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
        DATA(lo_error) = 1.
    ENDTRY.
**********************************************************************
    IF NOT line_exists( lt_range[ name = 'UUID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
**********************************************************************
    DATA rt_table TYPE TABLE OF zrej_note_head_ce.

**********************************************************************
    LOOP AT lt_range[ name = 'UUID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).

      DATA(lv_inuuid) = <ls_range>-low.

      SELECT SINGLE * FROM zmm_app20_head_rv WITH PRIVILEGED ACCESS
      WHERE uuid = @lv_inuuid
      INTO @DATA(wa_uuid).

      SELECT SINGLE * FROM zmm_migo_head WITH PRIVILEGED ACCESS
      WHERE MaterialDocument = @wa_uuid-materialdocument
      and MaterialDocumentYear = @wa_uuid-materialdocumentyear
      INTO @DATA(wa_rejc).
     DATA(wa_postal) = |{ wa_rejc-CityName } { wa_rejc-PostalCode }|.
**********************************************************************
      IF wa_rejc IS NOT INITIAL.

        INSERT VALUE zrej_note_head_ce(     uuid   = wa_uuid-uuid
                                materialdocument  =   wa_rejc-materialdocument
  materialdocumentyear = wa_rejc-materialdocumentyear
  invoicedate          = wa_rejc-invoicedate
  migodate             = wa_rejc-migodate
  plant                = wa_rejc-plant
  invoiceno            = wa_rejc-invoiceno
  purchaseorder        = wa_rejc-purchaseorder
  purchaseorderitem    = wa_rejc-purchaseorderitem
  supplier             = wa_rejc-supplier
  companycode          = wa_rejc-companycode
  goodsmovementtype    = wa_rejc-goodsmovementtype
  purchaseorderdate    = wa_rejc-purchaseorderdate
  supplierfullname     = wa_rejc-supplierfullname
  street1              = wa_rejc-Streetone
  street2              = wa_rejc-Streettwo
  gstin                = wa_rejc-gstin
  cin                   = wa_rejc-cin
  cityname             = wa_rejc-cityname
  postalcode           = wa_rejc-postalcode
  country              = wa_rejc-country
  region               = wa_rejc-region
  mdnno                =  wa_uuid-mdnno
  mdn                  = wa_uuid-mdn
  mdndate              = wa_uuid-mdndate
  remark               = wa_uuid-remark
  personfullname       = wa_uuid-PersonFullName
  plantname            = wa_rejc-plantname
  createdby            = wa_uuid-createdby
  createdat            = wa_uuid-createdat
  lastchangedby        = wa_uuid-lastchangedby
  lastchangedat        = wa_uuid-lastchangedat
    add1            = wa_rejc-street1
  add2            = wa_rejc-street2
  add3            = wa_postal
  sgstin        = wa_rejc-supgstin
  semail        = wa_rejc-EmailAddress )

  INTO TABLE rt_table.
        io_response->set_data( rt_table ).
        io_response->set_total_number_of_records( lines( rt_table ) ).

      ENDIF.


    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
