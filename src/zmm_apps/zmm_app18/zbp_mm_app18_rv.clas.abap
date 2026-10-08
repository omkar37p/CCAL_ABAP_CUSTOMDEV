CLASS zbp_mm_app18_rv DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zmm_app18_rv.
  PUBLIC SECTION.
****--- PDF Print view Data Declaration---------------
    CLASS-DATA : gs_xmldata       TYPE string,
                 gs_print_data    TYPE xstring,
                 gs_pqitem_id     TYPE sysuuid_c32,
                 gv_ponum         TYPE ebeln,

                 gs_print_data_dc TYPE xstring,
                 gs_pqitem_id_dc  TYPE sysuuid_c32,
                 gs_print_data_tc TYPE xstring,
                 gs_pqitem_id_tc  TYPE sysuuid_c32,

                 gv_tag_oc        TYPE string,
                 gv_tag_dc        TYPE string,
                 gv_tag_tc        TYPE string,
                 gv_printq        TYPE c LENGTH 32.
ENDCLASS.



CLASS ZBP_MM_APP18_RV IMPLEMENTATION.
ENDCLASS.
