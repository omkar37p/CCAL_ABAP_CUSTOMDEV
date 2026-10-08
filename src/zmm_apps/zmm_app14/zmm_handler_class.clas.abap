CLASS zmm_handler_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_HANDLER_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DATA : IT_HEADER TYPE TABLE FOR CREATE ZMM_APP14_RV.

  IT_HEADER = VALUE #( ( Gpnum = '900000111' Gptype = 'RGP'  Vendnum = 1100 Mark = 'X' Plant = '1100'
  %control = VALUE #( Gpnum = if_abap_behv=>mk-on
                      Gptype = if_abap_behv=>mk-on
                      Vendnum = if_abap_behv=>mk-on
                      Mark = if_abap_behv=>mk-off
                      Plant = if_abap_behv=>mk-on
   )
    ) ).
MODIFY ENTITIES OF zmm_app14_rv
ENTITY _hdr
CREATE FROM it_header
MAPPED DATA(IT_MAPPED)
FAILED DATA(IT_FAILED)
REPORTED DATA(IT_REPORTED).
IF it_failed IS INITIAL.
COMMIT ENTITIES.

ELSE.
out->write( EXPORTING
data = it_header
name = 'FAILED'
*RECEIVING
*output
).

ENDIF.
  ENDMETHOD.
ENDCLASS.
