CLASS cl_xco_cds_annotations DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_annotations.

* it_names: annotation names, structured values also by their nested paths
    METHODS constructor
      IMPORTING
        it_names TYPE string_table.

  PRIVATE SECTION.
    DATA mt_names TYPE string_table.
ENDCLASS.

CLASS cl_xco_cds_annotations IMPLEMENTATION.
  METHOD constructor.
* annotation names are not case sensitive
    LOOP AT it_names INTO DATA(lv_name).
      APPEND to_upper( lv_name ) TO mt_names.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_xco_cds_annotations~contain.
    DATA(lv_property) = to_upper( condense( iv_property ) ).
    rv_contain = xsdbool( line_exists( mt_names[ table_line = lv_property ] ) ).
  ENDMETHOD.

  METHOD if_xco_cds_annotations~pick.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.
