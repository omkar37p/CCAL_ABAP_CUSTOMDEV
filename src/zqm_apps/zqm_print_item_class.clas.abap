CLASS zqm_print_item_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZQM_PRINT_ITEM_CLASS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
**********************************************************************
    if not io_request->is_data_requested(  ).
        RETURN.
    endif.

    DATA(lo_filter) = io_request->get_filter(  ).
    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
      data(lo_error) = 1.
    ENDTRY.
**********************************************************************
    IF NOT line_exists( lt_range[ name = 'UUID' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.
**********************************************************************
    DATA rt_table TYPE TABLE OF ZQM_HEAD_CE.
    DATA rt_item type table of zqm_item_ce.
**********************************************************************
    LOOP AT lt_range[ name = 'UUID' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
    data(lv_inuuid) = <ls_range>-low.

    SELECT single Uuid,Inspection from zqm_head_rv wiTH PRIVILEGED ACCESS
    where Uuid = @lv_inuuid
    into @data(ls_insp).

**********************************************************************
    select * from ZQM_RESULT_VIEW WITH PRIVILEGED ACCESS
    where InspectionLot = @ls_insp-Inspection
    into table @data(lt_item).
    if lt_item is not INITIAL.
        sort lt_item ASCENDING BY InspectionCharacteristic.
              loop at lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
              if <ls_item> is ASSIGNED.
              INSERT VALUE zqm_item_ce( uuid = ls_insp-Uuid
                                        inspectionlot = <ls_item>-InspectionLot
                                        inspplanoperationinternalid = <ls_item>-InspPlanOperationInternalID
                                        inspectioncharacteristic = <ls_item>-InspectionCharacteristic
                                        inspectioncharacteristictext = <ls_item>-InspectionCharacteristicText
                                        inspectionspecification = <ls_item>-InspectionSpecification
                                        inspectioncodetext = <ls_item>-inspectioncodetext
                                        personfullname = <ls_item>-personfullname
                                        indicators = <ls_item>-Indicators
                                        unitofmeasuretechnicalname = <ls_item>-UnitOfMeasureTechnicalName
                                        inspectionspecificationunit = <ls_item>-InspectionSpecificationUnit
                                        inspectionresultmeanvalue = <ls_item>-InspectionResultMeanValue
                                        inspectionmeth = <ls_item>-InspectionMeth
                                        resultmeanvalue = <ls_item>-ResultMeanValue
                                        inspspecificationname = <ls_item>-InspSpecificationName )
                                        into table rt_item.

              endif.
              endloop.
            io_response->set_data( rt_item ).
            io_response->set_total_number_of_records( lines( rt_item ) ).
    endif.
**********************************************************************
*    if ls_insp is not INITIAL.
*
*            INSERT VALUE zqm_head_ce(   inspection = ls_insp-Inspection
*                                        uuid           = ls_insp-Uuid
*                                        reportissueon  = ls_insp-Reportissueon
*                                        serialno       = ls_insp-Serialno
*                                        product        = ls_insp-Product
*                                        productdesc    = ls_insp-Productdesc
*                                        ulrnum         = ls_insp-Ulrnum
*                                        discipline     = ls_insp-Discipline
*                                        coagroup       = ls_insp-Coagroup
*                                        customer       = ls_insp-Customer
*                                        truckno        = ls_insp-Truckno
*                                        issuedto       = ls_insp-Issuedto
*                                        partyaddress   = ls_insp-Partyaddress
*                                        reference      = ls_insp-Reference
*                                        samplereceipt  = ls_insp-Samplereceipt
*                                        dateofanalyis  = ls_insp-Dateofanalyis
*                                        batch          = ls_insp-Batch
*                                        description    = ls_insp-Description
*                                        plant          = ls_insp-Plant
*                                        nablformat     = ls_insp-Nablformat
*                                        termscond      = ls_insp-Termscond
*                                        mfgdate        = ls_insp-Mfgdate
*                                        reportno       = ls_insp-Reportno
*                                        status         = ls_insp-Status
*                                        itmcnt         = ls_insp-Itmcnt
*                                        mark           = ls_insp-Mark
*                                        driver         = ls_insp-Driver
*                                        conc           = ls_insp-Conc
*                                        createdby      = ls_insp-Createdby
*                                        createdat      = ls_insp-Createdat
*                                        lastchangedby  = ls_insp-Lastchangedby
*                                        lastchangedat  = ls_insp-Lastchangedat )
*                                        into table rt_table.
**    io_response->set_data( rt_table ).
**    io_response->set_total_number_of_records( lines( rt_table ) ).
*
*    endif.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
