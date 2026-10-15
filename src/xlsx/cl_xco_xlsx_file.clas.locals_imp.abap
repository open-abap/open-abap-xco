" sXML reader that hands out the attributes of an element together with its open node
CLASS lcl_xml_reader DEFINITION FINAL.
  PUBLIC SECTION.
    DATA mv_node_type TYPE if_sxml_node=>node_type READ-ONLY.
    " local name, without namespace prefix
    DATA mv_name TYPE string READ-ONLY.
    DATA mv_value TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_xml TYPE xstring.

    " abap_false when the end of the document is reached
    METHODS next
      RETURNING
        VALUE(rv_found) TYPE abap_bool.

    METHODS attribute
      IMPORTING
        iv_name         TYPE string
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS skip_element.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_attribute,
        name  TYPE string,
        value TYPE string,
      END OF ty_attribute.
    TYPES ty_attributes TYPE HASHED TABLE OF ty_attribute WITH UNIQUE KEY name.

    DATA mi_reader TYPE REF TO if_sxml_reader.
    DATA mt_attributes TYPE ty_attributes.
ENDCLASS.

CLASS lcl_xml_reader IMPLEMENTATION.
  METHOD constructor.
    mi_reader = cl_sxml_string_reader=>create( iv_xml ).
  ENDMETHOD.

  METHOD next.
    TRY.
        mi_reader->next_node( ).
      CATCH cx_sxml_parse_error INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.

    mv_node_type = mi_reader->node_type.
    mv_name = mi_reader->name.
    CLEAR: mv_value, mt_attributes.

    CASE mv_node_type.
      WHEN if_sxml_node=>co_nt_value.
        mv_value = mi_reader->value.
      WHEN if_sxml_node=>co_nt_element_open.
        DO.
          mi_reader->next_attribute( ).
          IF mi_reader->node_type <> if_sxml_node=>co_nt_attribute.
            EXIT.
          ENDIF.
          INSERT VALUE #( name  = mi_reader->name
                          value = mi_reader->value ) INTO TABLE mt_attributes.
        ENDDO.
    ENDCASE.

    rv_found = xsdbool( mv_node_type <> if_sxml_node=>co_nt_final ).
  ENDMETHOD.

  METHOD attribute.
    READ TABLE mt_attributes WITH TABLE KEY name = iv_name INTO DATA(ls_attribute).
    IF sy-subrc = 0.
      rv_value = ls_attribute-value.
    ENDIF.
  ENDMETHOD.

  METHOD skip_element.
    DATA(lv_depth) = 1.
    WHILE lv_depth > 0 AND next( ) = abap_true.
      CASE mv_node_type.
        WHEN if_sxml_node=>co_nt_element_open.
          lv_depth = lv_depth + 1.
        WHEN if_sxml_node=>co_nt_element_close.
          lv_depth = lv_depth - 1.
      ENDCASE.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.
