CLASS lcl_tree_builder DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_json_tree_builder.

    TYPES ty_kind TYPE c LENGTH 1.
    TYPES:
      BEGIN OF ty_token,
        kind  TYPE ty_kind,
        value TYPE string,
      END OF ty_token,
      ty_tokens TYPE STANDARD TABLE OF ty_token WITH EMPTY KEY.

    CONSTANTS:
      BEGIN OF gc_kind,
        begin_object TYPE ty_kind VALUE 'O',
        end_object   TYPE ty_kind VALUE 'o',
        begin_array  TYPE ty_kind VALUE 'A',
        end_array    TYPE ty_kind VALUE 'a',
        member       TYPE ty_kind VALUE 'M',
        string       TYPE ty_kind VALUE 'S',
        number       TYPE ty_kind VALUE 'N',
        boolean      TYPE ty_kind VALUE 'B',
        null         TYPE ty_kind VALUE 'Z',
      END OF gc_kind.

    CLASS-METHODS number_to_text
      IMPORTING
        iv_value       TYPE any
      RETURNING
        VALUE(rv_text) TYPE string.

    METHODS add
      IMPORTING
        iv_kind  TYPE ty_kind
        iv_value TYPE string OPTIONAL.

    METHODS get_tokens
      RETURNING
        VALUE(rt_tokens) TYPE ty_tokens.

  PRIVATE SECTION.
    DATA mt_tokens TYPE ty_tokens.
ENDCLASS.

CLASS lcl_tree_builder IMPLEMENTATION.
  METHOD number_to_text.
    rv_text = |{ iv_value }|.
  ENDMETHOD.

  METHOD add.
    APPEND VALUE #( kind = iv_kind value = iv_value ) TO mt_tokens.
  ENDMETHOD.

  METHOD get_tokens.
    rt_tokens = mt_tokens.
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~begin_object.
    add( gc_kind-begin_object ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~end_object.
    add( gc_kind-end_object ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~begin_array.
    add( gc_kind-begin_array ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~end_array.
    add( gc_kind-end_array ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_member.
    add( iv_kind  = gc_kind-member
         iv_value = |{ iv_name }| ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_string.
    add( iv_kind  = gc_kind-string
         iv_value = |{ iv_value }| ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_number.
    add( iv_kind  = gc_kind-number
         iv_value = number_to_text( iv_value ) ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_boolean.
    add( iv_kind  = gc_kind-boolean
         iv_value = |{ iv_value }| ).
  ENDMETHOD.

  METHOD if_xco_json_tree_builder~add_null.
    add( gc_kind-null ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_data DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data.

    METHODS constructor
      IMPORTING
        it_tokens TYPE lcl_tree_builder=>ty_tokens.

  PRIVATE SECTION.
    DATA mt_tokens TYPE lcl_tree_builder=>ty_tokens.

    METHODS write_value
      CHANGING
        cv_index TYPE i
        cg_data  TYPE any.

    METHODS write_scalar
      IMPORTING
        iv_value TYPE string
      CHANGING
        cg_data  TYPE any.

    METHODS date_of
      IMPORTING
        iv_value       TYPE string
      RETURNING
        VALUE(rv_date) TYPE d.

    METHODS time_of
      IMPORTING
        iv_value       TYPE string
      RETURNING
        VALUE(rv_time) TYPE t.

    METHODS number_of
      IMPORTING
        iv_value         TYPE string
      RETURNING
        VALUE(rv_number) TYPE decfloat34.

    METHODS skip_value
      CHANGING
        cv_index TYPE i.

    METHODS quote
      IMPORTING
        iv_text        TYPE string
      RETURNING
        VALUE(rv_json) TYPE string.
ENDCLASS.

* Component names of a structure with the components of includes in place,
* named with the include suffixes, as RTTI and ASSIGN COMPONENT see them.
CLASS lcl_components DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS of
      IMPORTING
        io_structure         TYPE REF TO cl_abap_structdescr
        iv_suffix            TYPE string OPTIONAL
      RETURNING
        VALUE(rt_components) TYPE cl_abap_structdescr=>component_table.
ENDCLASS.

CLASS lcl_components IMPLEMENTATION.
  METHOD of.
    DATA(lt_components) = io_structure->get_components( ).
    LOOP AT lt_components INTO DATA(ls_component).
      IF ls_component-as_include = abap_true.
        APPEND LINES OF of( io_structure = CAST #( ls_component-type )
                            iv_suffix    = ls_component-suffix && iv_suffix ) TO rt_components.
      ELSE.
        ls_component-name = ls_component-name && iv_suffix.
        APPEND ls_component TO rt_components.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_data IMPLEMENTATION.
  METHOD constructor.
    mt_tokens = it_tokens.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~to_string.
    DATA lv_separate TYPE abap_bool.

    LOOP AT mt_tokens INTO DATA(ls_token).
      CASE ls_token-kind.
        WHEN lcl_tree_builder=>gc_kind-end_object.
          rv_string = rv_string && '}'.
          lv_separate = abap_true.
          CONTINUE.
        WHEN lcl_tree_builder=>gc_kind-end_array.
          rv_string = rv_string && ']'.
          lv_separate = abap_true.
          CONTINUE.
      ENDCASE.

      IF lv_separate = abap_true.
        rv_string = rv_string && ','.
      ENDIF.
      lv_separate = abap_true.

      CASE ls_token-kind.
        WHEN lcl_tree_builder=>gc_kind-begin_object.
          rv_string = rv_string && '{'.
          lv_separate = abap_false.
        WHEN lcl_tree_builder=>gc_kind-begin_array.
          rv_string = rv_string && '['.
          lv_separate = abap_false.
        WHEN lcl_tree_builder=>gc_kind-member.
          rv_string = rv_string && quote( ls_token-value ) && ':'.
          lv_separate = abap_false.
        WHEN lcl_tree_builder=>gc_kind-string.
          rv_string = rv_string && quote( ls_token-value ).
        WHEN lcl_tree_builder=>gc_kind-number.
          rv_string = rv_string && ls_token-value.
        WHEN lcl_tree_builder=>gc_kind-boolean.
          IF ls_token-value = abap_true.
            rv_string = rv_string && 'true'.
          ELSE.
            rv_string = rv_string && 'false'.
          ENDIF.
        WHEN lcl_tree_builder=>gc_kind-null.
          rv_string = rv_string && 'null'.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD quote.
    rv_json = '"' && escape( val    = iv_text
                             format = cl_abap_format=>e_json_string ) && '"'.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~traverse.
    io_visitor->on_start( ).

    LOOP AT mt_tokens INTO DATA(ls_token).
      CASE ls_token-kind.
        WHEN lcl_tree_builder=>gc_kind-begin_object.
          io_visitor->enter_object( ).
        WHEN lcl_tree_builder=>gc_kind-end_object.
          io_visitor->leave_object( ).
        WHEN lcl_tree_builder=>gc_kind-begin_array.
          io_visitor->enter_array( ).
        WHEN lcl_tree_builder=>gc_kind-end_array.
          io_visitor->leave_array( ).
        WHEN lcl_tree_builder=>gc_kind-member.
          io_visitor->visit_member( ls_token-value ).
        WHEN lcl_tree_builder=>gc_kind-string.
          io_visitor->visit_string( ls_token-value ).
        WHEN lcl_tree_builder=>gc_kind-number.
          io_visitor->visit_number( number_of( ls_token-value ) ).
        WHEN lcl_tree_builder=>gc_kind-boolean.
          io_visitor->visit_boolean( xsdbool( ls_token-value = abap_true ) ).
        WHEN lcl_tree_builder=>gc_kind-null.
          io_visitor->visit_null( ).
      ENDCASE.
    ENDLOOP.

    io_visitor->on_end( ).
  ENDMETHOD.

  METHOD number_of.
    TRY.
        rv_number = iv_value.
      CATCH cx_sy_conversion_error INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~apply.
    ro_data = me.
    LOOP AT it_transformations INTO DATA(lo_transformation).
      DATA(lo_tree_builder) = NEW lcl_tree_builder( ).
      ro_data->traverse( lo_transformation->get_visitor( lo_tree_builder ) ).
      ro_data = NEW lcl_json_data( lo_tree_builder->get_tokens( ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD if_xco_cp_json_data~write_to.
    DATA lv_index TYPE i VALUE 1.
    FIELD-SYMBOLS <lg_data> TYPE any.

    ASSIGN ia_data->* TO <lg_data>.
    IF lines( mt_tokens ) > 0.
      write_value( CHANGING cv_index = lv_index
                            cg_data  = <lg_data> ).
    ENDIF.
  ENDMETHOD.

  METHOD write_value.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA lr_line       TYPE REF TO data.
    FIELD-SYMBOLS <lg_component> TYPE any.
    FIELD-SYMBOLS <lt_table>     TYPE ANY TABLE.
    FIELD-SYMBOLS <lg_line>      TYPE any.

    READ TABLE mt_tokens INTO DATA(ls_token) INDEX cv_index.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    cv_index = cv_index + 1.
    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( cg_data ).

    CASE ls_token-kind.
      WHEN lcl_tree_builder=>gc_kind-begin_object.
        IF lo_type->kind = cl_abap_typedescr=>kind_struct.
          lt_components = lcl_components=>of( CAST #( lo_type ) ).
        ENDIF.
        DO.
          READ TABLE mt_tokens INTO ls_token INDEX cv_index.
          IF sy-subrc <> 0.
            RETURN.
          ENDIF.
          cv_index = cv_index + 1.
          IF ls_token-kind <> lcl_tree_builder=>gc_kind-member.
            EXIT.
          ENDIF.
          READ TABLE lt_components WITH KEY name = ls_token-value TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            ASSIGN COMPONENT ls_token-value OF STRUCTURE cg_data TO <lg_component>.
          ENDIF.
          IF sy-subrc = 0.
            write_value( CHANGING cv_index = cv_index
                                  cg_data  = <lg_component> ).
          ELSE.
            skip_value( CHANGING cv_index = cv_index ).
          ENDIF.
        ENDDO.
      WHEN lcl_tree_builder=>gc_kind-begin_array.
        IF lo_type->kind = cl_abap_typedescr=>kind_table.
          ASSIGN cg_data TO <lt_table>.
          CLEAR <lt_table>.
        ENDIF.
        DO.
          READ TABLE mt_tokens INTO ls_token INDEX cv_index.
          IF sy-subrc <> 0.
            RETURN.
          ENDIF.
          IF ls_token-kind = lcl_tree_builder=>gc_kind-end_array.
            cv_index = cv_index + 1.
            EXIT.
          ENDIF.
          IF lo_type->kind = cl_abap_typedescr=>kind_table.
            CREATE DATA lr_line LIKE LINE OF <lt_table>.
            ASSIGN lr_line->* TO <lg_line>.
            write_value( CHANGING cv_index = cv_index
                                  cg_data  = <lg_line> ).
            INSERT <lg_line> INTO TABLE <lt_table>.
          ELSE.
            skip_value( CHANGING cv_index = cv_index ).
          ENDIF.
        ENDDO.
      WHEN lcl_tree_builder=>gc_kind-null.
        CLEAR cg_data.
      WHEN OTHERS.
        IF lo_type->kind = cl_abap_typedescr=>kind_elem.
          write_scalar( EXPORTING iv_value = ls_token-value
                        CHANGING  cg_data  = cg_data ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD write_scalar.
    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( cg_data ).

    TRY.
        CASE lo_type->type_kind.
          WHEN cl_abap_typedescr=>typekind_date.
            cg_data = date_of( iv_value ).
          WHEN cl_abap_typedescr=>typekind_time.
            cg_data = time_of( iv_value ).
          WHEN cl_abap_typedescr=>typekind_hex OR cl_abap_typedescr=>typekind_xstring.
            cg_data = xco_cp_binary=>text_encoding->base64->if_xco_string_xstring_cnvrsn~apply( iv_value ).
          WHEN OTHERS.
            cg_data = iv_value.
        ENDCASE.
      CATCH cx_sy_conversion_error INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.
  ENDMETHOD.

  METHOD date_of.
    " YYYY-MM-DD as from_abap writes it, or YYYYMMDD; zeros stand for the initial date
    DATA(lv_value) = iv_value.
    IF strlen( lv_value ) = 10 AND lv_value+4(1) = '-' AND lv_value+7(1) = '-'.
      lv_value = lv_value(4) && lv_value+5(2) && lv_value+8(2).
    ENDIF.
    IF lv_value CO '0'.
      RETURN.
    ENDIF.

    " raises cx_xco_runtime_exception for anything but a valid date
    xco_cp_time=>format->abap->to_date( lv_value ).
    rv_date = lv_value.
  ENDMETHOD.

  METHOD time_of.
    " HH:MM:SS as from_abap writes it, or HHMMSS
    DATA(lv_value) = iv_value.
    IF strlen( lv_value ) = 8 AND lv_value+2(1) = ':' AND lv_value+5(1) = ':'.
      lv_value = lv_value(2) && lv_value+3(2) && lv_value+6(2).
    ENDIF.
    IF lv_value IS INITIAL.
      RETURN.
    ENDIF.

    " raises cx_xco_runtime_exception for anything but a valid time
    xco_cp_time=>format->abap->to_time( lv_value ).
    rv_time = lv_value.
  ENDMETHOD.

  METHOD skip_value.
    DATA lv_depth TYPE i.

    DO.
      READ TABLE mt_tokens INTO DATA(ls_token) INDEX cv_index.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      cv_index = cv_index + 1.
      CASE ls_token-kind.
        WHEN lcl_tree_builder=>gc_kind-begin_object OR lcl_tree_builder=>gc_kind-begin_array.
          lv_depth = lv_depth + 1.
        WHEN lcl_tree_builder=>gc_kind-end_object OR lcl_tree_builder=>gc_kind-end_array.
          lv_depth = lv_depth - 1.
        WHEN lcl_tree_builder=>gc_kind-member.
          CONTINUE.
      ENDCASE.
      IF lv_depth = 0.
        RETURN.
      ENDIF.
    ENDDO.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_data_builder DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES if_xco_cp_json_data_builder.

    METHODS constructor.

  PRIVATE SECTION.
    DATA mo_tree_builder TYPE REF TO lcl_tree_builder.
    DATA mi_tree_builder TYPE REF TO if_xco_json_tree_builder.
    " the kinds begin_object/begin_array of the objects and arrays still open, the innermost last
    DATA mv_open TYPE string.
    " the innermost object has a member name that waits for its value
    DATA mv_named TYPE abap_bool.
    " the value on the top level is complete
    DATA mv_complete TYPE abap_bool.

    METHODS innermost
      RETURNING
        VALUE(rv_kind) TYPE lcl_tree_builder=>ty_kind.

    METHODS begin_value.

    METHODS end_value.

    METHODS close
      IMPORTING
        iv_kind TYPE lcl_tree_builder=>ty_kind.
ENDCLASS.

CLASS lcl_json_data_builder IMPLEMENTATION.
  METHOD constructor.
    mo_tree_builder = NEW #( ).
    mi_tree_builder = mo_tree_builder.
  ENDMETHOD.

  METHOD innermost.
    IF mv_open IS NOT INITIAL.
      rv_kind = substring( val = mv_open
                           off = strlen( mv_open ) - 1 ).
    ENDIF.
  ENDMETHOD.

  METHOD begin_value.
    " a value stands alone, is an element of an array or follows the name of an object member
    DATA(lv_innermost) = innermost( ).
    IF ( lv_innermost IS INITIAL AND mv_complete = abap_true )
        OR ( lv_innermost = lcl_tree_builder=>gc_kind-begin_object AND mv_named = abap_false ).
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    mv_named = abap_false.
  ENDMETHOD.

  METHOD end_value.
    IF mv_open IS INITIAL.
      mv_complete = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD close.
    IF innermost( ) <> iv_kind OR mv_named = abap_true.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    mv_open = substring( val = mv_open
                         len = strlen( mv_open ) - 1 ).
    end_value( ).
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~begin_object.
    begin_value( ).
    mi_tree_builder->begin_object( ).
    mv_open = mv_open && lcl_tree_builder=>gc_kind-begin_object.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~end_object.
    close( lcl_tree_builder=>gc_kind-begin_object ).
    mi_tree_builder->end_object( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~begin_array.
    begin_value( ).
    mi_tree_builder->begin_array( ).
    mv_open = mv_open && lcl_tree_builder=>gc_kind-begin_array.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~end_array.
    close( lcl_tree_builder=>gc_kind-begin_array ).
    mi_tree_builder->end_array( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_member.
    IF innermost( ) <> lcl_tree_builder=>gc_kind-begin_object OR mv_named = abap_true.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    mi_tree_builder->add_member( iv_name ).
    mv_named = abap_true.
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_string.
    begin_value( ).
    mi_tree_builder->add_string( iv_value ).
    end_value( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_number.
    begin_value( ).
    mi_tree_builder->add_number( iv_value ).
    end_value( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_boolean.
    begin_value( ).
    mi_tree_builder->add_boolean( iv_value ).
    end_value( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~add_null.
    begin_value( ).
    mi_tree_builder->add_null( ).
    end_value( ).
    ro_me = me.
  ENDMETHOD.

  METHOD if_xco_cp_json_data_builder~get_data.
    IF mv_open IS NOT INITIAL.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.
    ro_data = NEW lcl_json_data( mo_tree_builder->get_tokens( ) ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_abap_to_json DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS convert
      IMPORTING
        ia_abap        TYPE any
      RETURNING
        VALUE(ro_data) TYPE REF TO if_xco_cp_json_data.

  PRIVATE SECTION.
    CLASS-METHODS write
      IMPORTING
        ia_abap         TYPE any
        io_tree_builder TYPE REF TO lcl_tree_builder.

    CLASS-METHODS write_elementary
      IMPORTING
        ia_abap         TYPE any
        io_type         TYPE REF TO cl_abap_typedescr
        io_tree_builder TYPE REF TO lcl_tree_builder.
ENDCLASS.

CLASS lcl_abap_to_json IMPLEMENTATION.
  METHOD convert.
    DATA(lo_tree_builder) = NEW lcl_tree_builder( ).
    write( ia_abap         = ia_abap
           io_tree_builder = lo_tree_builder ).
    ro_data = NEW lcl_json_data( lo_tree_builder->get_tokens( ) ).
  ENDMETHOD.

  METHOD write.
    FIELD-SYMBOLS <lg_component> TYPE any.
    FIELD-SYMBOLS <lt_table>     TYPE ANY TABLE.
    FIELD-SYMBOLS <lg_line>      TYPE any.

    DATA(lo_type) = cl_abap_typedescr=>describe_by_data( ia_abap ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        io_tree_builder->add( lcl_tree_builder=>gc_kind-begin_object ).
        DATA(lt_components) = lcl_components=>of( CAST #( lo_type ) ).
        LOOP AT lt_components INTO DATA(ls_component).
          ASSIGN COMPONENT ls_component-name OF STRUCTURE ia_abap TO <lg_component>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
          io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-member
                                iv_value = ls_component-name ).
          write( ia_abap         = <lg_component>
                 io_tree_builder = io_tree_builder ).
        ENDLOOP.
        io_tree_builder->add( lcl_tree_builder=>gc_kind-end_object ).
      WHEN cl_abap_typedescr=>kind_table.
        io_tree_builder->add( lcl_tree_builder=>gc_kind-begin_array ).
        ASSIGN ia_abap TO <lt_table>.
        LOOP AT <lt_table> ASSIGNING <lg_line>.
          write( ia_abap         = <lg_line>
                 io_tree_builder = io_tree_builder ).
        ENDLOOP.
        io_tree_builder->add( lcl_tree_builder=>gc_kind-end_array ).
      WHEN cl_abap_typedescr=>kind_elem.
        write_elementary( ia_abap         = ia_abap
                          io_type         = lo_type
                          io_tree_builder = io_tree_builder ).
      WHEN OTHERS.
        " references cannot be represented, on the system the conversion ends in XML_FORMAT_ERROR
        RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDCASE.
  ENDMETHOD.

  METHOD write_elementary.
    " as asJSON renders it: numbers as numbers, every other elementary type as a string
    DATA lv_text TYPE string.

    CASE io_type->type_kind.
      WHEN cl_abap_typedescr=>typekind_int
          OR cl_abap_typedescr=>typekind_int1
          OR cl_abap_typedescr=>typekind_int2
          OR cl_abap_typedescr=>typekind_int8
          OR cl_abap_typedescr=>typekind_packed
          OR cl_abap_typedescr=>typekind_decfloat16
          OR cl_abap_typedescr=>typekind_decfloat34
          OR cl_abap_typedescr=>typekind_float.
        io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-number
                              iv_value = lcl_tree_builder=>number_to_text( ia_abap ) ).
        RETURN.
      WHEN cl_abap_typedescr=>typekind_date.
        lv_text = ia_abap.
        lv_text = |{ lv_text(4) }-{ lv_text+4(2) }-{ lv_text+6(2) }|.
      WHEN cl_abap_typedescr=>typekind_time.
        lv_text = ia_abap.
        lv_text = |{ lv_text(2) }:{ lv_text+2(2) }:{ lv_text+4(2) }|.
      WHEN cl_abap_typedescr=>typekind_hex OR cl_abap_typedescr=>typekind_xstring.
        lv_text = xco_cp_binary=>text_encoding->base64->if_xco_xstring_string_cnvrsn~apply( CONV #( ia_abap ) ).
      WHEN OTHERS.
        lv_text = |{ ia_abap }|.
    ENDCASE.

    io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-string
                          iv_value = lv_text ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_json_parser DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS parse
      IMPORTING
        iv_json        TYPE string
      RETURNING
        VALUE(ro_data) TYPE REF TO if_xco_cp_json_data.

  PRIVATE SECTION.
    " the JSON flavour of the sXML reader reports every value as an element object, array,
    " str, num, bool or null, with its member name in the attribute name
    CLASS-METHODS read
      IMPORTING
        ii_reader       TYPE REF TO if_sxml_reader
        io_tree_builder TYPE REF TO lcl_tree_builder
      RAISING
        cx_sxml_parse_error.
ENDCLASS.

CLASS lcl_json_parser IMPLEMENTATION.
  METHOD parse.
    DATA(lo_tree_builder) = NEW lcl_tree_builder( ).
    TRY.
        read( ii_reader       = cl_sxml_string_reader=>create( cl_abap_conv_codepage=>create_out( )->convert( iv_json ) )
              io_tree_builder = lo_tree_builder ).
      CATCH cx_sxml_parse_error INTO DATA(lx_error).
        RAISE EXCEPTION NEW cx_xco_runtime_exception( previous = lx_error ).
    ENDTRY.

    IF lines( lo_tree_builder->get_tokens( ) ) = 0.
      RAISE EXCEPTION NEW cx_xco_runtime_exception( ).
    ENDIF.

    ro_data = NEW lcl_json_data( lo_tree_builder->get_tokens( ) ).
  ENDMETHOD.

  METHOD read.
    DATA li_open       TYPE REF TO if_sxml_open_element.
    DATA li_value      TYPE REF TO if_sxml_value_node.
    DATA lt_kinds      TYPE string_table.
    DATA lv_kind       TYPE string.
    DATA lv_text       TYPE string.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.

    DO.
      DATA(li_node) = ii_reader->read_next_node( ).
      IF li_node IS INITIAL.
        EXIT.
      ENDIF.

      CASE li_node->type.
        WHEN if_sxml_node=>co_nt_element_open.
          li_open ?= li_node.
          lv_kind = li_open->qname-name.
          APPEND lv_kind TO lt_kinds.
          CLEAR lv_text.

          lt_attributes = li_open->get_attributes( ).
          LOOP AT lt_attributes INTO DATA(li_attribute).
            IF li_attribute->qname-name = 'name'.
              io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-member
                                    iv_value = li_attribute->get_value( ) ).
            ENDIF.
          ENDLOOP.

          CASE lv_kind.
            WHEN 'object'.
              io_tree_builder->add( lcl_tree_builder=>gc_kind-begin_object ).
            WHEN 'array'.
              io_tree_builder->add( lcl_tree_builder=>gc_kind-begin_array ).
          ENDCASE.
        WHEN if_sxml_node=>co_nt_value.
          li_value ?= li_node.
          lv_text = li_value->get_value( ).
        WHEN if_sxml_node=>co_nt_element_close.
          READ TABLE lt_kinds INTO lv_kind INDEX lines( lt_kinds ).
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
          DELETE lt_kinds INDEX lines( lt_kinds ).

          CASE lv_kind.
            WHEN 'object'.
              io_tree_builder->add( lcl_tree_builder=>gc_kind-end_object ).
            WHEN 'array'.
              io_tree_builder->add( lcl_tree_builder=>gc_kind-end_array ).
            WHEN 'str'.
              io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-string
                                    iv_value = lv_text ).
            WHEN 'num'.
              io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-number
                                    iv_value = lv_text ).
            WHEN 'bool'.
              io_tree_builder->add( iv_kind  = lcl_tree_builder=>gc_kind-boolean
                                    iv_value = |{ xsdbool( lv_text = 'true' ) }| ).
            WHEN 'null'.
              io_tree_builder->add( lcl_tree_builder=>gc_kind-null ).
          ENDCASE.
        WHEN if_sxml_node=>co_nt_final.
          EXIT.
      ENDCASE.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
