CLASS cl_xco_cds_annotations DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_xco_cds_annotations.

* it_annotations: by name, structured values also by their nested paths
    METHODS constructor
      IMPORTING
        it_annotations TYPE cl_xco_runtime_ddic=>ty_annotations.

  PRIVATE SECTION.
    DATA mt_annotations TYPE cl_xco_runtime_ddic=>ty_annotations.
ENDCLASS.

CLASS cl_xco_cds_annotations IMPLEMENTATION.
  METHOD constructor.
* annotation names are not case sensitive
    LOOP AT it_annotations INTO DATA(ls_annotation).
      ls_annotation-name = to_upper( ls_annotation-name ).
      APPEND ls_annotation TO mt_annotations.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_xco_cds_annotations~contain.
    DATA(lv_property) = to_upper( condense( iv_property ) ).
    rv_contain = xsdbool( line_exists( mt_annotations[ name = lv_property ] ) ).
  ENDMETHOD.

  METHOD if_xco_cds_annotations~pick.
* unbound if the annotation is not contained
    DATA(lv_property) = to_upper( condense( iv_property ) ).
    READ TABLE mt_annotations INTO DATA(ls_annotation) WITH KEY name = lv_property.
    IF sy-subrc = 0.
      ro_annotation = NEW cl_xco_cds_annotation( ls_annotation-value ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
